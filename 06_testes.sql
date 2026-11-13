-- =====================================================================
-- Testes rápidos. Rode UMA consulta por vez (selecione e clique em Run).
-- =====================================================================

-- [Sprint 1] Quantos livros? Esperado: 30 (depois da Sprint 2: 50)
select count(*) as total_livros from public.livro;

-- [Sprint 1] Quantas tags de cada tipo? Esperado: 10 categorias e 2 atributos
select tipo, count(*) from public.tag group by tipo;

-- [Sprint 1] Algum livro sem tag? Esperado: nenhuma linha
select l.titulo from public.livro l
where not exists (select 1 from public.livro_tag lt where lt.livro_id = l.id);

-- [Sprint 1] "Leitura curta" só pode ter livros com até 150 páginas. Esperado: nenhuma linha
select l.titulo, l.paginas
from public.livro l
join public.livro_tag lt on lt.livro_id = l.id
join public.tag t on t.id = lt.tag_id and t.nome = 'Leitura curta'
where l.paginas > 150;

-- [Sprint 2] "livro brasileiro curto": brasileira + curta, até 150 páginas
select id, titulo, autor, paginas, tags
from public.buscar_livros(array['Literatura brasileira', 'Leitura curta'], null, 150, 5);

-- [Sprint 2] Só clássicos (5 aleatórios entre os clássicos)
select id, titulo, tags from public.buscar_livros(array['Clássicos'], null, null, 5);

-- [Sprint 2] Busca por texto (título, autor ou sinopse)
select id, titulo, autor from public.buscar_livros(null, 'detetive', null, 5);
select id, titulo, autor from public.buscar_livros(null, 'vampiro', null, 5);

-- [Sprint 2] Tag + texto juntos
select id, titulo from public.buscar_livros(array['Fantasia'], 'dragão', null, 5);

-- [Sprint 2] Combinação sem resultado: tem que voltar 0 linhas (a função da Carol afrouxa os filtros)
select id, titulo from public.buscar_livros(array['Ficção científica'], 'seca', null, 5);
