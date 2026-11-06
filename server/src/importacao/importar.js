// Importa os relatórios HTML do Smart Report (pasta dados/) para o MongoDB.
// Uso: npm run importar [-- <pasta>]   (padrão: ../dados)
//
// Cada execução relê todos os arquivos e recria as coleções, então pode ser
// rodada de novo sempre que chegarem relatórios novos. Os quinzenais repetem
// dias dos mensais; registros do mesmo dia são mesclados.
import { readdirSync, statSync } from 'node:fs';
import { basename, join, relative, resolve } from 'node:path';

import { conectar, desconectar, diasLinha, diasSistema, falhasViagem } from '../db.js';
import { nomeLinha } from '../linhas.js';
import { formatarData } from '../periodos.js';
import { dataBr, dataMesDia, numero, tabelaCom } from './html.js';

const pasta = resolve(process.argv[2] ?? '../dados');

function listarArquivos(dir) {
  return readdirSync(dir).flatMap((nome) => {
    const caminho = join(dir, nome);
    return statSync(caminho).isDirectory() ? listarArquivos(caminho) : [caminho];
  });
}

const sistema = new Map(); // "AAAA-MM-DD" -> documento
const linhas = new Map(); // "AAAA-MM-DD|01" -> documento
const falhas = new Map();
const conflitos = [];

/** Grava valor[caminho] no documento; avisa se já havia um valor diferente. */
function definir(documento, caminho, valor) {
  const chaves = caminho.split('.');
  const ultima = chaves.pop();
  const alvo = chaves.reduce((obj, chave) => (obj[chave] ??= {}), documento);
  // Relatórios exportados antes do fim do dia trazem 0 no lugar do valor real.
  if (valor === 0 && alvo[ultima]) return;
  if (alvo[ultima] !== undefined && alvo[ultima] !== 0 && alvo[ultima] !== valor) {
    conflitos.push(`${formatarData(documento.data)} ${caminho}: ${alvo[ultima]} -> ${valor}`);
  }
  alvo[ultima] = valor;
}

function dia(data) {
  const chave = formatarData(data);
  if (!sistema.has(chave)) sistema.set(chave, { data });
  return sistema.get(chave);
}

function diaLinha(data, codigo) {
  const chave = `${formatarData(data)}|${codigo}`;
  if (!linhas.has(chave)) {
    linhas.set(chave, {
      data,
      linha: { codigo, nome: nomeLinha(codigo) },
      viagens: { naoRealizadas: 0 },
    });
  }
  return linhas.get(chave);
}

const importadores = [
  {
    nome: 'Resumo geral',
    padrao: /^(Mensal|Quinzenal)_\d{6}\.html$/,
    importar(arquivo) {
      for (const r of tabelaCom(arquivo, 'nrViagensProgr')) {
        const data = dataBr(r.Data);
        if (!data) continue;
        const d = dia(data);
        definir(d, 'frota.veiculos', numero(r.nrVeiculos));
        definir(d, 'frota.maximoPorFaixa', numero(r.nrMaxVeicFx));
        definir(d, 'viagens.programadas', numero(r.nrViagensProgr));
        definir(d, 'viagens.realizadas', numero(r.nrViagensRealiz));
        definir(d, 'quilometragem.produtiva', numero(r.kmProd));
        definir(d, 'quilometragem.improdutiva', numero(r.kmImprod));
        definir(d, 'quilometragem.total', numero(r.kmTotal));
      }
    },
  },
  {
    nome: 'Resumo por linha',
    padrao: /_Linhas_\d{6}\.html$/,
    importar(arquivo) {
      for (const r of tabelaCom(arquivo, 'nrViagens')) {
        const data = dataBr(r.Data);
        if (!data || !r.Linha) continue;
        const d = diaLinha(data, r.Linha);
        definir(d, 'quilometragem', numero(r.kmTotal));
        definir(d, 'viagens.realizadas', numero(r.nrViagens));
      }
    },
  },
  {
    nome: 'Cumprimento por turno',
    padrao: /_FCV_\d{6}\.html$/,
    importar(arquivo) {
      for (const r of tabelaCom(arquivo, 'manha_p')) {
        const data = dataBr(r.Data);
        if (!data) continue;
        const d = dia(data);
        for (const turno of ['manha', 'tarde', 'noite']) {
          definir(d, `turnos.${turno}.programadas`, numero(r[`${turno}_p`]));
          definir(d, `turnos.${turno}.realizadas`, numero(r[`${turno}_r`]));
        }
      }
    },
  },
  {
    nome: 'Resumo por faixa horária',
    padrao: /_Resumo_FxHr_\d{6}\.html$/,
    importar(arquivo) {
      for (const r of tabelaCom(arquivo, 'Fx_Hor')) {
        const data = dataBr(r.Data);
        const hora = Number.parseInt(r.Fx_Hor, 10);
        if (!data || Number.isNaN(hora)) continue;
        const faixa = `faixas.${String(hora).padStart(2, '0')}`;
        definir(dia(data), `${faixa}.veiculos`, numero(r.Nr_Veiculos));
        definir(dia(data), `${faixa}.viagens`, numero(r.Nr_Viagens));
      }
    },
  },
  {
    nome: 'Passageiros',
    padrao: /^Passageiros.*\.html$/,
    importar(arquivo) {
      for (const r of tabelaCom(arquivo, 'Catraca')) {
        const data = dataMesDia(r['Mês'], r.Dia);
        if (!data) continue;
        const d = dia(data);
        definir(d, 'passageiros.catraca', numero(r.Catraca));
        definir(d, 'passageiros.antecipados', numero(r.Antecipados));
        definir(d, 'passageiros.naoPagantes', numero(r['Não Pagantes']));
      }
    },
  },
  {
    nome: 'Créditos (venda x utilização)',
    padrao: /^Saldos.*\.html$/,
    importar(arquivo) {
      for (const r of tabelaCom(arquivo, 'Total Vendas')) {
        const data = dataMesDia(r['Mês'], r.Dia);
        if (!data) continue;
        const d = dia(data);
        definir(d, 'creditos.vendas', numero(r['Total Vendas']));
        definir(d, 'creditos.utilizacao', numero(r['Total Utilização']));
      }
    },
  },
  {
    nome: 'Viagens com falha',
    padrao: /_Viag_(NRealiz|Ninic|NTerm)_\d{6}\.html$/,
    importar(arquivo) {
      const tipo = {
        NRealiz: 'naoRealizada',
        Ninic: 'naoIniciada',
        NTerm: 'naoTerminada',
      }[basename(arquivo).match(/_Viag_(\w+?)_/)[1]];

      for (const r of tabelaCom(arquivo, 'Atendimento')) {
        const data = dataBr(r.Data);
        if (!data || !r.Linha) continue;
        // A coluna Motorista é ignorada de propósito: o painel não precisa dela.
        const falha = {
          data,
          tipo,
          linha: { codigo: r.Linha, nome: nomeLinha(r.Linha) },
          atendimento: r.Atendimento,
          sentido: r.Sentido,
          inicioProgramado: r.inicioProgramado.slice(11, 16),
          fimProgramado: r.fimProgramado.slice(11, 16),
        };
        falhas.set(`${formatarData(data)}|${r.Linha}|${tipo}|${r.Sentido}|${r.Tabela}|${r.inicioProgramado}`, falha);
      }
    },
  },
];

// Arquivos lidos sem importar: detalhamento por viagem, grande e não usado pelo painel ainda.
const ignorados = [/_Viagens_\d{6}\.html$/, /_FxHr_\d{6}\.html$/];

const arquivos = listarArquivos(pasta).filter((f) => f.endsWith('.html')).sort();
const contagem = new Map();

for (const arquivo of arquivos) {
  const nome = basename(arquivo);
  const importador = importadores.find((i) => i.padrao.test(nome));
  if (!importador) {
    if (!ignorados.some((p) => p.test(nome))) {
      console.warn(`Formato desconhecido, ignorado: ${relative(pasta, arquivo)}`);
    }
    continue;
  }
  importador.importar(arquivo);
  contagem.set(importador.nome, (contagem.get(importador.nome) ?? 0) + 1);
}

// Viagens não realizadas por linha e dia, para calcular as programadas da linha.
for (const falha of falhas.values()) {
  if (falha.tipo === 'naoRealizada') diaLinha(falha.data, falha.linha.codigo).viagens.naoRealizadas++;
}
for (const registro of linhas.values()) {
  registro.quilometragem ??= 0;
  registro.viagens.realizadas ??= 0;
}

await conectar();
for (const [colecao, documentos] of [
  [diasSistema(), [...sistema.values()]],
  [diasLinha(), [...linhas.values()]],
  [falhasViagem(), [...falhas.values()]],
]) {
  await colecao.deleteMany({});
  if (documentos.length) await colecao.insertMany(documentos);
}
await desconectar();

const datas = [...sistema.keys()].sort();
console.log(`Pasta: ${pasta}`);
for (const [nome, total] of contagem) console.log(`  ${nome}: ${total} arquivo(s)`);
console.log(`Dias do sistema: ${sistema.size} (${datas[0]} a ${datas.at(-1)})`);
console.log(`Registros por linha: ${linhas.size}`);
console.log(`Viagens com falha: ${falhas.size}`);
const semPassageiros = [...sistema.values()].filter((d) => !d.passageiros).length;
if (semPassageiros) console.log(`Atenção: ${semPassageiros} dia(s) sem dados de passageiros.`);
if (conflitos.length) {
  console.log(`Atenção: ${conflitos.length} valor(es) diferentes entre arquivos para o mesmo dia (prevaleceu o último lido):`);
  for (const conflito of conflitos.slice(0, 15)) console.log(`  ${conflito}`);
}
