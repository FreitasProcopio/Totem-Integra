# Integra Biblio · Assistente de Leitura (front + dados)

Chat em React que recebe um pedido ("quero um livro brasileiro curto"), chama a Edge Function
`recomendar-livros` e mostra a explicação do modelo mais os cards dos livros.
Este pacote cobre **Front UI**, **Front integração** e **Banco e dados** das **Sprints 1 e 2**.

## O que tem aqui

```
integra-biblio/
├── index.html
├── package.json
├── vite.config.js
├── .env.example               ← copie para .env
├── public/favicon.svg
├── src/
│   ├── main.jsx               entrada do React
│   ├── App.jsx
│   ├── config.js              variáveis do .env + botões de sugestão
│   ├── components/
│   │   ├── ChatPage.jsx       organiza a tela (+ modo totem)
│   │   ├── Header.jsx
│   │   ├── MessageBubble.jsx  balão de cada mensagem
│   │   ├── BookCard.jsx       capa, tags e status
│   │   ├── SuggestionChips.jsx atalhos de pedido
│   │   ├── ChatInput.jsx      campo e botão de enviar
│   │   ├── Digitando.jsx      estado "carregando"
│   │   └── Avatar.jsx
│   ├── hooks/useChat.js       estado da conversa + chamada à função
│   ├── services/recomendarLivros.js   supabase.functions.invoke (contrato JSON)
│   ├── lib/supabaseClient.js  cliente com a chave PÚBLICA
│   ├── lib/mockApi.js         função "de mentira" para testar sem backend
│   ├── utils/erros.js         mensagens de erro amigáveis
│   └── styles/index.css
├── supabase/sql/              scripts do banco (rodar na ordem dos números)
│   ├── 01_schema.sql          tabelas livro, tag, livro_tag
│   ├── 02_seed_sprint1.sql    tags + 30 livros
│   ├── 03_rls.sql             só leitura do acervo
│   ├── 04_busca_sprint2.sql   busca em português + função buscar_livros
│   ├── 05_seed_sprint2.sql    mais 20 livros (total 50)
│   └── 06_testes.sql          consultas de conferência
└── docs/GUIA_SUPABASE.md      passo a passo detalhado do banco
```

## Como rodar o front (passo a passo)

**Pré-requisito:** Node.js 18 ou mais novo (confira com `node -v`; baixe em https://nodejs.org se precisar).

1. Descompacte o projeto e abra um terminal dentro da pasta `integra-biblio`.
2. Instale as dependências:
   ```bash
   npm install
   ```
3. Crie o arquivo de configuração:
   ```bash
   cp .env.example .env        # no Windows (PowerShell): copy .env.example .env
   ```
4. Rode:
   ```bash
   npm run dev
   ```
5. Abra http://localhost:5173 no navegador.

Do jeito que vem, o `.env` está com `VITE_USE_MOCK=true`: o chat funciona **sem Supabase**, com 8 livros
de exemplo dentro do próprio front. Dá para ensaiar a demo da Sprint 1 e testar todos os estados:

| Digite no chat | O que acontece |
|---|---|
| `quero um livro brasileiro curto` | resposta + cards com destaque no escolhido |
| `#vazio` | simula "nenhum livro encontrado" |
| `#erro` | simula falha de rede (botão "Tentar de novo") |

### Ligar no Supabase de verdade

1. Faça antes o `docs/GUIA_SUPABASE.md` (banco) e peça para quem faz a Edge Function publicar `recomendar-livros`.
2. No `.env`, troque para:
   ```
   VITE_USE_MOCK=false
   VITE_SUPABASE_URL=https://SEU-PROJETO.supabase.co
   VITE_SUPABASE_ANON_KEY=a-chave-publica-do-projeto
   ```
3. Pare o servidor (`Ctrl+C`) e rode `npm run dev` de novo. O Vite só lê o `.env` ao iniciar.

> Use **somente a chave pública** (anon / publishable) no front. Nunca coloque a chave secreta
> (`service_role` / `sb_secret_…`) nem a chave do modelo de IA: essas ficam só na Edge Function.

### Modo totem

Abra http://localhost:5173/?totem (ou use `VITE_MODO_TOTEM=true`). Letras e botões ficam maiores,
a barra de rolagem some e, depois de 90 s sem toque, a conversa recomeça para a próxima pessoa.
Em quiosque, abra o navegador em tela cheia (F11).

### Outros comandos

```bash
npm run build     # gera a pasta dist/ para publicar
npm run preview   # testa o build localmente
```

## Contrato com a função (já implementado no front)

Entrada: `{ "mensagem": "quero um livro brasileiro curto" }`

Saída: `{ "resposta": "...", "destaque_id": 12, "livros": [{ "id", "titulo", "autor", "capa_url", "status", "tags": [] }] }`

O front tolera campos ausentes, mostra mensagem amigável se a chamada falhar e, se `livros` vier vazio,
mostra "Não encontrei livros para esse pedido…".

## Problemas comuns

| Sintoma | Causa provável |
|---|---|
| `npm: command not found` | Node.js não instalado |
| Tela abre, mas erro "Faltou configurar o Supabase" | `VITE_USE_MOCK=false` sem URL/chave no `.env` |
| Mudei o `.env` e nada mudou | reinicie o `npm run dev` |
| Erro "Não consegui falar com o servidor" com mock desligado | função não publicada, nome diferente de `recomendar-livros`, ou CORS não configurado na função |
| Capas aparecem como quadrado roxo com o título | `capa_url` vazio ou link quebrado (veja "Capas" no guia do Supabase) |
| O botão "Ver livro" do protótipo não existe | ele entra junto com o catálogo, que ficou para depois |
