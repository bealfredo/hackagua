// lib/services/calculo_economia_service.dart

import '../models/desperdicio_agua.dart';

/// Serviço para calcular economia de água e valores monetários
/// baseado nas tarifas da BRK Ambiental no Tocantins
class CalculoEconomiaService {
  /// Estrutura tarifária progressiva do Tocantins (2025)
  /// Valores em R$ por m³ (1000 litros)
  static const List<_FaixaTarifa> _tabelaTarifaria = [
    _FaixaTarifa(limiteInferior: 0, limiteSuperior: 10, valorPorM3: 4.97),
    _FaixaTarifa(limiteInferior: 10, limiteSuperior: 15, valorPorM3: 9.49),
    _FaixaTarifa(limiteInferior: 15, limiteSuperior: 20, valorPorM3: 10.97),
    _FaixaTarifa(limiteInferior: 20, limiteSuperior: 30, valorPorM3: 11.72),
    _FaixaTarifa(limiteInferior: 30, limiteSuperior: 40, valorPorM3: 12.10),
    _FaixaTarifa(limiteInferior: 40, limiteSuperior: double.infinity, valorPorM3: 12.80),
  ];

  /// Percentual da taxa de esgoto sobre o valor da água
  static const double _percentualEsgoto = 0.80;

  /// Consumo mínimo obrigatório (mesmo que gaste menos, paga por 5m³)
  static const double _consumoMinimoM3 = 5.0;

  /// Calcula o valor em reais de um consumo em metros cúbicos
  /// usando a tabela progressiva da BRK Ambiental
  static double calcularValorConsumo(double metrosCubicos) {
    if (metrosCubicos < _consumoMinimoM3) {
      metrosCubicos = _consumoMinimoM3;
    }

    double valorAgua = 0.0;
    double consumoRestante = metrosCubicos;

    for (var faixa in _tabelaTarifaria) {
      if (consumoRestante <= 0) break;

      double consumoNaFaixa = 0.0;

      if (consumoRestante <= (faixa.limiteSuperior - faixa.limiteInferior)) {
        // Todo o consumo restante está nesta faixa
        consumoNaFaixa = consumoRestante;
      } else {
        // Apenas parte do consumo está nesta faixa
        consumoNaFaixa = faixa.limiteSuperior - faixa.limiteInferior;
      }

      valorAgua += consumoNaFaixa * faixa.valorPorM3;
      consumoRestante -= consumoNaFaixa;
    }

    // Adiciona taxa de esgoto (80% do valor da água)
    double valorEsgoto = valorAgua * _percentualEsgoto;
    double valorTotal = valorAgua + valorEsgoto;

    return valorTotal;
  }

  /// Calcula economia em reais baseado em litros economizados
  static double calcularEconomiaReais(double litrosEconomizados) {
    double metrosCubicos = litrosEconomizados / 1000;
    
    // Calcula o valor que seria gasto com esse consumo
    return calcularValorConsumo(metrosCubicos);
  }

  /// Calcula economia baseada em uma detecção de desperdício
  static ResultadoEconomia calcularEconomiaDesperdicio(DeteccaoDesperdicio deteccao) {
    double litrosEconomizados = deteccao.litrosDesperdicados;
    double valorEconomizado = calcularEconomiaReais(litrosEconomizados);

    return ResultadoEconomia(
      litrosEconomizados: litrosEconomizados,
      metrosCubicosEconomizados: deteccao.metrosCubicosDesperdicados,
      valorEconomizadoReais: valorEconomizado,
      tipoDesperdicio: deteccao.tipo,
      dataCalculo: DateTime.now(),
    );
  }

  /// Calcula economia mensal estimada se o usuário corrigir o desperdício
  static ResultadoEconomiaMensal calcularEconomiaMensal(
    TipoDesperdicio tipo, {
    int diasPorMes = 30,
    int ocorrenciasPorDia = 1,
  }) {
    double litrosPorOcorrencia = tipo.consumoMedioLitros;
    double litrosMensal = litrosPorOcorrencia * ocorrenciasPorDia * diasPorMes;
    double metrosCubicosMensal = litrosMensal / 1000;
    double valorMensal = calcularEconomiaReais(litrosMensal);

    return ResultadoEconomiaMensal(
      litrosEconomizadosMensal: litrosMensal,
      metrosCubicosEconomizadosMensal: metrosCubicosMensal,
      valorEconomizadoMensalReais: valorMensal,
      tipoDesperdicio: tipo,
      ocorrenciasPorDia: ocorrenciasPorDia,
      diasCalculados: diasPorMes,
    );
  }

  /// Calcula o custo por litro baseado em um consumo total
  static double calcularCustoPorLitro(double metrosCubicosMes) {
    double valorTotal = calcularValorConsumo(metrosCubicosMes);
    double litrosTotais = metrosCubicosMes * 1000;
    
    return valorTotal / litrosTotais;
  }

  /// Formata valor em reais para exibição
  static String formatarReais(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Formata litros para exibição
  static String formatarLitros(double litros) {
    if (litros >= 1000) {
      double m3 = litros / 1000;
      return '${m3.toStringAsFixed(2)} m³';
    }
    return '${litros.toStringAsFixed(1)} L';
  }
}

/// Classe auxiliar para representar uma faixa tarifária
class _FaixaTarifa {
  final double limiteInferior;
  final double limiteSuperior;
  final double valorPorM3;

  const _FaixaTarifa({
    required this.limiteInferior,
    required this.limiteSuperior,
    required this.valorPorM3,
  });
}

/// Resultado do cálculo de economia para uma detecção
class ResultadoEconomia {
  final double litrosEconomizados;
  final double metrosCubicosEconomizados;
  final double valorEconomizadoReais;
  final TipoDesperdicio tipoDesperdicio;
  final DateTime dataCalculo;

  ResultadoEconomia({
    required this.litrosEconomizados,
    required this.metrosCubicosEconomizados,
    required this.valorEconomizadoReais,
    required this.tipoDesperdicio,
    required this.dataCalculo,
  });

  String get descricaoEconomia {
    return 'Você economizaria ${CalculoEconomiaService.formatarLitros(litrosEconomizados)} '
        '(${CalculoEconomiaService.formatarReais(valorEconomizadoReais)})';
  }
}

/// Resultado do cálculo de economia mensal
class ResultadoEconomiaMensal {
  final double litrosEconomizadosMensal;
  final double metrosCubicosEconomizadosMensal;
  final double valorEconomizadoMensalReais;
  final TipoDesperdicio tipoDesperdicio;
  final int ocorrenciasPorDia;
  final int diasCalculados;

  ResultadoEconomiaMensal({
    required this.litrosEconomizadosMensal,
    required this.metrosCubicosEconomizadosMensal,
    required this.valorEconomizadoMensalReais,
    required this.tipoDesperdicio,
    required this.ocorrenciasPorDia,
    required this.diasCalculados,
  });

  String get descricaoEconomiaMensal {
    return 'Economia mensal estimada: ${CalculoEconomiaService.formatarLitros(litrosEconomizadosMensal)} '
        '(${CalculoEconomiaService.formatarReais(valorEconomizadoMensalReais)})';
  }

  String get descricaoDetalhada {
    return 'Se você corrigir este desperdício, economizará aproximadamente '
        '${CalculoEconomiaService.formatarLitros(litrosEconomizadosMensal)} de água por mês, '
        'o que representa ${CalculoEconomiaService.formatarReais(valorEconomizadoMensalReais)} '
        'na sua conta de água.';
  }

  double get economiaAnual => valorEconomizadoMensalReais * 12;
  
  String get descricaoEconomiaAnual {
    return 'Economia anual: ${CalculoEconomiaService.formatarReais(economiaAnual)}';
  }
}
