import { config } from '../config.js'
import { getSupabase } from '../lib/supabaseClient.js'
import { recomendarMock } from '../lib/mockApi.js'

// Garante o formato do contrato mesmo se a função mandar algo incompleto.
//   Entrada: { mensagem }
//   Saída:   { resposta, destaque_id, livros: [{ id, titulo, autor, capa_url, status, tags }] }
function normalizar(data) {
  const livros = Array.isArray(data?.livros)
    ? data.livros.map((l) => ({
        id: l.id,
        titulo: l.titulo ?? 'Sem título',
        autor: l.autor ?? 'Autor desconhecido',
        capa_url: l.capa_url ?? null,
        status: l.status ?? 'disponivel',
        tags: Array.isArray(l.tags) ? l.tags : [],
      }))
    : []

  return {
    resposta: typeof data?.resposta === 'string' ? data.resposta : '',
    destaque_id: data?.destaque_id ?? null,
    livros,
  }
}

export async function recomendarLivros(mensagem) {
  if (config.usarMock) {
    return normalizar(await recomendarMock(mensagem))
  }

  const supabase = getSupabase()
  const { data, error } = await supabase.functions.invoke(config.nomeFuncao, {
    body: { mensagem },
  })
  if (error) throw error
  return normalizar(data)
}
