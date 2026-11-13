import { useCallback, useRef, useState } from 'react'
import { config } from '../config.js'
import { recomendarLivros } from '../services/recomendarLivros.js'
import { mensagemAmigavel } from '../utils/erros.js'

const TEXTO_SEM_LIVROS =
  'Não encontrei livros para esse pedido. Tente outras palavras ou escolha um dos atalhos.'
const TEXTO_PADRAO = 'Encontrei estas opções para você:'

let sequencia = 0
function criarMensagem(papel, texto, extras = {}) {
  sequencia += 1
  return { id: sequencia, papel, texto, criadaEm: Date.now(), ...extras }
}

const saudacao = () => criarMensagem('assistant', 'Oi! 💜 O que você está com vontade de ler hoje?')

// Estado da conversa + chamada à Edge Function.
// A conversa vive só na tela: nada é salvo (sem login, sem histórico).
export function useChat() {
  const [mensagens, setMensagens] = useState(() => [saudacao()])
  const [carregando, setCarregando] = useState(false)

  const geracao = useRef(0) // muda a cada "Nova conversa" para descartar respostas atrasadas
  const ocupado = useRef(false)

  const enviar = useCallback(async (texto) => {
    const mensagem = String(texto ?? '').trim().slice(0, config.limiteMensagem)
    if (!mensagem || ocupado.current) return

    const minhaGeracao = geracao.current
    ocupado.current = true
    setCarregando(true)
    setMensagens((atual) => [...atual, criarMensagem('user', mensagem)])

    try {
      const resultado = await recomendarLivros(mensagem)
      if (minhaGeracao !== geracao.current) return

      const semLivros = resultado.livros.length === 0
      const textoResposta = semLivros ? TEXTO_SEM_LIVROS : resultado.resposta || TEXTO_PADRAO
      setMensagens((atual) => [
        ...atual,
        criarMensagem('assistant', textoResposta, {
          livros: resultado.livros,
          destaqueId: resultado.destaque_id,
        }),
      ])
    } catch (erro) {
      if (minhaGeracao !== geracao.current) return
      console.error('[useChat]', erro)
      setMensagens((atual) => [
        ...atual,
        criarMensagem('assistant', mensagemAmigavel(erro), { erro: true, reenviar: mensagem }),
      ])
    } finally {
      if (minhaGeracao === geracao.current) {
        ocupado.current = false
        setCarregando(false)
      }
    }
  }, [])

  const reiniciar = useCallback(() => {
    geracao.current += 1
    ocupado.current = false
    setCarregando(false)
    setMensagens([saudacao()])
  }, [])

  return { mensagens, carregando, enviar, reiniciar }
}
