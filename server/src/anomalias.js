// Detecção de anomalias por regras simples. A referência de cada indicador é a
// mediana dos 28 dias anteriores do mesmo tipo de dia (útil, sábado, domingo):
// assim a regra acompanha mudanças de patamar, como férias escolares.

const JANELA_REFERENCIA = 28 * 24 * 60 * 60 * 1000;
const MINIMO_AMOSTRAS = 3;

const LIMITE_CUMPRIMENTO = 0.95; // abaixo disso, alerta
const CUMPRIMENTO_CRITICO = 0.85;
const LIMITE_VIAGENS = 0.3; // desvio no volume de viagens da linha
const LIMITE_KM_POR_VIAGEM = 0.15;
const LIMITE_PASSAGEIROS = 0.3;
const DESVIO_CRITICO = 0.5;

function tipoDia(data) {
  const dia = data.getUTCDay();
  return dia === 0 ? 'domingo' : dia === 6 ? 'sabado' : 'util';
}

function mediana(valores) {
  const ordenados = [...valores].sort((a, b) => a - b);
  const meio = Math.floor(ordenados.length / 2);
  return ordenados.length % 2 ? ordenados[meio] : (ordenados[meio - 1] + ordenados[meio]) / 2;
}

/** Mediana de valor(r) nos registros do mesmo grupo e tipo de dia, nos 28 dias anteriores. */
function referencia(historico, registro, valor) {
  const amostras = historico
    .filter(
      (r) =>
        r.data < registro.data &&
        registro.data - r.data <= JANELA_REFERENCIA &&
        tipoDia(r.data) === tipoDia(registro.data),
    )
    .map(valor)
    .filter((v) => v !== null && v > 0);
  return amostras.length >= MINIMO_AMOSTRAS ? mediana(amostras) : null;
}

const severidade = (desvio) => (Math.abs(desvio) >= DESVIO_CRITICO ? 'critico' : 'alerta');
const pct = (desvio) => Math.round(Math.abs(desvio) * 100);

const passageirosTotais = (d) =>
  d.passageiros ? d.passageiros.catraca + d.passageiros.antecipados + d.passageiros.naoPagantes : null;
const kmPorViagem = (l) => (l.viagens.realizadas ? l.quilometragem / l.viagens.realizadas : null);

export function detectarAnomalias({ dias, linhas, inicio, fim }) {
  const anomalias = [];
  const noPeriodo = (r) => r.data >= inicio && r.data <= fim;

  for (const dia of dias.filter(noPeriodo)) {
    const total = passageirosTotais(dia);
    const esperado = total === null ? null : referencia(dias, dia, passageirosTotais);
    if (esperado) {
      const desvio = total / esperado - 1;
      if (Math.abs(desvio) > LIMITE_PASSAGEIROS) {
        anomalias.push({
          data: dia.data,
          linha: null,
          categoria: 'passageiros',
          descricao: `${desvio > 0 ? 'Alta' : 'Queda'} de ${pct(desvio)}% nos passageiros do sistema vs. dias semelhantes`,
          valor: total,
          esperado,
          desvio,
          severidade: severidade(desvio),
        });
      }
    }
  }

  const porLinha = new Map();
  for (const registro of linhas) {
    const codigo = registro.linha.codigo;
    if (!porLinha.has(codigo)) porLinha.set(codigo, []);
    porLinha.get(codigo).push(registro);
  }

  for (const historico of porLinha.values()) {
    for (const r of historico.filter(noPeriodo)) {
      const base = { data: r.data, linha: r.linha };
      const programadas = r.viagens.realizadas + r.viagens.naoRealizadas;

      const cumprimento = programadas ? r.viagens.realizadas / programadas : 1;
      if (cumprimento < LIMITE_CUMPRIMENTO) {
        anomalias.push({
          ...base,
          categoria: 'viagens',
          descricao: `${r.viagens.naoRealizadas} viagens não realizadas (cumprimento de ${Math.round(cumprimento * 100)}%)`,
          valor: r.viagens.realizadas,
          esperado: programadas,
          desvio: cumprimento - 1,
          severidade: cumprimento < CUMPRIMENTO_CRITICO ? 'critico' : 'alerta',
        });
      }

      const viagensEsperadas = referencia(historico, r, (x) => x.viagens.realizadas);
      if (viagensEsperadas) {
        const desvio = r.viagens.realizadas / viagensEsperadas - 1;
        if (Math.abs(desvio) > LIMITE_VIAGENS) {
          anomalias.push({
            ...base,
            categoria: 'viagens',
            descricao: `${desvio > 0 ? 'Alta' : 'Queda'} de ${pct(desvio)}% no número de viagens vs. dias semelhantes`,
            valor: r.viagens.realizadas,
            esperado: viagensEsperadas,
            desvio,
            severidade: severidade(desvio),
          });
        }
      }

      const kmAtual = kmPorViagem(r);
      const kmEsperado = kmAtual === null ? null : referencia(historico, r, kmPorViagem);
      if (kmEsperado) {
        const desvio = kmAtual / kmEsperado - 1;
        if (Math.abs(desvio) > LIMITE_KM_POR_VIAGEM) {
          anomalias.push({
            ...base,
            categoria: 'quilometragem',
            descricao: `Km por viagem ${pct(desvio)}% ${desvio > 0 ? 'acima' : 'abaixo'} do padrão da linha`,
            valor: kmAtual,
            esperado: kmEsperado,
            desvio,
            severidade: severidade(desvio),
          });
        }
      }
    }
  }

  const peso = { critico: 0, alerta: 1 };
  return anomalias.sort((a, b) => peso[a.severidade] - peso[b.severidade] || b.data - a.data);
}
