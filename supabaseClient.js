import { createClient } from '@supabase/supabase-js'
import { config } from '../config.js'

let cliente = null

// Criado só quando for preciso, para a tela abrir mesmo sem .env (modo mock).
export function getSupabase() {
  if (cliente) return cliente

  if (!config.supabaseUrl || !config.supabaseKey) {
    throw new Error('CONFIG_SUPABASE_AUSENTE')
  }

  // O front usa SOMENTE a chave pública. A chave do modelo de IA fica na Edge Function.
  cliente = createClient(config.supabaseUrl, config.supabaseKey)
  return cliente
}
