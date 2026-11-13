-- =====================================================================
-- SPRINT 2 · Passo 4: ampliar o acervo de 30 para 50 livros (mais 20)
-- Rode DEPOIS do 03_seed_sprint1.sql. Pode rodar de novo sem duplicar.
-- =====================================================================

insert into public.livro (titulo, autor, sinopse, paginas, status) values
  ('Grande Sertão: Veredas', 'João Guimarães Rosa', 'O ex-jagunço Riobaldo conta a própria vida, o amor por Diadorim e as dúvidas sobre o bem, o mal e um pacto.', 608, 'disponivel'),
  ('Macunaíma', 'Mário de Andrade', 'O herói sem nenhum caráter nasce na floresta e vive aventuras mágicas e divertidas pelo Brasil.', 224, 'disponivel'),
  ('Alguma Poesia', 'Carlos Drummond de Andrade', 'Primeiro livro de Drummond, com poemas de humor, ironia e um olhar atento ao cotidiano.', 120, 'disponivel'),
  ('Antologia Poética', 'Vinicius de Moraes', 'Seleção de poemas de Vinicius, com sonetos, canções e versos sobre amor e vida.', 256, 'disponivel'),
  ('A Moreninha', 'Joaquim Manuel de Macedo', 'Augusto aposta com os amigos que não vai se apaixonar e, na ilha de Paquetá, conhece a Moreninha.', 200, 'disponivel'),
  ('Menino de Engenho', 'José Lins do Rego', 'Carlinhos, ainda criança, vai morar no engenho do avô em Pernambuco e relembra a infância no canavial.', 160, 'disponivel'),
  ('O Quinze', 'Rachel de Queiroz', 'A seca de 1915 no Ceará atravessa a vida de retirantes e de uma professora que se divide entre o amor e as ideias.', 176, 'emprestado'),
  ('Cem Anos de Solidão', 'Gabriel García Márquez', 'A saga da família Buendía na cidade imaginária de Macondo, entre amores, guerras e fatos mágicos.', 448, 'disponivel'),
  ('Alice no País das Maravilhas', 'Lewis Carroll', 'Alice segue um coelho apressado e cai em um mundo onde nada obedece à lógica.', 176, 'disponivel'),
  ('Duna', 'Frank Herbert', 'Paul Atreides e sua família assumem o planeta deserto Arrakis, fonte da especiaria mais valiosa do universo.', 680, 'emprestado'),
  ('O Conto da Aia', 'Margaret Atwood', 'Em um regime autoritário, Offred é obrigada a servir como aia e guarda memórias de uma vida livre.', 368, 'disponivel'),
  ('A Menina que Roubava Livros', 'Markus Zusak', 'Narrada pela Morte, a história de Liesel, que rouba livros na Alemanha nazista e encontra neles um refúgio.', 480, 'disponivel'),
  ('A Culpa É das Estrelas', 'John Green', 'Hazel e Gus se conhecem em um grupo de apoio e vivem um amor intenso, cheio de humor e emoção.', 288, 'disponivel'),
  ('O Alquimista', 'Paulo Coelho', 'O pastor Santiago deixa a Espanha em busca de um tesouro perto das pirâmides do Egito e aprende a seguir seus sonhos.', 208, 'disponivel'),
  ('Sapiens: Uma Breve História da Humanidade', 'Yuval Noah Harari', 'Um panorama da história humana, da evolução dos primeiros Homo sapiens até as sociedades atuais.', 464, 'disponivel'),
  ('E Não Sobrou Nenhum', 'Agatha Christie', 'Dez pessoas são convidadas para uma ilha isolada e vão morrendo uma a uma, sem que ninguém saiba quem é o assassino.', 264, 'disponivel'),
  ('Drácula', 'Bram Stoker', 'Contada por cartas e diários, a história do conde vampiro da Transilvânia que se muda para Londres.', 592, 'reservado'),
  ('Eu, Robô', 'Isaac Asimov', 'Contos que investigam, a partir das Três Leis da Robótica, o que acontece quando máquinas passam a pensar.', 320, 'disponivel'),
  ('Romeu e Julieta', 'William Shakespeare', 'Dois jovens de famílias rivais em Verona se apaixonam e enfrentam um destino trágico.', 176, 'disponivel'),
  ('Pequeno Manual Antirracista', 'Djamila Ribeiro', 'Textos curtos que propõem atitudes práticas para reconhecer e combater o racismo no dia a dia.', 136, 'disponivel')
on conflict (titulo, autor) do nothing;

insert into public.livro_tag (livro_id, tag_id)
select l.id, t.id
from (values
  ('Grande Sertão: Veredas', array['Literatura brasileira', 'Romance', 'Clássicos']),
  ('Macunaíma', array['Literatura brasileira', 'Romance', 'Fantasia', 'Clássicos']),
  ('Alguma Poesia', array['Literatura brasileira', 'Poesia', 'Clássicos']),
  ('Antologia Poética', array['Literatura brasileira', 'Poesia']),
  ('A Moreninha', array['Literatura brasileira', 'Romance', 'Clássicos']),
  ('Menino de Engenho', array['Literatura brasileira', 'Romance', 'Clássicos']),
  ('O Quinze', array['Literatura brasileira', 'Romance', 'Clássicos']),
  ('Cem Anos de Solidão', array['Clássicos', 'Romance', 'Fantasia']),
  ('Alice no País das Maravilhas', array['Infantojuvenil', 'Fantasia', 'Clássicos']),
  ('Duna', array['Ficção científica', 'Clássicos']),
  ('O Conto da Aia', array['Ficção científica', 'Romance']),
  ('A Menina que Roubava Livros', array['Romance', 'Infantojuvenil']),
  ('A Culpa É das Estrelas', array['Romance', 'Infantojuvenil']),
  ('O Alquimista', array['Literatura brasileira', 'Romance']),
  ('Sapiens: Uma Breve História da Humanidade', array['Não ficção']),
  ('E Não Sobrou Nenhum', array['Suspense', 'Clássicos']),
  ('Drácula', array['Suspense', 'Clássicos']),
  ('Eu, Robô', array['Ficção científica', 'Conto', 'Clássicos']),
  ('Romeu e Julieta', array['Clássicos', 'Romance']),
  ('Pequeno Manual Antirracista', array['Literatura brasileira', 'Não ficção'])
) as v(titulo, tags)
join public.livro l on l.titulo = v.titulo
cross join lateral unnest(v.tags) as x(nome)
join public.tag t on t.nome = x.nome
on conflict do nothing;

-- Tags de atributo calculadas pelas páginas (regra do projeto: curto = até 150 páginas).
insert into public.livro_tag (livro_id, tag_id)
select l.id, t.id from public.livro l
join public.tag t on t.nome = 'Leitura curta'
where l.paginas <= 150
on conflict do nothing;

insert into public.livro_tag (livro_id, tag_id)
select l.id, t.id from public.livro l
join public.tag t on t.nome = 'Leitura longa'
where l.paginas >= 450
on conflict do nothing;
