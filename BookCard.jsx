import { useState } from 'react'

const STATUS = {
  disponivel: { rotulo: 'Disponível', classe: 'disponivel' },
  emprestado: { rotulo: 'Emprestado', classe: 'emprestado' },
  reservado: { rotulo: 'Reservado', classe: 'reservado' },
}

// Card do livro: capa, título, autor, tags e status.
export default function BookCard({ livro, destaque = false }) {
  const [capaQuebrada, setCapaQuebrada] = useState(false)
  const status = STATUS[livro.status] ?? { rotulo: livro.status, classe: 'outro' }
  const mostrarCapa = Boolean(livro.capa_url) && !capaQuebrada

  return (
    <article className={`card-livro ${destaque ? 'card-livro--destaque' : ''}`} role="listitem">
      {destaque && <span className="card-livro__selo">Minha escolha</span>}

      <div className="card-livro__capa">
        {mostrarCapa ? (
          <img
            src={livro.capa_url}
            alt={`Capa de ${livro.titulo}`}
            loading="lazy"
            onError={() => setCapaQuebrada(true)}
          />
        ) : (
          <div className="capa-padrao" aria-hidden="true">
            <span>{livro.titulo}</span>
          </div>
        )}
      </div>

      <div className="card-livro__info">
        <h3 className="card-livro__titulo">{livro.titulo}</h3>
        <p className="card-livro__autor">{livro.autor}</p>

        {livro.tags.length > 0 && (
          <ul className="tags">
            {livro.tags.slice(0, 3).map((tag) => (
              <li key={tag}>{tag}</li>
            ))}
          </ul>
        )}

        <span className={`status status--${status.classe}`}>{status.rotulo}</span>
      </div>
    </article>
  )
}
