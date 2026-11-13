// Simula a Edge Function "recomendar-livros" dentro do navegador.
// Serve para desenvolver o front antes de a função e o banco ficarem prontos.
//
// Truques para testar os estados da tela (digite no chat):
//   #erro   -> simula falha de rede
//   #vazio  -> simula "nenhum livro encontrado"

const ACERVO = [
  { id: 12, titulo: 'A Hora da Estrela', autor: 'Clarice Lispector', paginas: 88, status: 'disponivel', capa_url: null,
    sinopse: 'Macabéa, jovem nordestina no Rio de Janeiro, vive uma vida quase invisível.',
    tags: ['Literatura brasileira', 'Romance', 'Clássicos', 'Leitura curta'] },
  { id: 2, titulo: 'A Cartomante', autor: 'Machado de Assis', paginas: 32, status: 'disponivel', capa_url: null,
    sinopse: 'Conto sobre ciúme, superstição e destino.',
    tags: ['Literatura brasileira', 'Conto', 'Suspense', 'Clássicos', 'Leitura curta'] },
  { id: 3, titulo: 'Quarto de Despejo', autor: 'Carolina Maria de Jesus', paginas: 200, status: 'disponivel', capa_url: null,
    sinopse: 'Diário de uma catadora de papel moradora de favela em São Paulo.',
    tags: ['Literatura brasileira', 'Não ficção'] },
  { id: 4, titulo: 'Dom Casmurro', autor: 'Machado de Assis', paginas: 256, status: 'emprestado', capa_url: null,
    sinopse: 'Bentinho e a dúvida eterna sobre Capitu.',
    tags: ['Literatura brasileira', 'Romance', 'Clássicos'] },
  { id: 14, titulo: 'O Pequeno Príncipe', autor: 'Antoine de Saint-Exupéry', paginas: 96, status: 'disponivel', capa_url: null,
    sinopse: 'Um piloto no deserto conhece um menino que veio de outro planeta.',
    tags: ['Infantojuvenil', 'Fantasia', 'Clássicos', 'Leitura curta'] },
  { id: 15, titulo: '1984', autor: 'George Orwell', paginas: 416, status: 'reservado', capa_url: null,
    sinopse: 'Em um Estado que vigia tudo, Winston tenta guardar pensamentos próprios.',
    tags: ['Ficção científica', 'Clássicos'] },
  { id: 17, titulo: 'O Velho e o Mar', autor: 'Ernest Hemingway', paginas: 128, status: 'disponivel', capa_url: null,
    sinopse: 'Um pescador idoso enfrenta um enorme peixe em alto-mar.',
    tags: ['Clássicos', 'Romance', 'Leitura curta'] },
  { id: 26, titulo: 'Assassinato no Expresso do Oriente', autor: 'Agatha Christie', paginas: 256, status: 'disponivel', capa_url: null,
    sinopse: 'Preso na neve, o detetive Poirot investiga um crime no trem.',
    tags: ['Suspense', 'Clássicos'] },
]

const DICIONARIO = [
  { palavras: ['brasileiro', 'brasileira', 'nacional'], tag: 'Literatura brasileira' },
  { palavras: ['curto', 'curta', 'rapido'], tag: 'Leitura curta' },
  { palavras: ['classico', 'classicos'], tag: 'Clássicos' },
]

const IGNORAR = new Set(['quero', 'livro', 'livros', 'algo', 'gostaria', 'queria', 'sobre', 'para', 'ler', 'uma', 'tem'])

const semAcento = (s) => s.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '')
const espera = (ms) => new Promise((resolve) => setTimeout(resolve, ms))

function interpretar(mensagem) {
  const palavras = semAcento(mensagem).split(/[^a-z0-9]+/).filter(Boolean)
  const tags = []
  const usadas = new Set()

  for (const regra of DICIONARIO) {
    const achada = regra.palavras.find((p) => palavras.includes(p))
    if (achada) {
      tags.push(regra.tag)
      usadas.add(achada)
    }
  }
  const restante = palavras.filter((p) => p.length > 3 && !usadas.has(p) && !IGNORAR.has(p))
  return { tags, restante }
}

function filtrar({ tags, restante }, ignorarTexto) {
  return ACERVO.filter((livro) => {
    if (!tags.every((t) => livro.tags.includes(t))) return false
    if (ignorarTexto || restante.length === 0) return true
    const alvo = semAcento(`${livro.titulo} ${livro.autor} ${livro.sinopse}`)
    return restante.some((p) => alvo.includes(p))
  }).slice(0, 5)
}

export async function recomendarMock(mensagem) {
  await espera(800)

  if (mensagem.includes('#erro')) {
    const erro = new Error('Failed to send a request to the Edge Function')
    erro.name = 'FunctionsFetchError'
    throw erro
  }
  if (mensagem.includes('#vazio')) {
    return { resposta: '', destaque_id: null, livros: [] }
  }

  const pedido = interpretar(mensagem)
  let livros = filtrar(pedido, false)
  if (livros.length === 0) livros = filtrar(pedido, true) // "afrouxa" os filtros
  if (livros.length === 0) return { resposta: '', destaque_id: null, livros: [] }

  const escolhido = livros[0]
  return {
    resposta: `${escolhido.titulo}, de ${escolhido.autor}, combina com o seu pedido.`,
    destaque_id: escolhido.id,
    livros: livros.map(({ sinopse, paginas, ...resto }) => resto),
  }
}
