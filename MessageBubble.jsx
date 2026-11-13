import Avatar from './Avatar.jsx'
import BookCard from './BookCard.jsx'

function formatarHora(timestamp) {
  return new Date(timestamp).toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })
}

// Um balão de conversa. Se a mensagem trouxer livros, os cards aparecem logo abaixo.
export default function MessageBubble({ mensagem, podeTentarNovamente = false, onTentarNovamente }) {
  const { papel, texto, criadaEm, livros = [], destaqueId = null, erro = false, reenviar = null } = mensagem
  const ehUsuario = papel === 'user'

  return (
    <div className={`mensagem ${ehUsuario ? 'mensagem--usuario' : 'mensagem--integra'}`}>
      <div className="mensagem__linha">
        {!ehUsuario && <Avatar />}

        <div className="mensagem__conteudo">
          <span className="mensagem__meta">
            {ehUsuario ? 'Você' : 'Integra'} · {formatarHora(criadaEm)}
          </span>
          <p className={`balao ${erro ? 'balao--erro' : ''}`}>{texto}</p>

          {erro && reenviar && podeTentarNovamente && (
            <button type="button" className="botao-secundario" onClick={() => onTentarNovamente(reenviar)}>
              Tentar de novo
            </button>
          )}
        </div>
      </div>

      {livros.length > 0 && (
        <div className="livros" role="list">
          {livros.map((livro) => (
            <BookCard key={livro.id} livro={livro} destaque={livro.id === destaqueId} />
          ))}
        </div>
      )}
    </div>
  )
}
