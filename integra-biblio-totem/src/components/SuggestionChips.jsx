import { SUGESTOES } from '../config.js'

// Atalhos de pedido ("Algo curto", "Clássicos"...).
export default function SuggestionChips({ onEscolher, desabilitado = false }) {
  return (
    <div className="chips" role="group" aria-label="Sugestões de pedido">
      {SUGESTOES.map((s) => (
        <button
          key={s.rotulo}
          type="button"
          className="chip"
          disabled={desabilitado}
          onClick={() => onEscolher(s.mensagem)}
        >
          {s.rotulo}
        </button>
      ))}
    </div>
  )
}
