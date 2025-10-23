library exemplo_uso_economia;

import 'package:flutter/foundation.dart';

import '../models/desperdicio_agua.dart';
import '../services/calculo_economia_service.dart';

/// EXEMPLO 1: Detectar e calcular economia de um banho longo
void exemploDeteccaoBanhoLongo() {
  debugPrint('\n=== EXEMPLO 1: Banho Longo ===\n');
  
  // Criar detecção
  final deteccao = DeteccaoDesperdicio(
    tipo: TipoDesperdicio.banhoLongo,
    dataHora: DateTime.now(),
    observacao: 'Banho detectado com duração de 15 minutos',
  );
  
  // Calcular economia
  final economia = CalculoEconomiaService.calcularEconomiaDesperdicio(deteccao);
  
  debugPrint('📊 Detecção: ${deteccao.tipo.nome}');
  debugPrint('💧 Água desperdiçada: ${economia.litrosEconomizados} litros');
  debugPrint('💰 Valor desperdiçado: ${CalculoEconomiaService.formatarReais(economia.valorEconomizadoReais)}');
  debugPrint('');
  debugPrint('💡 Dica: ${deteccao.tipo.dicaEconomia}');
}

/// EXEMPLO 2: Calcular economia mensal de múltiplos desperdícios
void exemploEconomiaMensal() {
  debugPrint('\n=== EXEMPLO 2: Economia Mensal ===\n');
  
  // Simular detecções do dia
  final deteccoesHoje = [
    DeteccaoDesperdicio(tipo: TipoDesperdicio.banhoLongo, dataHora: DateTime.now()),
    DeteccaoDesperdicio(tipo: TipoDesperdicio.torneiraAberta, dataHora: DateTime.now()),
    DeteccaoDesperdicio(tipo: TipoDesperdicio.banhoLongo, dataHora: DateTime.now()),
  ];
  
  double totalLitros = 0;
  double totalReais = 0;
  
  for (var deteccao in deteccoesHoje) {
    final resultado = CalculoEconomiaService.calcularEconomiaDesperdicio(deteccao);
    totalLitros += resultado.litrosEconomizados;
    totalReais += resultado.valorEconomizadoReais;
  }
  
  debugPrint('📅 Desperdícios detectados hoje: ${deteccoesHoje.length}');
  debugPrint('💧 Total desperdiçado hoje: ${CalculoEconomiaService.formatarLitros(totalLitros)}');
  debugPrint('💰 Valor desperdiçado hoje: ${CalculoEconomiaService.formatarReais(totalReais)}');
  debugPrint('');
  
  // Projeção mensal
  double projecaoMensalLitros = totalLitros * 30;
  double projecaoMensalReais = totalReais * 30;
  
  debugPrint('📈 PROJEÇÃO MENSAL (se continuar assim):');
  debugPrint('💧 Desperdício mensal: ${CalculoEconomiaService.formatarLitros(projecaoMensalLitros)}');
  debugPrint('💰 Custo mensal: ${CalculoEconomiaService.formatarReais(projecaoMensalReais)}');
  debugPrint('💰 Custo anual: ${CalculoEconomiaService.formatarReais(projecaoMensalReais * 12)}');
}

/// EXEMPLO 3: Calcular impacto de corrigir um vazamento
void exemploCorrigirVazamento() {
  debugPrint('\n=== EXEMPLO 3: Corrigir Vazamento ===\n');
  
  final economiaMensal = CalculoEconomiaService.calcularEconomiaMensal(
    TipoDesperdicio.torneiraPingando,
    diasPorMes: 30,
    ocorrenciasPorDia: 1,
  );
  
  debugPrint('🔧 Situação: Torneira pingando constantemente');
  debugPrint('');
  debugPrint('💧 Desperdício por dia: ${TipoDesperdicio.torneiraPingando.consumoMedioLitros} litros');
  debugPrint('');
  debugPrint('📊 SE VOCÊ CONSERTAR:');
  debugPrint('  • Economia mensal: ${CalculoEconomiaService.formatarLitros(economiaMensal.litrosEconomizadosMensal)}');
  debugPrint('  • Economia em dinheiro/mês: ${CalculoEconomiaService.formatarReais(economiaMensal.valorEconomizadoMensalReais)}');
  debugPrint('  • Economia anual: ${CalculoEconomiaService.formatarReais(economiaMensal.economiaAnual)}');
  debugPrint('');
  debugPrint('💡 ${TipoDesperdicio.torneiraPingando.dicaEconomia}');
}

/// EXEMPLO 4: Comparar impacto de diferentes tipos de desperdício
void exemploComparacao() {
  debugPrint('\n=== EXEMPLO 4: Comparação de Desperdícios ===\n');
  
  final tipos = [
    TipoDesperdicio.banhoLongo,
    TipoDesperdicio.torneiraPingando,
    TipoDesperdicio.vazamentoNoturno,
  ];
  
  debugPrint('Comparando impacto anual de cada tipo de desperdício:\n');
  
  for (var tipo in tipos) {
    final mensal = CalculoEconomiaService.calcularEconomiaMensal(
      tipo,
      diasPorMes: 30,
      ocorrenciasPorDia: 1,
    );
    
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🚰 ${tipo.nome}');
    debugPrint('   Consumo/dia: ${tipo.consumoMedioLitros} L');
    debugPrint('   Custo anual: ${CalculoEconomiaService.formatarReais(mensal.economiaAnual)}');
    debugPrint('');
  }
}

/// EXEMPLO 5: Calcular economia de uma família
void exemploFamilia() {
  debugPrint('\n=== EXEMPLO 5: Família de 4 Pessoas ===\n');
  
  // Cenário: Família onde todos tomam banhos longos
  final mensalPorPessoa = CalculoEconomiaService.calcularEconomiaMensal(
    TipoDesperdicio.banhoLongo,
    diasPorMes: 30,
    ocorrenciasPorDia: 1,
  );
  
  final mensalFamilia = CalculoEconomiaService.calcularEconomiaMensal(
    TipoDesperdicio.banhoLongo,
    diasPorMes: 30,
    ocorrenciasPorDia: 4, // 4 pessoas
  );
  
  debugPrint('👨‍👩‍👧‍👦 Família de 4 pessoas');
  debugPrint('🚿 Todos tomam banhos de 15 minutos diariamente');
  debugPrint('');
  debugPrint('📊 ECONOMIA POR PESSOA:');
  debugPrint('  • Por mês: ${CalculoEconomiaService.formatarReais(mensalPorPessoa.valorEconomizadoMensalReais)}');
  debugPrint('  • Por ano: ${CalculoEconomiaService.formatarReais(mensalPorPessoa.economiaAnual)}');
  debugPrint('');
  debugPrint('📊 ECONOMIA TOTAL DA FAMÍLIA:');
  debugPrint('  • Água/mês: ${CalculoEconomiaService.formatarLitros(mensalFamilia.litrosEconomizadosMensal)}');
  debugPrint('  • Dinheiro/mês: ${CalculoEconomiaService.formatarReais(mensalFamilia.valorEconomizadoMensalReais)}');
  debugPrint('  • Dinheiro/ano: ${CalculoEconomiaService.formatarReais(mensalFamilia.economiaAnual)}');
  debugPrint('');
  debugPrint('💰 Se reduzirem os banhos para 5 minutos, a família economizará');
  debugPrint('   ${CalculoEconomiaService.formatarReais(mensalFamilia.economiaAnual)} por ano!');
}

/// EXEMPLO 6: Simular conta de água
void exemploSimularConta() {
  debugPrint('\n=== EXEMPLO 6: Simulador de Conta de Água ===\n');
  
  // Consumos diferentes em m³
  final consumos = [5.0, 10.0, 15.0, 20.0, 30.0];
  
  debugPrint('Simulação de conta de água (Tocantins - BRK Ambiental):\n');
  debugPrint('Consumo (m³) │ Consumo (L)  │ Valor Total');
  debugPrint('─────────────┼──────────────┼─────────────');
  
  for (var m3 in consumos) {
    final valor = CalculoEconomiaService.calcularValorConsumo(m3);
    final litros = (m3 * 1000).toInt();
    
    debugPrint('${m3.toString().padRight(12)} │ ${litros.toString().padRight(12)} │ ${CalculoEconomiaService.formatarReais(valor)}');
  }
  
  debugPrint('');
  debugPrint('ℹ️  Valores incluem água + esgoto (80%)');
  debugPrint('ℹ️  Consumo mínimo cobrado: 5 m³');
}

/// EXEMPLO 7: Calcular custo por litro em diferentes faixas
void exemploCustoPorLitro() {
  debugPrint('\n=== EXEMPLO 7: Custo por Litro ===\n');
  
  final consumos = [5.0, 10.0, 20.0, 30.0, 50.0];
  
  debugPrint('Como o custo por litro varia com o consumo:\n');
  debugPrint('Consumo │ Custo/Litro');
  debugPrint('────────┼────────────');
  
  for (var m3 in consumos) {
    final custoPorLitro = CalculoEconomiaService.calcularCustoPorLitro(m3);
    
    debugPrint('${m3.toStringAsFixed(0).padRight(7)} │ R\$ ${(custoPorLitro * 1000).toStringAsFixed(2)} por 1000L');
  }
  
  debugPrint('');
  debugPrint('💡 Quanto mais você consome, mais caro fica cada litro!');
  debugPrint('   Isso incentiva a economia de água.');
}

/// EXEMPLO 8: Detectar múltiplos tipos no mesmo dia
void exemploMultiplosAlertas() {
  debugPrint('\n=== EXEMPLO 8: Múltiplos Alertas em um Dia ===\n');
  
  // Simular detecções ao longo do dia
  final deteccoes = [
    DeteccaoDesperdicio(
      tipo: TipoDesperdicio.banhoLongo,
      dataHora: DateTime(2025, 10, 23, 7, 30),
      observacao: 'Banho da manhã - 15 minutos',
    ),
    DeteccaoDesperdicio(
      tipo: TipoDesperdicio.torneiraAberta,
      dataHora: DateTime(2025, 10, 23, 8, 15),
      observacao: 'Torneira aberta durante escovação',
    ),
    DeteccaoDesperdicio(
      tipo: TipoDesperdicio.vazamentoNoturno,
      dataHora: DateTime(2025, 10, 23, 2, 30),
      observacao: 'Som de água às 2:30 AM',
    ),
  ];
  
  debugPrint('📅 Detecções de 23/10/2025:\n');
  
  double totalLitros = 0;
  double totalReais = 0;
  
  for (var deteccao in deteccoes) {
    final economia = CalculoEconomiaService.calcularEconomiaDesperdicio(deteccao);
    totalLitros += economia.litrosEconomizados;
    totalReais += economia.valorEconomizadoReais;
    
    debugPrint('⏰ ${deteccao.dataHora.hour}:${deteccao.dataHora.minute.toString().padLeft(2, '0')}');
    debugPrint('   ${deteccao.tipo.nome}');
    debugPrint('   💧 ${economia.litrosEconomizados} L • 💰 ${CalculoEconomiaService.formatarReais(economia.valorEconomizadoReais)}');
    debugPrint('');
  }
  
  debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  debugPrint('📊 RESUMO DO DIA');
  debugPrint('   Total desperdiçado: ${CalculoEconomiaService.formatarLitros(totalLitros)}');
  debugPrint('   Custo total: ${CalculoEconomiaService.formatarReais(totalReais)}');
  debugPrint('');
  debugPrint('⚠️  Se corrigir esses desperdícios, você economizará');
  debugPrint('   ${CalculoEconomiaService.formatarReais(totalReais * 30)}/mês!');
}

/// Executar todos os exemplos
void main() {
  debugPrint('╔═══════════════════════════════════════════════════════════╗');
  debugPrint('║  SISTEMA DE CÁLCULO DE ECONOMIA DE ÁGUA - HACKÁGUA       ║');
  debugPrint('║  Tarifas BRK Ambiental - Tocantins (2025)                ║');
  debugPrint('╚═══════════════════════════════════════════════════════════╝');
  
  exemploDeteccaoBanhoLongo();
  exemploEconomiaMensal();
  exemploCorrigirVazamento();
  exemploComparacao();
  exemploFamilia();
  exemploSimularConta();
  exemploCustoPorLitro();
  exemploMultiplosAlertas();
  
  debugPrint('\n');
  debugPrint('═══════════════════════════════════════════════════════════');
  debugPrint('💡 Dica: Use esses cálculos no seu app para motivar');
  debugPrint('   os usuários a economizar água e dinheiro!');
  debugPrint('═══════════════════════════════════════════════════════════\n');
}
