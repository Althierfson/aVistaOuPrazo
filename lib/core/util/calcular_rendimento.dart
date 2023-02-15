import 'package:avistaouaprazo/core/error/falhas.dart';
import 'package:avistaouaprazo/core/util/convert_to_string_real.dart';
import 'package:avistaouaprazo/core/util/tipo_resutado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/resultado.dart';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';

// Contates
Decimal mediaDeDiasNoMes = Decimal.parse("30.42");
Decimal tributacao180D =
    Decimal.parse("22.50"); // Tributação para valores sacados antes de 180D
Decimal tributacao365D =
    Decimal.parse("20.00"); // Tributação para valores sacados antes de 365D

abstract class CalcularRendimento {
  Either<Falha, Resultado> call(
      {required CalcularRendimentoParametro parametro, required double taxa});
}

class CalcularRendimentoImpl extends CalcularRendimento {
  final ConvertTo convertTo;

  CalcularRendimentoImpl({required this.convertTo});

  @override
  Either<Falha, Resultado> call(
      {required CalcularRendimentoParametro parametro, required double taxa}) {
    try {
      Decimal taxaDecimal = fromDoubleToDecimal(taxa);

      Resultado resultadoAPrazo =
          calcularRedimentoAPrazo(parametro, taxaDecimal);

      Resultado resultadoAVista =
          calcularRendimentoAVista(parametro, taxaDecimal);

      return right(joinResultado(
          resultadoAPrazo: resultadoAPrazo, resultadoAVista: resultadoAVista));
    } on Falha catch (falha) {
      return Left(falha);
    }
  }

  Resultado calcularRendimentoAVista(
      CalcularRendimentoParametro parametro, Decimal taxa) {
    List<Decimal> historicoDeRendimento = [];
    Decimal valorDaCompra = Decimal.zero;
    Decimal valorDaCompraAVista = Decimal.zero;
    Decimal valor = Decimal.zero;

    try {
      valorDaCompra = fromStringToDecimal(parametro.valorDaCompra);

      valorDaCompraAVista = fromStringToDecimal(parametro.valorVista);
    } on Falha {
      rethrow;
    }

    valor = valorDaCompra - valorDaCompraAVista;

    for (int i = 0; i < parametro.parcelas; i++) {
      Decimal rendimento = calcularRendimentoNoMes(valor, taxa);
      Decimal tributos =
          calculcarTributos(rendimento, getTaxaDeTributos(parametro.parcelas));
      valor = valor + (rendimento - tributos);
      historicoDeRendimento.add(valor);
    }

    Decimal rendimentoTotal = historicoDeRendimento.last;

    String rendimentoTotalString = "";
    String valorAVistaString = "";
    try {
      rendimentoTotalString = fromDecimalToStringReal(rendimentoTotal);

      valorAVistaString = fromDecimalToStringReal(valorDaCompraAVista);
    } on Falha {
      rethrow;
    }

    List<double> historicoDeRendimentoDouble = [];
    for (var decimal in historicoDeRendimento) {
      try {
        historicoDeRendimentoDouble.add(fromDecimalToDouble(decimal));
      } on Falha {
        rethrow;
      }
    }

    return Resultado(
        qualMelhor: TiposDeResultados.aVista,
        produtoMaisLucroAVista: rendimentoTotalString,
        produtoMaisLucroAPrazo: "produtoMaisLucroAPrazo",
        parcelas: parametro.parcelas.toString(),
        valorAVista: valorAVistaString,
        valorAPrazo: "valorAPrazo",
        historicoAvista: historicoDeRendimentoDouble,
        historicoAPrazo: const []);
  }

  Resultado calcularRedimentoAPrazo(
      CalcularRendimentoParametro parametro, Decimal taxa) {
    List<Decimal> historicoDeRendimento = [];
    Decimal valorDaCompra = Decimal.zero;
    Decimal valor = Decimal.zero;
    Decimal parcela = Decimal.zero;

    try {
      valorDaCompra = fromStringToDecimal(parametro.valorDaCompra);
      parcela = fromDoubleToDecimal(
          (valorDaCompra / Decimal.fromInt(parametro.parcelas)).toDouble());
    } on Falha {
      rethrow;
    }

    valor = valorDaCompra;

    for (int i = 0; i < parametro.parcelas; i++) {
      Decimal rendimento = calcularRendimentoNoMes(valor, taxa);
      Decimal tributos =
          calculcarTributos(rendimento, getTaxaDeTributos(parametro.parcelas));
      valor = valor - parcela + (rendimento - tributos);
      historicoDeRendimento.add(valor);
    }

    Decimal rendimentoTotal = historicoDeRendimento.last;

    String rendimentoTotalString = "";
    String valorAPrazoString = "";

    try {
      rendimentoTotalString = fromDecimalToStringReal(rendimentoTotal);
      valorAPrazoString = fromDecimalToStringReal(valorDaCompra);
    } on Falha {
      rethrow;
    }

    List<double> historicoDeRendimentoDouble = [];
    for (var decimal in historicoDeRendimento) {
      try {
        historicoDeRendimentoDouble.add(fromDecimalToDouble(decimal));
      } on Falha {
        rethrow;
      }
    }

    return Resultado(
        qualMelhor: TiposDeResultados.aPrazo,
        produtoMaisLucroAVista: "produtoMaisLucroAVista",
        produtoMaisLucroAPrazo: rendimentoTotalString,
        parcelas: parametro.parcelas.toString(),
        valorAVista: "valorAVista",
        valorAPrazo: valorAPrazoString,
        historicoAvista: const [],
        historicoAPrazo: historicoDeRendimentoDouble);
  }

  Decimal calcularRendimentoNoMes(Decimal valor, Decimal taxa) {
    double taxaDouble = taxa.toDouble();

    taxaDouble = (taxaDouble / 365) / 100;

    double rendimento =
        valor.toDouble() * taxaDouble * mediaDeDiasNoMes.toDouble();

    try {
      return fromDoubleToDecimal(rendimento);
    } on Falha {
      rethrow;
    }
  }

  Decimal calculcarTributos(Decimal rendimento, Decimal taxa) {
    double taxaDouble = taxa.toDouble();

    taxaDouble = taxaDouble / 100;

    double tributos = rendimento.toDouble() * taxaDouble;

    Decimal tributosDecimal = Decimal.zero;
    try {
      tributosDecimal = fromDoubleToDecimal(tributos);
    } on Falha {
      rethrow;
    }

    return tributosDecimal;
  }

  Decimal getTaxaDeTributos(int numeroDeMeses) {
    if (numeroDeMeses <= 6) {
      return tributacao180D;
    } else {
      return tributacao365D;
    }
  }

  Resultado joinResultado(
      {required Resultado resultadoAPrazo,
      required Resultado resultadoAVista}) {
    Decimal aVista = Decimal.zero;
    Decimal aPrazo = Decimal.zero;
    late TipoResultado tipoResultado;

    try {
      aVista = fromStringToDecimal(
          resultadoAVista.produtoMaisLucroAVista.substring(3));
      aPrazo = fromStringToDecimal(
          resultadoAPrazo.produtoMaisLucroAPrazo.substring(3));
    } on Falha {
      rethrow;
    }

    if (aVista == aPrazo) {
      tipoResultado = TiposDeResultados.aPrazo;
    } else {
      if (aVista > aPrazo) {
        tipoResultado = TiposDeResultados.aVista;
      } else {
        tipoResultado = TiposDeResultados.aPrazo;
      }
    }

    return Resultado(
        qualMelhor: tipoResultado,
        produtoMaisLucroAVista: resultadoAVista.produtoMaisLucroAVista,
        produtoMaisLucroAPrazo: resultadoAPrazo.produtoMaisLucroAPrazo,
        parcelas: resultadoAPrazo.parcelas,
        valorAVista: resultadoAVista.valorAVista,
        valorAPrazo: resultadoAPrazo.valorAPrazo,
        historicoAvista: resultadoAVista.historicoAvista,
        historicoAPrazo: resultadoAPrazo.historicoAPrazo);
  }

  Decimal fromDoubleToDecimal(double valor) {
    Decimal decimalValor = Decimal.zero;
    try {
      convertTo.fromDoubleToDecimal(valor).fold((l) {
        throw l;
      }, (r) {
        decimalValor = r;
      });
      return decimalValor;
    } on Falha {
      rethrow;
    }
  }

  Decimal fromStringToDecimal(String valor) {
    Decimal decimalValor = Decimal.zero;
    try {
      convertTo.fromStringToDecimal(valor).fold((l) {
        throw l;
      }, (r) {
        decimalValor = r;
      });
      return decimalValor;
    } on Falha {
      rethrow;
    }
  }

  String fromDecimalToStringReal(Decimal valor) {
    String stringValor = "";
    try {
      convertTo.fromDecimalToStringReal(valor).fold((l) {
        throw l;
      }, (r) => stringValor = r);
      return stringValor;
    } on Falha {
      rethrow;
    }
  }

  double fromDecimalToDouble(Decimal valor) {
    double doubleValor = 0.0;
    try {
      convertTo.fromDecimalToDouble(valor).fold((l) {
        throw l;
      }, (r) => doubleValor = r);
      return doubleValor;
    } on Falha {
      rethrow;
    }
  }
}

class CalcularRendimentoParametro {
  final String valorDaCompra;
  final String valorVista;
  final int parcelas;

  CalcularRendimentoParametro(
      {required this.valorDaCompra,
      required this.valorVista,
      required this.parcelas});
}
