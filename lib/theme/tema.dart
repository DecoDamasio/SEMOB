import 'package:flutter/material.dart';

class Cores {
  static const primaria = Color(0xFF0B4A8B);
  static const primariaEscura = Color(0xFF083E77);
  static const fundo = Color(0xFFF1F4F9);
  static const borda = Color(0xFFE3E8EF);
  static const grade = Color(0xFFE8EDF3);
  static const cabecalhoTabela = Color(0xFFF7F9FC);

  static const texto = Color(0xFF0F1F33);
  static const textoSecundario = Color(0xFF5B6B82);
  static const textoMudo = Color(0xFF8A99AE);

  // Séries dos gráficos (validadas para contraste e daltonismo).
  static const serie1 = Color(0xFF1D64B8);
  static const serie2 = Color(0xFF0E9F5A);

  // Cores de status: só para estado, sempre com texto ou ícone junto.
  static const sucesso = Color(0xFF078A50);
  static const sucessoFundo = Color(0xFFE7F7EF);
  static const alerta = Color(0xFFC96F00);
  static const alertaClaro = Color(0xFFF29A1F);
  static const alertaFundo = Color(0xFFFFF4E0);
  static const critico = Color(0xFFD92D20);
  static const criticoFundo = Color(0xFFFDECEA);
  static const info = Color(0xFF1D64B8);
  static const infoFundo = Color(0xFFEAF1FB);
}

class Estilos {
  static const tituloPagina = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Cores.texto,
  );

  static const subtituloPagina = TextStyle(
    fontSize: 13,
    color: Cores.textoSecundario,
  );

  static const tituloPainel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Cores.texto,
  );

  static const subtituloPainel = TextStyle(
    fontSize: 11.5,
    color: Cores.textoMudo,
  );

  static const rotuloKpi = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: Cores.textoSecundario,
  );

  static const valorKpi = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Cores.texto,
  );

  static const eixo = TextStyle(
    fontSize: 10,
    color: Cores.textoMudo,
  );

  static const celula = TextStyle(
    fontSize: 12.5,
    color: Cores.textoSecundario,
  );

  static const celulaDestaque = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: Cores.texto,
  );
}
