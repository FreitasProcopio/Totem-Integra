-- =====================================================================
-- SPRINT 1 · Passo 3: regras RLS (Row Level Security) (arquivo 03)
-- Objetivo: o público só LÊ o acervo. Ninguém de fora escreve nada.
-- =====================================================================

alter table public.livro     enable row level security;
alter table public.tag       enable row level security;
alter table public.livro_tag enable row level security;

-- Políticas de leitura (SELECT) para quem usa a chave pública (anon) ou está logado.
drop policy if exists "acervo_leitura_livro" on public.livro;
create policy "acervo_leitura_livro" on public.livro
  for select to anon, authenticated using (true);

drop policy if exists "acervo_leitura_tag" on public.tag;
create policy "acervo_leitura_tag" on public.tag
  for select to anon, authenticated using (true);

drop policy if exists "acervo_leitura_livro_tag" on public.livro_tag;
create policy "acervo_leitura_livro_tag" on public.livro_tag
  for select to anon, authenticated using (true);

-- Cinto e suspensório: além de não ter política de escrita, tira a permissão.
revoke insert, update, delete, truncate on public.livro     from anon, authenticated;
revoke insert, update, delete, truncate on public.tag       from anon, authenticated;
revoke insert, update, delete, truncate on public.livro_tag from anon, authenticated;
