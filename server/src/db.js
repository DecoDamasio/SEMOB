import { MongoClient } from 'mongodb';

const uri = process.env.MONGODB_URI ?? 'mongodb://127.0.0.1:27017';
const nomeBanco = process.env.MONGODB_DB ?? 'semob';

const client = new MongoClient(uri);
let db;

export async function conectar() {
  if (!db) {
    await client.connect();
    db = client.db(nomeBanco);
    await diasSistema().createIndex({ data: 1 }, { unique: true });
    await diasLinha().createIndex({ data: 1, 'linha.codigo': 1 }, { unique: true });
    await falhasViagem().createIndex({ data: 1 });
  }
  return db;
}

export async function desconectar() {
  await client.close();
  db = undefined;
}

// Um documento por dia com os totais do sistema (frota, km, viagens, passageiros, créditos).
export function diasSistema() {
  return db.collection('operacao_diaria');
}

// Um documento por linha por dia (km e viagens).
export function diasLinha() {
  return db.collection('operacao_linhas');
}

// Viagens não realizadas, não iniciadas ou não terminadas.
export function falhasViagem() {
  return db.collection('viagens_falhas');
}
