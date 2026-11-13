import { useEffect, useRef } from 'react'
import { config } from '../config.js'
import { useChat } from '../hooks/useChat.js'
import Header from './Header.jsx'
import MessageBubble from './MessageBubble.jsx'
import Digitando from './Digitando.jsx'
import SuggestionChips from './SuggestionChips.jsx'
import ChatInput from './ChatInput.jsx'

// Organiza a tela. Estados: vazio, carregando, erro e sucesso.
export default function ChatPage() {
  const { mensagens, carregando, enviar, reiniciar } = useChat()
  const fimRef = useRef(null)
  const vazio = mensagens.length <= 1

  // Modo totem: letras e botões maiores (veja styles/index.css).
  useEffect(() => {
    document.documentElement.classList.toggle('totem', config.modoTotem)
  }, [])

  // Rola sempre até a última mensagem.
  useEffect(() => {
    fimRef.current?.scrollIntoView({ behavior: 'smooth', block: 'end' })
  }, [mensagens, carregando])

  // Totem: se ninguém tocar na tela por um tempo, a conversa recomeça para a próxima pessoa.
  useEffect(() => {
    if (!config.modoTotem || vazio) return undefined

    let relogio = setTimeout(reiniciar, config.tempoOciosoTotemMs)
    const zerar = () => {
      clearTimeout(relogio)
      relogio = setTimeout(reiniciar, config.tempoOciosoTotemMs)
    }
    const eventos = ['pointerdown', 'keydown']
    eventos.forEach((e) => window.addEventListener(e, zerar))

    return () => {
      clearTimeout(relogio)
      eventos.forEach((e) => window.removeEventListener(e, zerar))
    }
  }, [vazio, reiniciar])

  return (
    <div className="pagina">
      <Header />

      <main className="palco">
        <section className="chat" aria-label="Conversa com o assistente de leitura">
          <div className="chat__topo">
            <h1 className="chat__titulo">Assistente de Leitura</h1>
            {!vazio && (
              <button type="button" className="botao-secundario" onClick={reiniciar}>
                Nova conversa
              </button>
            )}
          </div>

          <div className="chat__mensagens" role="log" aria-live="polite">
            {mensagens.map((mensagem, i) => (
              <MessageBubble
                key={mensagem.id}
                mensagem={mensagem}
                podeTentarNovamente={i === mensagens.length - 1 && !carregando}
                onTentarNovamente={enviar}
              />
            ))}

            {vazio && !carregando && (
              <p className="dica">Escolha um atalho ou escreva o que você procura.</p>
            )}

            {carregando && <Digitando />}
            <div ref={fimRef} />
          </div>

          <div className="chat__rodape">
            <SuggestionChips onEscolher={enviar} desabilitado={carregando} />
            <ChatInput onEnviar={enviar} desabilitado={carregando} limite={config.limiteMensagem} />
          </div>
        </section>
      </main>
    </div>
  )
}
