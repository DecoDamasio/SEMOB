import 'package:intl/intl.dart';

final _numero = NumberFormat.decimalPattern('pt_BR');
final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 0);
final _moedaCentavos = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
final _diaMes = DateFormat('dd/MM');

const _diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

String formatarNumero(num valor) => _numero.format(valor.round());

String formatarDecimal(num valor, [int casas = 1]) {
  return NumberFormat.decimalPatternDigits(
    locale: 'pt_BR',
    decimalDigits: casas,
  ).format(valor);
}

String formatarMoeda(num valor, {bool centavos = false}) {
  return (centavos ? _moedaCentavos : _moeda).format(valor);
}

String formatarMoedaCompacta(num valor) {
  if (valor >= 1000) {
    return 'R\$${formatarDecimal(valor / 1000, valor % 1000 == 0 ? 0 : 1)}k';
  }
  return 'R\$${formatarNumero(valor)}';
}

/// Recebe uma fração (0.964) e devolve "96,4%".
String formatarPercentual(num fracao, [int casas = 1]) {
  return '${formatarDecimal(fracao * 100, casas)}%';
}

String formatarDiaMes(DateTime data) => _diaMes.format(data);

String formatarDiaSemana(DateTime data) => _diasSemana[data.weekday - 1];

/// Variação relativa entre dois valores; null quando não há base de comparação.
double? variacao(num atual, num anterior) {
  if (anterior == 0) return null;
  return (atual - anterior) / anterior;
}
