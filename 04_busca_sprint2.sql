-- =====================================================================
-- SPRINT 2 · Passos 1 e 2: busca em texto (português) + função buscar_livros
-- =====================================================================

-- 1) Coluna pesquisável, calculada sozinha a partir de título, autor e sinopse.
--    Título pesa mais (A), depois autor (B), depois sinopse (C).
alter table public.livro
  add column if not exists busca tsvector generated always as (
    setweight(to_tsvector('portuguese', coalesce(titulo,  '')), 'A') ||
    setweight(to_tsvector('portuguese', coalesce(autor,   '')), 'B') ||
    setweight(to_tsvector('portuguese', coalesce(sinopse, '')), 'C')
  ) stored;

-- 2) Índice para a busca ficar rápida.
create index if not exists livro_busca_gin_idx on public.livro using gin (busca);
create index if not exists livro_paginas_idx   on public.livro (paginas);

-- 3) Função que a Edge Function vai chamar: filtra por tags, texto e páginas.
--    - p_tags:        o livro precisa ter TODAS as tags da lista (ex.: brasileira + curta)
--    - p_texto:       palavras soltas buscadas em título, autor e sinopse
--    - p_max_paginas: limite de páginas (ex.: 150 para "curto")
--    - p_limite:      máximo de livros (padrão 5, nunca mais que 20)
--    Qualquer parâmetro null é ignorado.
create or replace function public.buscar_livros(
  p_tags         text[]  default null,
  p_texto        text    default null,
  p_max_paginas  integer default null,
  p_limite       integer default 5
)
returns table (
  id        bigint,
  titulo    text,
  autor     text,
  sinopse   text,
  paginas   integer,
  capa_url  text,
  status    text,
  tags      text[]
)
language sql
stable
set search_path = public
as $$
  with consulta as (
    select
      case when btrim(coalesce(p_texto, '')) = '' then null
           else websearch_to_tsquery('portuguese', p_texto) end as q
  )
  select
    l.id, l.titulo, l.autor, l.sinopse, l.paginas, l.capa_url, l.status,
    coalesce(
      (select array_agg(t.nome order by t.nome)
         from livro_tag lt join tag t on t.id = lt.tag_id
        where lt.livro_id = l.id),
      '{}'::text[]
    ) as tags
  from livro l
  cross join consulta c
  where (p_max_paginas is null or l.paginas <= p_max_paginas)
    and (c.q is null or l.busca @@ c.q)
    and (
      p_tags is null or cardinality(p_tags) = 0
      or not exists (
        select 1
          from unnest(p_tags) as pedida(nome)
         where not exists (
           select 1
             from livro_tag lt join tag t on t.id = lt.tag_id
            where lt.livro_id = l.id and t.nome = pedida.nome
         )
      )
    )
  order by
    case when c.q is null then 0 else ts_rank(l.busca, c.q) end desc,
    (l.status = 'disponivel') desc,   -- disponíveis primeiro
    random()                          -- sem texto: varia as sugestões a cada pedido
  limit greatest(1, least(coalesce(p_limite, 5), 20));
$$;

grant execute on function public.buscar_livros(text[], text, integer, integer)
  to anon, authenticated, service_role;
