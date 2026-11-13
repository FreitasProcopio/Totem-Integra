// Tipos do ambiente das Supabase Edge Functions
import "@supabase/functions-js/edge-runtime.d.ts";

// Wrapper do Supabase para autenticação e CORS
import { withSupabase } from "@supabase/server";

// Limite provisório para a mensagem enviada pelo usuário
const LIMITE_MENSAGEM = 500;

export default {
  fetch: withSupabase(
    { auth: "publishable" },

    async (req) => {
      // A função deve receber requisições POST
      if (req.method !== "POST") {
        return Response.json(
          {
            erro: "Método não permitido.",
          },
          {
            status: 405,
          },
        );
      }

      // Tenta interpretar o corpo da requisição como JSON
      let body;

      try {
        body = await req.json();
      } catch {
        return Response.json(
          {
            erro: "O corpo da requisição deve ser um JSON válido.",
          },
          {
            status: 400,
          },
        );
      }

      // Pega a mensagem enviada pelo front
      const { mensagem } = body;

      // Confere se mensagem realmente é um texto
      if (typeof mensagem !== "string") {
        return Response.json(
          {
            erro: "O campo 'mensagem' deve ser um texto.",
          },
          {
            status: 400,
          },
        );
      }

      // Remove espaços extras do começo e do fim
      const mensagemLimpa = mensagem.trim();

      // Impede mensagens vazias
      if (mensagemLimpa.length === 0) {
        return Response.json(
          {
            erro: "A mensagem não pode estar vazia.",
          },
          {
            status: 400,
          },
        );
      }

      // Impede mensagens grandes demais
      if (mensagemLimpa.length > LIMITE_MENSAGEM) {
        return Response.json(
          {
            erro: `A mensagem deve ter no máximo ${LIMITE_MENSAGEM} caracteres.`,
          },
          {
            status: 400,
          },
        );
      }

      // Resposta MOCK da Sprint 1
      return Response.json({
        resposta:
          "Mensagem recebida com sucesso. Esta é uma resposta de teste do Integra Biblio.",
        destaque_id: null,
        livros: [],
      });
    },
  ),
};