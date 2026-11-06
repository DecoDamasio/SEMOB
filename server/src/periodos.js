const UM_DIA = 24 * 60 * 60 * 1000;

// Janelas móveis terminando na data de referência.
export const DIAS_POR_PERIODO = {
  diario: 1,
  semanal: 7,
  mensal: 30,
};

export function parseData(texto) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(texto)) return null;
  const data = new Date(`${texto}T00:00:00Z`);
  return Number.isNaN(data.getTime()) ? null : data;
}

export function formatarData(data) {
  return data.toISOString().slice(0, 10);
}

export function janela(periodo, fim) {
  const dias = DIAS_POR_PERIODO[periodo];
  return {
    inicio: new Date(fim.getTime() - (dias - 1) * UM_DIA),
    fim,
  };
}

export function janelaAnterior(periodo, fim) {
  const dias = DIAS_POR_PERIODO[periodo];
  return janela(periodo, new Date(fim.getTime() - dias * UM_DIA));
}
