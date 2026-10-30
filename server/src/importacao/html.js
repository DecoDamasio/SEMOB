import { readFileSync } from 'node:fs';

// Os relatórios do Smart Report são salvos em Windows-1252 (charset "Cp1252").
const decodificador = new TextDecoder('windows-1252');

function limpar(texto) {
  return texto
    .replace(/<br\s*\/?>/gi, ' ')
    .replace(/<[^>]+>/g, '')
    .replace(/&nbsp;/g, ' ')
    .replace(/&quot;/g, '"')
    .replace(/&amp;/g, '&')
    .replace(/\s+/g, ' ')
    .trim();
}

function celulas(trecho, tag) {
  const regex = new RegExp(`<${tag}[^>]*>([\\s\\S]*?)</${tag}>`, 'gi');
  return [...trecho.matchAll(regex)].map((m) => limpar(m[1]));
}

/**
 * Lê todas as tabelas do arquivo como listas de objetos { coluna: valor }.
 * O cabeçalho pode vir em <th> soltos antes da primeira <tr> ou numa <tr> só de <th>.
 */
export function lerTabelas(arquivo) {
  const html = decodificador.decode(readFileSync(arquivo));
  const tabelas = [];

  for (const tabela of html.split(/<table/i).slice(1)) {
    let cabecalho = celulas(tabela.split(/<tr/i)[0], 'th');
    const registros = [];

    for (const [, tr] of tabela.matchAll(/<tr[^>]*>([\s\S]*?)<\/tr>/gi)) {
      const dados = celulas(tr, 'td');
      if (!dados.length) {
        if (!cabecalho.length) cabecalho = celulas(tr, 'th');
        continue;
      }
      if (cabecalho.length) {
        registros.push(Object.fromEntries(cabecalho.map((coluna, i) => [coluna, dados[i] ?? ''])));
      }
    }

    tabelas.push({ cabecalho, registros });
  }
  return tabelas;
}

/** Primeira tabela que contém a coluna indicada. */
export function tabelaCom(arquivo, coluna) {
  return lerTabelas(arquivo).find((t) => t.cabecalho.includes(coluna))?.registros ?? [];
}

/** Converte "1.050.248", "6889,4" ou "4.805,00" em número. */
export function numero(texto) {
  if (texto === undefined || texto === '') return 0;
  const valor = Number(texto.replace(/\./g, '').replace(',', '.'));
  return Number.isNaN(valor) ? 0 : valor;
}

/** "01/08/2026" -> Date UTC. */
export function dataBr(texto) {
  const partes = texto.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);
  return partes ? new Date(Date.UTC(+partes[3], +partes[2] - 1, +partes[1])) : null;
}

/** Mês "2026-08" + dia "01" -> Date UTC. */
export function dataMesDia(mes, dia) {
  const partes = `${mes}-${dia}`.match(/^(\d{4})-(\d{2})-(\d{2})$/);
  return partes ? new Date(Date.UTC(+partes[1], +partes[2] - 1, +partes[3])) : null;
}
