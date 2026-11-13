// Mascote do assistente: um livrinho simpático.
export default function Avatar() {
  return (
    <svg className="avatar" viewBox="0 0 48 48" role="img" aria-label="Integra, o livrinho">
      <rect x="9" y="6" width="30" height="36" rx="6" fill="#ddd6fe" stroke="#6d28d9" strokeWidth="2.5" />
      <rect x="9" y="6" width="7" height="36" rx="3" fill="#8b5cf6" />
      <circle cx="25" cy="22" r="2.4" fill="#1e1048" />
      <circle cx="33" cy="22" r="2.4" fill="#1e1048" />
      <path d="M24 29 q5 5 10 0" fill="none" stroke="#1e1048" strokeWidth="2.2" strokeLinecap="round" />
    </svg>
  )
}
