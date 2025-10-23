// lib/examples/exemplo_uso_economia.dart

/// EXEMPLOS DE USO DO SISTEMA DE CÁLCULO DE ECONOMIA
/// 
/// Este arquivo contém exemplos práticos de como usar o sistema
/// de cálculo de economia de água no seu projeto.

import '../models/desperdicio_agua.dart';
import '../services/calculo_economia_service.dart';

/// EXEMPLO 1: Detectar e calcular economia de um banho longo
void exemploDeteccaoBanhoLongo() {
  print('\n=== EXEMPLO 1: Banho Longo ===\n');
  
  // Criar detecção
  final deteccao = DeteccaoDesperdicio(
    tipo: TipoDesperdicio.banhoLongo,
    dataHora: DateTime.now(),
    observacao: 'Banho detectado com duração de 15 minutos',
  );
  
  // Calcular economia
  final economia = CalculoEconomiaService.calcularEconomiaDesperdicio(deteccao);
  
  print('📊 Detecção: ${deteccao.tipo.nome}');
  print('💧 Água desperdiçada: ${economia.litrosEconomizados} litros');
  print('💰 Valor desperdiçado: ${CalculoEconomiaService.formatarReais(economia.valorEconomizadoReais)}');
  print('');
  print('💡 Dica: ${deteccao.tipo.dicaEconomia}');
}

/// EXEMPLO 2: Calcular economia mensal de múltiplos desperdícios
void exemploEconomiaMensal() {
  print('\n=== EXEMPLO 2: Economia Mensal ===\n');
  
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
  
  print('📅 Desperdícios detectados hoje: ${deteccoesHoje.length}');
  print('💧 Total desperdiçado hoje: ${CalculoEconomiaService.formatarLitros(totalLitros)}');
  print('💰 Valor desperdiçado hoje: ${CalculoEconomiaService.formatarReais(totalReais)}');
  print('');
  
  // Projeção mensal
  double projecaoMensalLitros = totalLitros * 30;
  double projecaoMensalReais = totalReais * 30;
  
  print('📈 PROJEÇÃO MENSAL (se continuar assim):');
  print('💧 Desperdício mensal: ${CalculoEconomiaService.formatarLitros(projecaoMensalLitros)}');
  print('💰 Custo mensal: ${CalculoEconomiaService.formatarReais(projecaoMensalReais)}');
  print('💰 Custo anual: ${CalculoEconomiaService.formatarReais(projecaoMensalReais * 12)}');
}

/// EXEMPLO 3: Calcular impacto de corrigir um vazamento
void exemploCorrigirVazamento() {
  print('\n=== EXEMPLO 3: Corrigir Vazamento ===\n');
  
  final economiaMensal = CalculoEconomiaService.calcularEconomiaMensal(
    TipoDesperdicio.torneiraPingando,
    diasPorMes: 30,
    ocorrenciasPorDia: 1,
  );
  
  print('🔧 Situação: Torneira pingando constantemente');
  print('');
  print('💧 Desperdício por dia: ${TipoDesperdicio.torneiraPingando.consumoMedioLitros} litros');
  print('');
  print('📊 SE VOCÊ CONSERTAR:');
  print('  • Economia mensal: ${CalculoEconomiaService.formatarLitros(economiaMensal.litrosEconomizadosMensal)}');
  print('  • Economia em dinheiro/mês: ${CalculoEconomiaService.formatarReais(economiaMensal.valorEconomizadoMensalReais)}');
  print('  • Economia anual: ${CalculoEconomiaService.formatarReais(economiaMensal.economiaAnual)}');
  print('');
  print('💡 ${TipoDesperdicio.torneiraPingando.dicaEconomia}');
}

/// EXEMPLO 4: Comparar impacto de diferentes tipos de desperdício
void exemploComparacao() {
  print('\n=== EXEMPLO 4: Comparação de Desperdícios ===\n');
  
  final tipos = [
    TipoDesperdicio.banhoLongo,
    TipoDesperdicio.torneiraPingando,
    TipoDesperdicio.vazamentoNoturno,
  ];
  
  print('Comparando impacto anual de cada tipo de desperdício:\n');
  
  for (var tipo in tipos) {
    final mensal = CalculoEconomiaService.calcularEconomiaMensal(
      tipo,
      diasPorMes: 30,
      ocorrenciasPorDia: 1,
    );
    
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🚰 ${tipo.nome}');
    print('   Consumo/dia: ${tipo.consumoMedioLitros} L');
    print('   Custo anual: ${CalculoEconomiaService.formatarReais(mensal.economiaAnual)}');
    print('');
  }
}

/// EXEMPLO 5: Calcular economia de uma família
void exemploFamilia() {
  print('\n=== EXEMPLO 5: Família de 4 Pessoas ===\n');
  
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
  
  print('👨‍👩‍👧‍👦 Família de 4 pessoas');
  print('🚿 Todos tomam banhos de 15 minutos diariamente');
  print('');
  print('📊 ECONOMIA POR PESSOA:');
  print('  • Por mês: ${CalculoEconomiaService.formatarReais(mensalPorPessoa.valorEconomizadoMensalReais)}');
  print('  • Por ano: ${CalculoEconomiaService.formatarReais(mensalPorPessoa.economiaAnual)}');
  print('');
  print('📊 ECONOMIA TOTAL DA FAMÍLIA:');
  print('  • Água/mês: ${CalculoEconomiaService.formatarLitros(mensalFamilia.litrosEconomizadosMensal)}');
  print('  • Dinheiro/mês: ${CalculoEconomiaService.formatarReais(mensalFamilia.valorEconomizadoMensalReais)}');
  print('  • Dinheiro/ano: ${CalculoEconomiaService.formatarReais(mensalFamilia.economiaAnual)}');
  print('');
  print('💰 Se reduzirem os banhos para 5 minutos, a família economizará');
  print('   ${CalculoEconomiaService.formatarReais(mensalFamilia.economiaAnual)} por ano!');
}

/// EXEMPLO 6: Simular conta de água
void exemploSimularConta() {
  print('\n=== EXEMPLO 6: Simulador de Conta de Água ===\n');
  
  // Consumos diferentes em m³
  final consumos = [5.0, 10.0, 15.0, 20.0, 30.0];
  
  print('Simulação de conta de água (Tocantins - BRK Ambiental):\n');
  print('Consumo (m³) │ Consumo (L)  │ Valor Total');
  print('─────────────┼──────────────┼─────────────');
  
  for (var m3 in consumos) {
    final valor = CalculoEconomiaService.calcularValorConsumo(m3);
    final litros = (m3 * 1000).toInt();
    
    print('${m3.toString().padRight(12)} │ ${litros.toString().padRight(12)} │ ${CalculoEconomiaService.formatarReais(valor)}');
  }
  
  print('');
  print('ℹ️  Valores incluem água + esgoto (80%)');
  print('ℹ️  Consumo mínimo cobrado: 5 m³');
}

/// EXEMPLO 7: Calcular custo por litro em diferentes faixas
void exemploCustoPorLitro() {
  print('\n=== EXEMPLO 7: Custo por Litro ===\n');
  
  final consumos = [5.0, 10.0, 20.0, 30.0, 50.0];
  
  print('Como o custo por litro varia com o consumo:\n');
  print('Consumo │ Custo/Litro');
  print('────────┼────────────');
  
  for (var m3 in consumos) {
    final custoPorLitro = CalculoEconomiaService.calcularCustoPorLitro(m3);
    
    print('${m3.toStringAsFixed(0).padRight(7)} │ R\$ ${(custoPorLitro * 1000).toStringAsFixed(2)} por 1000L');
  }
  
  print('');
  print('💡 Quanto mais você consome, mais caro fica cada litro!');
  print('   Isso incentiva a economia de água.');
}

/// EXEMPLO 8: Detectar múltiplos tipos no mesmo dia
void exemploMultiplosAlertas() {
  print('\n=== EXEMPLO 8: Múltiplos Alertas em um Dia ===\n');
  
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
  
  print('📅 Detecções de 23/10/2025:\n');
  
  double totalLitros = 0;
  double totalReais = 0;
  
  for (var deteccao in deteccoes) {
    final economia = CalculoEconomiaService.calcularEconomiaDesperdicio(deteccao);
    totalLitros += economia.litrosEconomizados;
    totalReais += economia.valorEconomizadoReais;
    
    print('⏰ ${deteccao.dataHora.hour}:${deteccao.dataHora.minute.toString().padLeft(2, '0')}');
    print('   ${deteccao.tipo.nome}');
    print('   💧 ${economia.litrosEconomizados} L • 💰 ${CalculoEconomiaService.formatarReais(economia.valorEconomizadoReais)}');
    print('');
  }
  
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('📊 RESUMO DO DIA');
  print('   Total desperdiçado: ${CalculoEconomiaService.formatarLitros(totalLitros)}');
  print('   Custo total: ${CalculoEconomiaService.formatarReais(totalReais)}');
  print('');
  print('⚠️  Se corrigir esses desperdícios, você economizará');
  print('   ${CalculoEconomiaService.formatarReais(totalReais * 30)}/mês!');
}

/// Executar todos os exemplos
void main() {
  print('╔═══════════════════════════════════════════════════════════╗');
  print('║  SISTEMA DE CÁLCULO DE ECONOMIA DE ÁGUA - HACKÁGUA       ║');
  print('║  Tarifas BRK Ambiental - Tocantins (2025)                ║');
  print('╚═══════════════════════════════════════════════════════════╝');
  
  exemploDeteccaoBanhoLongo();
  exemploEconomiaMensal();
  exemploCorrigirVazamento();
  exemploComparacao();
  exemploFamilia();
  exemploSimularConta();
  exemploCustoPorLitro();
  exemploMultiplosAlertas();
  
  print('\n');
  print('═══════════════════════════════════════════════════════════');
  print('💡 Dica: Use esses cálculos no seu app para motivar');
  print('   os usuários a economizar água e dinheiro!');
  print('═══════════════════════════════════════════════════════════\n');
}
