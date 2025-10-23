// lib/models/desperdicio_agua.dart

/// Representa os tipos de desperdício de água detectados
enum TipoDesperdicio {
  banhoLongo,
  torneiraPingando,
  vazamentoNoturno,
  descargaDemorada,
  torneiraAberta,
  chuveiroPingando,
}

/// Extensão para obter dados de cada tipo de desperdício
extension TipoDesperdicioExtension on TipoDesperdicio {
  /// Nome amigável do tipo de desperdício
  String get nome {
    switch (this) {
      case TipoDesperdicio.banhoLongo:
        return "Banho longo";
      case TipoDesperdicio.torneiraPingando:
        return "Torneira pingando";
      case TipoDesperdicio.vazamentoNoturno:
        return "Vazamento noturno";
      case TipoDesperdicio.descargaDemorada:
        return "Descarga demorada";
      case TipoDesperdicio.torneiraAberta:
        return "Torneira aberta";
      case TipoDesperdicio.chuveiroPingando:
        return "Chuveiro pingando";
    }
  }

  /// Consumo médio em litros por ocorrência
  double get consumoMedioLitros {
    switch (this) {
      case TipoDesperdicio.banhoLongo:
        return 90.0; // Diferença entre 15min (135L) e 5min (45L)
      case TipoDesperdicio.torneiraPingando:
        return 46.0; // Aproximadamente 46L por dia
      case TipoDesperdicio.vazamentoNoturno:
        return 200.0; // Estimativa de vazamento durante a noite
      case TipoDesperdicio.descargaDemorada:
        return 6.0; // Diferença entre descarga normal e demorada
      case TipoDesperdicio.torneiraAberta:
        return 12.0; // Torneira aberta durante escovação
      case TipoDesperdicio.chuveiroPingando:
        return 30.0; // Chuveiro pingando por hora
    }
  }

  /// Descrição de como economizar
  String get dicaEconomia {
    switch (this) {
      case TipoDesperdicio.banhoLongo:
        return "Reduza seu banho para 5 minutos. Use um timer ou playlist de 5 minutos como guia.";
      case TipoDesperdicio.torneiraPingando:
        return "Conserte o vazamento. Uma torneira pingando pode desperdiçar até 46L por dia.";
      case TipoDesperdicio.vazamentoNoturno:
        return "Verifique tubulações e registros. Vazamentos noturnos indicam problemas sérios.";
      case TipoDesperdicio.descargaDemorada:
        return "Verifique a válvula da descarga. Considere instalar uma com duplo acionamento (3/6L).";
      case TipoDesperdicio.torneiraAberta:
        return "Feche a torneira enquanto escova os dentes ou ensaboa as mãos.";
      case TipoDesperdicio.chuveiroPingando:
        return "Troque a borracha do chuveiro ou o registro. Pingos constantes desperdiçam muito.";
    }
  }
}

/// Representa uma detecção de desperdício com cálculo de economia
class DeteccaoDesperdicio {
  final TipoDesperdicio tipo;
  final DateTime dataHora;
  final double litrosDesperdicados;
  final String? observacao;

  DeteccaoDesperdicio({
    required this.tipo,
    required this.dataHora,
    double? litrosDesperdicados,
    this.observacao,
  }) : litrosDesperdicados = litrosDesperdicados ?? tipo.consumoMedioLitros;

  /// Calcula a economia em metros cúbicos
  double get metrosCubicosDesperdicados => litrosDesperdicados / 1000;
}
