// lib/models/desperdicio_agua.dart

/// Enum que define os tipos de desperdício que o widget espera.
/// A propriedade 'nome' é usada no seu widget _buildDeteccoesSummary.
enum TipoDesperdicio {
  TORNEIRA_ABERTA(nome: "Torneira aberta", dicaEconomia: "Feche a torneira ao escovar os dentes ou ensaboar a louça. Economize até 12 litros por minuto!"),
  torneiraAberta(nome: "Torneira aberta", dicaEconomia: "Feche a torneira ao escovar os dentes ou ensaboar a louça. Economize até 12 litros por minuto!"),
  BANHO_LONGO(nome: "Banho longo", dicaEconomia: "Reduza seu banho para 5 minutos. Use um cronômetro ou playlist para ajudar. Economize até 90 litros por banho!"),
  banhoLongo(nome: "Banho longo", dicaEconomia: "Reduza seu banho para 5 minutos. Use um cronômetro ou playlist para ajudar. Economize até 90 litros por banho!"),
  VAZAMENTO(nome: "Vazamento", dicaEconomia: "Conserte vazamentos imediatamente. Uma torneira pingando pode desperdiçar 46 litros por dia!"),
  vazamentoNoturno(nome: "Vazamento noturno", dicaEconomia: "Verifique todos os registros e encanamentos à noite. Vazamentos noturnos podem indicar problemas sérios."),
  torneiraPingando(nome: "Torneira pingando", dicaEconomia: "Troque a borracha ou arruela da torneira. Uma gota por segundo = 46 litros desperdiçados por dia!"),
  DESCARGA(nome: "Descarga", dicaEconomia: "Use descargas com duplo acionamento (3L/6L) e não use o vaso sanitário como lixeira."),
  DETECCAO_NOTURNA(nome: "Detecção Noturna", dicaEconomia: "Água correndo à noite pode indicar vazamento. Verifique torneiras, vasos sanitários e caixa d'água.");

  final String nome;
  final String dicaEconomia;
  const TipoDesperdicio({required this.nome, required this.dicaEconomia});
}

/// Classe que representa um único evento de desperdício detectado.
/// O widget usa 'deteccao.tipo'. O serviço de cálculo
/// provavelmente usa os outros campos.
class DeteccaoDesperdicio {
  final String? id;
  final TipoDesperdicio tipo;
  final double duracaoSegundos;
  final double gastoLitros;
  final DateTime data;
  
  // Getter para compatibilidade com código legado
  DateTime get dataHora => data;
  
  // Getter para cálculo de litros desperdiçados
  double get litrosDesperdicados => gastoLitros;

  DeteccaoDesperdicio({
    this.id,
    required this.tipo,
    required this.duracaoSegundos,
    required this.gastoLitros,
    required this.data,
  });
}
