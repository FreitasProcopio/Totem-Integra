import { useState } from 'react'

// Campo de texto + botão de enviar. Enter também envia.
export default function ChatInput({ onEnviar, desabilitado = false, limite = 300 }) {
  const [texto, setTexto] = useState('')
  const vazio = texto.trim().length === 0

  function aoEnviar(evento) {
    evento.preventDefault()
    if (vazio || desabilitado) return
    onEnviar(texto.trim())
    setTexto('')
  }

  return (
    <form className="entrada" onSubmit={aoEnviar}>
      <input
        type="text"
        value={texto}
        maxLength={limite}
        placeholder="Digite o que você quer ler…"
        aria-label="Sua mensagem"
        autoComplete="off"
        onChange={(e) => setTexto(e.target.value)}
      />
      <button type="submit" className="entrada__enviar" disabled={vazio || desabilitado} aria-label="Enviar mensagem">
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <path d="M3 11.5 20.5 4 13 21.5l-2.3-7.2z" fill="none" stroke="currentColor" strokeWidth="2" strokeLinejoin="round" />
        </svg>
      </button>
    </form>
  )
}
