// Ponto único de configuração do front.
const env = import.meta.env

export const config = {
  usarMock: env.VITE_USE_MOCK === 'true',
  supabaseUrl: env.VITE_SUPABASE_URL,
  supabaseKey: env.VITE_SUPABASE_ANON_KEY,
  nomeFuncao: env.VITE_FUNCTION_NAME || 'recomendar-livros',
  modoTotem:
    env.VITE_MODO_TOTEM === 'true' ||
    new URLSearchParams(window.location.search).has('totem'),

  // A função também valida e limita o tamanho; aqui é só para não deixar digitar demais.
  limiteMensagem: 300,
  // No totem, a conversa volta ao início depois de tanto tempo sem toque.
  tempoOciosoTotemMs: 90000,
}

// Botões de atalho (Sprint 2).
export const SUGESTOES = [
  { rotulo: 'Algo curto', mensagem: 'Quero algo curto' },
  { rotulo: 'Clássicos', mensagem: 'Quero clássicos' },
  { rotulo: 'Livro brasileiro curto', mensagem: 'Quero um livro brasileiro curto' },
]
