# Guia do Supabase · Banco e dados (Sprints 1 e 2)

Passo a passo para quem cuida da parte **Banco e dados**. Os scripts prontos estão em `supabase/sql/`.
Os nomes de menus do painel do Supabase mudam de vez em quando; se algo não estiver exatamente onde
está escrito aqui, procure pelo nome do item na barra lateral.

**Mapa rápido (o que a modelagem pede → onde está)**

| Sprint | Tarefa da modelagem | Passo deste guia | Arquivo |
|---|---|---|---|
| 1 | Criar tabelas livro, tag e livro_tag | 1.2 | `01_schema.sql` |
| 1 | Cadastrar 30 livros com sinopse e tags | 1.3 | `02_seed_sprint1.sql` |
| 1 | Regras RLS: só leitura do acervo | 1.4 | `03_rls.sql` |
| 2 | Busca em texto em português com índice | 2.1 | `04_busca_sprint2.sql` |
| 2 | Função SQL `buscar_livros` (tags, texto, páginas) | 2.2 e 2.3 | `04_busca_sprint2.sql` |
| 2 | Ampliar o acervo para 50 livros | 2.4 | `05_seed_sprint2.sql` |

---

## Passo 0 · Criar o projeto no Supabase (uma vez só, para o time todo)

1. Acesse https://supabase.com e entre (ou crie uma conta, pode ser com o GitHub).
2. Clique em **New project** (se pedir, crie antes uma *Organization*, por exemplo "Integra Biblio").
3. Preencha:
   - **Name:** `integra-biblio`
   - **Database password:** crie uma senha forte e **guarde num gerenciador de senhas** (não vai no código nem no grupo do WhatsApp).
   - **Region:** a mais próxima dos usuários (South America / São Paulo, se aparecer).
4. Clique em **Create new project** e espere uns 2 minutos até o painel terminar de preparar.
5. Anote duas coisas do projeto (você vai passar para o time no passo 1.6):
   - **Project URL**: algo como `https://abcdefgh.supabase.co`. O trecho `abcdefgh` é o *project ref*. Fica no botão **Connect** do topo ou em **Project Settings → Data API**.
   - **Chave pública**: em **Project Settings → API Keys**. Use a *Publishable key* (`sb_publishable_…`) ou, se o painel ainda mostrar, a chave `anon` (aba de chaves legadas). **Nunca** copie para o front a `secret` / `service_role`.

---

## SPRINT 1 · O fluxo de ponta a ponta

Meta do banco: ter as tabelas, 30 livros com tags e as regras de leitura prontos para a função consultar.

### 1.1 Abrir o SQL Editor

1. Na barra lateral, clique em **SQL Editor**.
2. Clique em **New query** (ícone de "+"). Você vai colar um script por vez e clicar em **Run** (ou `Ctrl+Enter`).
3. Aparecendo "Success. No rows returned" ou uma tabela de resultados, deu certo.

> Se o painel perguntar sobre "RLS" ao rodar scripts que criam tabelas, pode seguir: o RLS é ligado no passo 1.4.

### 1.2 Criar as tabelas (`01_schema.sql`)

1. Abra o arquivo `supabase/sql/01_schema.sql`, copie **tudo** e cole numa nova query.
2. Clique em **Run**.
3. Confira em **Table Editor**: devem aparecer `livro`, `tag` e `livro_tag`.

O que o script cria (igual ao diagrama da modelagem):

- **livro**: `id`, `titulo`, `autor`, `sinopse`, `paginas`, `capa_url`, `status` (`disponivel`, `emprestado` ou `reservado`).
- **tag**: `id`, `nome`, `tipo` (`categoria` ou `atributo`).
- **livro_tag**: `livro_id` + `tag_id`, com **chave primária composta** (um livro não repete a mesma tag).
- Um índice único em (`titulo`, `autor`), para não cadastrar o mesmo livro duas vezes.

A coluna `busca` (texto pesquisável) **não** entra agora: ela é da Sprint 2 (passo 2.1).

### 1.3 Cadastrar tags e 30 livros (`02_seed_sprint1.sql`)

1. Nova query, cole o conteúdo de `supabase/sql/02_seed_sprint1.sql`, **Run**.
2. O script faz, nesta ordem: cadastra as **12 tags** (10 categorias como *Literatura brasileira* e *Clássicos*, e 2 atributos: *Leitura curta* e *Leitura longa*); cadastra os **30 livros** com sinopse; liga cada livro às suas tags; e aplica a regra de atributo pelas páginas: **até 150 páginas → "Leitura curta"**, 450 ou mais → "Leitura longa".
3. Conferir: abra o **Table Editor → livro** (deve ter 30 linhas) e **livro_tag** (cada livro com 2 a 4 tags).
4. Conferir por SQL (rode uma por vez):
   ```sql
   select count(*) from public.livro;                      -- esperado: 30
   select l.titulo from public.livro l
   where not exists (select 1 from public.livro_tag lt where lt.livro_id = l.id);  -- esperado: nenhuma linha
   ```

Observações:

- Pode rodar o script de novo sem duplicar nada.
- As sinopses são resumos escritos para o projeto. O número de páginas é **aproximado** e varia por edição: ajuste se o acervo real da biblioteca for diferente.
- Para cadastrar um livro novo depois, pelo **Table Editor → livro → Insert row**, preencha os campos e depois, em **livro_tag**, adicione as ligações (`livro_id` e `tag_id`). Se usar `paginas` ≤ 150, lembre de ligar a tag "Leitura curta".

### 1.4 Regras RLS: só leitura do acervo (`03_rls.sql`)

**Por que:** a chave pública vai dentro do app, qualquer pessoa pode copiá-la. Sem RLS, essa chave poderia apagar ou alterar livros. Com RLS, o público só lê.

1. Nova query com o conteúdo de `supabase/sql/03_rls.sql`, **Run**.
2. O script liga o RLS nas 3 tabelas, cria uma política de **leitura** (`select`) para `anon` e `authenticated`, e remove as permissões de `insert`, `update`, `delete` e `truncate` desses papéis.
3. Conferir no painel: **Authentication → Policies** (em algumas versões, **Database → Policies**): cada tabela mostra RLS ativo e uma política de SELECT.
4. **Teste de verdade** (troque `SEU-REF` e `SUA-CHAVE-PUBLICA`), num terminal:
   ```bash
   # Ler deve FUNCIONAR e devolver 3 livros:
   curl "https://SEU-REF.supabase.co/rest/v1/livro?select=titulo&limit=3" \
     -H "apikey: SUA-CHAVE-PUBLICA"

   # Escrever deve FALHAR com erro de permissão:
   curl -X POST "https://SEU-REF.supabase.co/rest/v1/livro" \
     -H "apikey: SUA-CHAVE-PUBLICA" -H "Content-Type: application/json" \
     -d '{"titulo":"Teste","autor":"Teste"}'
   ```
   Se a leitura voltar `[]` (lista vazia) com livros na tabela, a política de SELECT não foi criada: rode o `03_rls.sql` de novo.

> O SQL Editor roda com permissão total do dono do projeto, por isso os scripts de cadastro continuam funcionando mesmo com o RLS ligado.

### 1.5 Capas dos livros (opcional na Sprint 1, recomendado na 2)

Os seeds deixam `capa_url` vazio; o front mostra um quadrado roxo com o título no lugar. Para colocar capas:

1. **Storage → New bucket**, nome `capas`, marque **Public bucket**, **Create**.
2. Entre no bucket e use **Upload file** para enviar as imagens (`.jpg`/`.webp`, de preferência até ~200 KB e proporção 2:3). Use só imagens que vocês podem usar (por exemplo, fornecidas pela editora ou pela própria biblioteca).
3. O link público de cada imagem tem este formato:
   `https://SEU-REF.supabase.co/storage/v1/object/public/capas/nome-do-arquivo.jpg`
4. Grave no livro:
   ```sql
   update public.livro
      set capa_url = 'https://SEU-REF.supabase.co/storage/v1/object/public/capas/a-hora-da-estrela.jpg'
    where titulo = 'A Hora da Estrela' and autor = 'Clarice Lispector';
   ```

### 1.6 Entregar para o time

- **Para o Front (pessoas 1 e 2):** Project URL e chave pública (vão no `.env` do front: `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY`).
- **Para a Edge Function (Carol):** o *project ref*, o nome das tabelas e das colunas (acima) e o aviso de que o RLS permite só leitura.
- **Nunca** enviar a senha do banco nem a chave secreta em grupo ou commit.

### ✔ Checklist de pronto da Sprint 1

- [ ] 3 tabelas criadas e visíveis no Table Editor
- [ ] 30 livros, todos com pelo menos 1 tag
- [ ] RLS ativo: leitura funciona e escrita com chave pública falha
- [ ] URL e chave pública entregues ao time

---

## SPRINT 2 · Busca com livros reais

Meta: a função devolve livros reais do Supabase, filtrados pelo pedido.

### 2.1 Busca em texto em português com índice (`04_busca_sprint2.sql`)

1. Nova query com o conteúdo de `supabase/sql/04_busca_sprint2.sql`, **Run**. (O arquivo faz os passos 2.1 e 2.2 de uma vez.)
2. A primeira parte adiciona a coluna **`busca`** na tabela `livro`:
   - ela é **gerada automaticamente** a partir de título, autor e sinopse, então não precisa preencher nada e acompanha qualquer edição;
   - usa o dicionário `portuguese` do Postgres: "livros" e "livro" contam como a mesma palavra, e palavras como "o", "de", "um" são ignoradas;
   - título pesa mais que autor, e autor mais que sinopse (para o ranking dos resultados).
3. Cria o **índice GIN** (`livro_busca_gin_idx`) para a busca continuar rápida quando o acervo crescer, e um índice em `paginas`.
4. Conferir: no **Table Editor → livro** aparece a coluna `busca` preenchida com palavras reduzidas.

> A busca não ignora acentos ("dragão" ≠ "dragao"). Se quiserem isso depois, dá para ativar a extensão `unaccent` (**Database → Extensions**); fica como melhoria.

### 2.2 A função `buscar_livros`

Também vem no `04_busca_sprint2.sql`. Assinatura:

```sql
buscar_livros(
  p_tags         text[]  default null,   -- ex.: array['Literatura brasileira','Leitura curta']
  p_texto        text    default null,   -- ex.: 'detetive'
  p_max_paginas  integer default null,   -- ex.: 150
  p_limite       integer default 5       -- máximo 20
)
```

Regras da função:

- Cada parâmetro `null` é ignorado.
- **Tags:** o livro precisa ter **todas** as tags pedidas (brasileiro **e** curto).
- **Texto:** procura em título, autor e sinopse; várias palavras significam "todas precisam aparecer".
- **Páginas:** `paginas <= p_max_paginas`.
- **Ordem:** melhor ranking do texto primeiro; livros `disponivel` antes dos demais; sem texto, a ordem varia (aleatória) para a sugestão não ser sempre a mesma.
- **Limite:** 5 por padrão (regra do projeto), nunca mais que 20.
- Devolve já com `tags` como lista de nomes, no formato que a função da Carol precisa para montar o JSON do contrato.
- A função roda com as permissões de quem chama, então o RLS continua valendo.

### 2.3 Testar a função

No SQL Editor (uma consulta por vez; todas estão no `06_testes.sql`):

```sql
-- "livro brasileiro curto"
select id, titulo, paginas, tags
from public.buscar_livros(array['Literatura brasileira','Leitura curta'], null, 150, 5);
-- esperado: livros como A Hora da Estrela, A Cartomante, O Alienista...

-- só clássicos
select id, titulo from public.buscar_livros(array['Clássicos'], null, null, 5);

-- texto livre
select id, titulo from public.buscar_livros(null, 'detetive', null, 5);   -- esperado: Assassinato no Expresso do Oriente

-- sem resultado (a função da Carol deve afrouxar os filtros e tentar de novo)
select id, titulo from public.buscar_livros(array['Ficção científica'], 'seca', null, 5);  -- esperado: 0 linhas
```

Teste pela API, do jeito que a Edge Function vai chamar:

```bash
curl -X POST "https://SEU-REF.supabase.co/rest/v1/rpc/buscar_livros" \
  -H "apikey: SUA-CHAVE-PUBLICA" -H "Content-Type: application/json" \
  -d '{"p_tags":["Literatura brasileira","Leitura curta"],"p_max_paginas":150,"p_limite":5}'
```

**Como a Edge Function (Carol) chama** (supabase-js, dentro da função):

```ts
const { data, error } = await supabase.rpc('buscar_livros', {
  p_tags: ['Literatura brasileira', 'Leitura curta'],
  p_texto: null,          // só o que sobrou do pedido, sem "quero", "livro"...
  p_max_paginas: 150,
  p_limite: 5,
})
// data = [{ id, titulo, autor, sinopse, paginas, capa_url, status, tags: [...] }]
```

Dois recados para a Carol:

- Para o texto, mande só as palavras que **sobraram** depois do dicionário de tags. "quero um livro brasileiro" inteiro exigiria todas as palavras no livro e quase nunca retorna nada.
- Como o app não tem login, a chamada vem só com a chave pública. Segundo a documentação do Supabase, a função, por padrão, exige um JWT de usuário logado nas chamadas; para este caso ela provavelmente precisará de `verify_jwt = false` (em `supabase/config.toml`) ou do equivalente no deploy. Vale conferir na documentação atual de Edge Functions e, como isso deixa a função aberta, manter a validação e o limite de tamanho da mensagem.

### 2.4 Ampliar o acervo para 50 livros (`05_seed_sprint2.sql`)

1. Nova query com o conteúdo de `supabase/sql/05_seed_sprint2.sql`, **Run**.
2. Conferir: `select count(*) from public.livro;` deve dar **50**.
3. Rode de novo o `06_testes.sql` para garantir que as buscas continuam coerentes.
4. Se quiserem trocar ou acrescentar livros do acervo real, copie o formato do arquivo (um `insert` em `livro` e as tags em `livro_tag`).

### 2.5 Entregar para o time

- Para a Carol: nome e assinatura da função `buscar_livros` e o formato do retorno (acima).
- Para o front: nada muda no contrato; só avisar quando o acervo de 50 estiver no ar, para a demo ("livro brasileiro curto" com livros reais).

### ✔ Checklist de pronto da Sprint 2

- [ ] Coluna `busca` preenchida e índice `livro_busca_gin_idx` criado
- [ ] `buscar_livros` devolve resultado coerente nos 4 testes
- [ ] 50 livros cadastrados
- [ ] Capas (pelo menos dos livros da demo) preenchidas
- [ ] Demo ensaiada: pedir "livro brasileiro curto" e ver livros reais

---

## Problemas comuns

| Mensagem / sintoma | Causa e solução |
|---|---|
| `relation "public.livro" does not exist` | Rodou o 02 antes do 01. Rode o `01_schema.sql` primeiro. |
| `function public.buscar_livros ... does not exist` | O `04_busca_sprint2.sql` não rodou até o fim. Rode de novo. |
| `column "busca" does not exist` | Mesmo caso: rode o `04`. |
| Seed rodou duas vezes | Sem problema, não duplica. |
| API devolve `[]` mas a tabela tem dados | RLS ligado sem política de SELECT. Rode o `03_rls.sql`. |
| `permission denied for table livro` com a chave pública | Esperado para escrita. Se for leitura, rode o `03_rls.sql` (o `revoke` só retira escrita). |
| Busca com texto não encontra nada | Palavras demais ou com acento diferente. Teste com uma palavra só. |
| `buscar_livros` volta sempre os mesmos livros | Com texto, a ordem é por ranking (normal). Sem texto, ela varia. |
