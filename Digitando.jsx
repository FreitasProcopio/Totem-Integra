// Estado "carregando": três pontinhos enquanto a função responde.
import Avatar from './Avatar.jsx'

export default function Digitando() {
  return (
    <div className="mensagem mensagem--integra" role="status" aria-label="Integra está procurando livros">
      <div className="mensagem__linha">
        <Avatar />
        <div className="mensagem__conteudo">
          <span className="mensagem__meta">Integra · procurando…</span>
          <p className="balao balao--digitando" aria-hidden="true">
            <span /><span /><span />
          </p>
        </div>
      </div>
    </div>
  )
}
