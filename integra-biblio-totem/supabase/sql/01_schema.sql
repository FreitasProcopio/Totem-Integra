-- =====================================================================
-- SPRINT 1 · Passo 1: criar as 3 tabelas (livro, tag, livro_tag) (arquivo 01)
-- Rode no Supabase: SQL Editor > New query > cole tudo > Run
-- =====================================================================

create table if not exists public.livro (
  id        bigint generated always as identity primary key,
  titulo    text    not null,
  autor     text    not null,
  sinopse   text,
  paginas   integer check (paginas is null or paginas > 0),
  capa_url  text,
  status    text    not null default 'disponivel'
            check (status in ('disponivel', 'emprestado', 'reservado'))
);

create table if not exists public.tag (
  id    bigint generated always as identity primary key,
  nome  text not null unique,
  tipo  text not null check (tipo in ('categoria', 'atributo'))
);

-- Tabela de ligação: um livro tem várias tags, uma tag está em vários livros.
create table if not exists public.livro_tag (
  livro_id  bigint not null references public.livro (id) on delete cascade,
  tag_id    bigint not null references public.tag (id)   on delete cascade,
  primary key (livro_id, tag_id)          -- chave composta (livro, tag)
);

-- Evita cadastrar o mesmo livro duas vezes e deixa o seed repetível.
create unique index if not exists livro_titulo_autor_uidx on public.livro (titulo, autor);
-- Acelera "quais livros têm esta tag".
create index if not exists livro_tag_tag_id_idx on public.livro_tag (tag_id);
