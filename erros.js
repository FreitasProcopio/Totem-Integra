// Transforma erros técnicos em frases que qualquer pessoa entende.
export function mensagemAmigavel(erro) {
  if (erro?.message === 'CONFIG_SUPABASE_AUSENTE') {
    return 'Faltou configurar o Supabase no arquivo .env. Peça ajuda para quem cuida do projeto.'
  }
  if (erro?.name === 'FunctionsFetchError' || erro instanceof TypeError || navigator.onLine === false) {
    return 'Não consegui falar com o servidor agora. Confira a internet e tente de novo.'
  }
  if (erro?.name === 'FunctionsHttpError') {
    return 'Tive um problema ao buscar os livros. Tente de novo em instantes.'
  }
  return 'Algo deu errado por aqui. Tente de novo.'
}
