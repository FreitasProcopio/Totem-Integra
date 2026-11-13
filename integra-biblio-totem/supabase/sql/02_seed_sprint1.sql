-- =====================================================================
-- SPRINT 1 · Passo 2: cadastrar as tags e os 30 primeiros livros (arquivo 02)
-- Pode rodar de novo sem duplicar (usa "on conflict do nothing").
-- Sinopses escritas à mão e número de páginas aproximado (varia por edição).
-- capa_url fica vazio por enquanto: veja o guia (Storage) para colocar as capas.
-- =====================================================================

insert into public.tag (nome, tipo) values
  ('Literatura brasileira', 'categoria'),
  ('Clássicos', 'categoria'),
  ('Romance', 'categoria'),
  ('Conto', 'categoria'),
  ('Poesia', 'categoria'),
  ('Fantasia', 'categoria'),
  ('Ficção científica', 'categoria'),
  ('Suspense', 'categoria'),
  ('Infantojuvenil', 'categoria'),
  ('Não ficção', 'categoria'),
  ('Leitura curta', 'atributo'),
  ('Leitura longa', 'atributo')
on conflict (nome) do nothing;

insert into public.livro (titulo, autor, sinopse, paginas, status) values
  ('A Hora da Estrela', 'Clarice Lispector', 'Macabéa, jovem nordestina que vive no Rio de Janeiro, leva uma vida quase invisível, narrada em uma história curta e comovente sobre solidão e desejo de existir.', 88, 'disponivel'),
  ('A Cartomante', 'Machado de Assis', 'Conto sobre ciúme, superstição e destino: Camilo consulta uma cartomante por causa de um caso com a mulher do melhor amigo, e a história caminha para um desfecho trágico.', 32, 'disponivel'),
  ('Quarto de Despejo', 'Carolina Maria de Jesus', 'Diário de uma catadora de papel moradora de uma favela de São Paulo, que registra a fome, o trabalho e a vontade de escrever.', 200, 'disponivel'),
  ('Dom Casmurro', 'Machado de Assis', 'Bentinho conta a própria vida e a paixão por Capitu, alimentando a dúvida eterna: ela o traiu ou foi o ciúme que o enganou?', 256, 'emprestado'),
  ('Memórias Póstumas de Brás Cubas', 'Machado de Assis', 'Um defunto autor narra a vida com ironia e humor ácido, da ambição pessoal à crítica da sociedade brasileira do século XIX.', 240, 'disponivel'),
  ('O Alienista', 'Machado de Assis', 'O doutor Simão Bacamarte funda um hospício na vila de Itaguaí e passa a internar quase todo mundo, até questionar o que é loucura.', 80, 'disponivel'),
  ('Vidas Secas', 'Graciliano Ramos', 'Fabiano, sinhá Vitória, os dois filhos e a cachorra Baleia enfrentam a seca e a miséria no sertão nordestino em uma narrativa enxuta e poderosa.', 160, 'disponivel'),
  ('O Cortiço', 'Aluísio Azevedo', 'No Rio de Janeiro do século XIX, a vida em um cortiço mostra ambição, exploração e a convivência de gente de todo tipo.', 288, 'reservado'),
  ('Capitães da Areia', 'Jorge Amado', 'Um grupo de meninos de rua em Salvador sobrevive com astúcia e solidariedade enquanto a cidade finge não vê-los.', 280, 'disponivel'),
  ('Laços de Família', 'Clarice Lispector', 'Contos que mostram momentos aparentemente comuns do cotidiano de repente tomados por emoções intensas.', 144, 'disponivel'),
  ('Torto Arado', 'Itamar Vieira Junior', 'Duas irmãs crescem em uma fazenda na Chapada Diamantina e enfrentam trabalho, terra, ancestralidade e luta por direitos.', 264, 'disponivel'),
  ('Dois Irmãos', 'Milton Hatoum', 'Em Manaus, os gêmeos Yaqub e Omar vivem uma rivalidade que abala uma família de origem libanesa.', 264, 'disponivel'),
  ('Ou Isto ou Aquilo', 'Cecília Meireles', 'Poemas para crianças, e para quem já foi uma, sobre escolhas, brincadeiras e as pequenas coisas do dia.', 80, 'disponivel'),
  ('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 'Um piloto perdido no deserto conhece um menino vindo de outro planeta, que fala de amizade, amor e do que realmente importa.', 96, 'disponivel'),
  ('1984', 'George Orwell', 'Em um Estado que vigia tudo e todos, Winston tenta guardar pensamentos próprios e um amor proibido.', 416, 'disponivel'),
  ('A Revolução dos Bichos', 'George Orwell', 'Os animais de uma fazenda expulsam o dono e tentam criar uma sociedade igualitária, mas o poder muda tudo.', 152, 'disponivel'),
  ('O Velho e o Mar', 'Ernest Hemingway', 'Um pescador cubano já idoso passa dias em alto-mar lutando contra um enorme peixe.', 128, 'disponivel'),
  ('A Metamorfose', 'Franz Kafka', 'Gregor Samsa acorda transformado em inseto e vê a família reagir à nova realidade.', 96, 'disponivel'),
  ('O Estrangeiro', 'Albert Camus', 'Meursault vive indiferente às convenções, até que um crime em uma praia o leva a julgamento.', 128, 'disponivel'),
  ('Orgulho e Preconceito', 'Jane Austen', 'Elizabeth Bennet e o orgulhoso Sr. Darcy precisam superar preconceitos e mal-entendidos para se entender.', 424, 'emprestado'),
  ('Frankenstein', 'Mary Shelley', 'Um jovem cientista dá vida a uma criatura e foge da responsabilidade, desencadeando uma tragédia.', 280, 'disponivel'),
  ('O Hobbit', 'J.R.R. Tolkien', 'Bilbo Bolseiro, um hobbit caseiro, é levado por anões e um mago a uma aventura para recuperar um tesouro guardado por um dragão.', 336, 'disponivel'),
  ('Harry Potter e a Pedra Filosofal', 'J.K. Rowling', 'Harry descobre que é bruxo e começa a estudar em Hogwarts, onde faz amigos e investiga o mistério de uma pedra.', 264, 'reservado'),
  ('Fahrenheit 451', 'Ray Bradbury', 'Em um futuro onde livros são proibidos, o bombeiro Montag, que queima livros, começa a questionar o próprio trabalho.', 216, 'disponivel'),
  ('O Guia do Mochileiro das Galáxias', 'Douglas Adams', 'Depois que a Terra é destruída, Arthur Dent viaja pela galáxia em uma aventura cheia de humor absurdo.', 208, 'disponivel'),
  ('Assassinato no Expresso do Oriente', 'Agatha Christie', 'Preso em um trem parado pela neve, o detetive Hercule Poirot investiga um crime em que todos os passageiros são suspeitos.', 256, 'disponivel'),
  ('Um Estudo em Vermelho', 'Arthur Conan Doyle', 'Primeiro caso de Sherlock Holmes e do Dr. Watson, que investigam um misterioso assassinato em Londres.', 224, 'disponivel'),
  ('Crônica de uma Morte Anunciada', 'Gabriel García Márquez', 'Todos na cidade sabiam que Santiago Nasar seria morto e ninguém evitou; o narrador reconstrói o que aconteceu.', 144, 'disponivel'),
  ('O Diário de Anne Frank', 'Anne Frank', 'Registros de uma adolescente judia escondida com a família em Amsterdã durante a ocupação nazista.', 352, 'disponivel'),
  ('Coraline', 'Neil Gaiman', 'Coraline descobre uma porta para um mundo parecido com o dela, mas com algo sinistro por trás.', 160, 'disponivel')
on conflict (titulo, autor) do nothing;

insert into public.livro_tag (livro_id, tag_id)
select l.id, t.id
from (values
  ('A Hora da Estrela', array['Literatura brasileira', 'Romance', 'Clássicos']),
  ('A Cartomante', array['Literatura brasileira', 'Conto', 'Suspense', 'Clássicos']),
  ('Quarto de Despejo', array['Literatura brasileira', 'Não ficção']),
  ('Dom Casmurro', array['Literatura brasileira', 'Romance', 'Clássicos']),
  ('Memórias Póstumas de Brás Cubas', array['Literatura brasileira', 'Romance', 'Clássicos']),
  ('O Alienista', array['Literatura brasileira', 'Clássicos']),
  ('Vidas Secas', array['Literatura brasileira', 'Romance', 'Clássicos']),
  ('O Cortiço', array['Literatura brasileira', 'Romance', 'Clássicos']),
  ('Capitães da Areia', array['Literatura brasileira', 'Romance', 'Clássicos']),
  ('Laços de Família', array['Literatura brasileira', 'Conto', 'Clássicos']),
  ('Torto Arado', array['Literatura brasileira', 'Romance']),
  ('Dois Irmãos', array['Literatura brasileira', 'Romance']),
  ('Ou Isto ou Aquilo', array['Literatura brasileira', 'Poesia', 'Infantojuvenil']),
  ('O Pequeno Príncipe', array['Infantojuvenil', 'Fantasia', 'Clássicos']),
  ('1984', array['Ficção científica', 'Clássicos']),
  ('A Revolução dos Bichos', array['Clássicos', 'Fantasia']),
  ('O Velho e o Mar', array['Clássicos', 'Romance']),
  ('A Metamorfose', array['Clássicos', 'Fantasia']),
  ('O Estrangeiro', array['Clássicos', 'Romance']),
  ('Orgulho e Preconceito', array['Clássicos', 'Romance']),
  ('Frankenstein', array['Clássicos', 'Ficção científica', 'Suspense']),
  ('O Hobbit', array['Fantasia', 'Infantojuvenil', 'Clássicos']),
  ('Harry Potter e a Pedra Filosofal', array['Fantasia', 'Infantojuvenil']),
  ('Fahrenheit 451', array['Ficção científica', 'Clássicos']),
  ('O Guia do Mochileiro das Galáxias', array['Ficção científica']),
  ('Assassinato no Expresso do Oriente', array['Suspense', 'Clássicos']),
  ('Um Estudo em Vermelho', array['Suspense', 'Clássicos']),
  ('Crônica de uma Morte Anunciada', array['Suspense', 'Romance', 'Clássicos']),
  ('O Diário de Anne Frank', array['Não ficção']),
  ('Coraline', array['Fantasia', 'Infantojuvenil', 'Suspense'])
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
