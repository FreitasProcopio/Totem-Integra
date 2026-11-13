// Barra superior. Início e Catálogo entram em outra etapa (ficam desativados por enquanto).
export default function Header() {
  return (
    <header className="topo">
      <div className="topo__marca" aria-label="Integra Biblio">
        <svg viewBox="0 0 40 40" className="topo__logo" aria-hidden="true">
          <rect x="2" y="2" width="14" height="22" rx="2" fill="#a78bfa" />
          <rect x="18" y="2" width="14" height="10" rx="2" fill="#ede9fe" />
          <rect x="2" y="28" width="14" height="10" rx="2" fill="#7c3aed" />
          <rect x="18" y="16" width="20" height="22" rx="2" fill="#c4b5fd" />
        </svg>
        <span>
          INTEGRA
          <br />
          BIBLIO
        </span>
      </div>

      <nav className="topo__nav" aria-label="Principal">
        <span className="topo__link topo__link--desativado" title="Em breve">Página Inicial</span>
        <span className="topo__link topo__link--desativado" title="Em breve">Catálogo</span>
        <span className="topo__link topo__link--ativo" aria-current="page">Assistente de Leitura</span>
      </nav>
    </header>
  )
}
