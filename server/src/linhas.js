// Nomes de exibição das linhas municipais. Os relatórios só trazem o código e o
// "atendimento" de cada sentido (ex.: "B. SANTA MARIA SENTIDO BAIRRO"), com grafias variadas.
// Ajuste aqui quando a SEMOB informar os nomes oficiais.
export const NOMES_LINHAS = {
  '01': 'Bairro Santa Maria',
  '02': 'Circular Gerty',
  '03': 'Barcelona Circular',
  '04': 'Bairro Santa Paula',
  '05': 'Bairro Mauá',
  '06': 'Bairro Nova Gerty',
  '07': 'Bairro Boa Vista',
  '08': 'Prosperidade',
  '10': 'Oswaldo Cruz',
  '11': 'Fórum - Santa Maria',
};

export function nomeLinha(codigo) {
  return NOMES_LINHAS[codigo] ?? `Linha ${codigo}`;
}
