// test/calculo_economia_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hackagua_flutter/models/desperdicio_agua.dart';
import 'package:hackagua_flutter/services/calculo_economia_service.dart';

void main() {
  group('CalculoEconomiaService', () {
    test('Calcula valor correto para consumo na primeira faixa', () {
      // Consumo de 5 m³ deve usar tarifa de R$ 4,97/m³
      // Mas como o mínimo é 5 m³, será cobrado 5 m³
      double valor = CalculoEconomiaService.calcularValorConsumo(5.0);
      
      // 5 m³ × R$ 4,97 = R$ 24,85 (água)
      // R$ 24,85 × 0,80 = R$ 19,88 (esgoto)
      // Total = R$ 44,73
      expect(valor, closeTo(44.73, 0.01));
    });

    test('Calcula valor correto para consumo abaixo do mínimo', () {
      // Consumo de 3 m³ deve cobrar 5 m³ (mínimo)
      double valor1 = CalculoEconomiaService.calcularValorConsumo(3.0);
      double valor2 = CalculoEconomiaService.calcularValorConsumo(5.0);
      
      expect(valor1, equals(valor2));
    });

    test('Calcula valor correto para consumo em múltiplas faixas', () {
      // Consumo de 13 m³
      // Primeiros 10 m³: 10 × 4,97 = R$ 49,70
      // Próximos 3 m³: 3 × 9,49 = R$ 28,47
      // Total água: R$ 78,17
      // Esgoto (80%): R$ 62,54
      // Total: R$ 140,71
      double valor = CalculoEconomiaService.calcularValorConsumo(13.0);
      
      expect(valor, closeTo(140.71, 0.01));
    });

    test('Calcula economia correta em reais baseado em litros', () {
      // 90 litros = 0,09 m³
      double economia = CalculoEconomiaService.calcularEconomiaReais(90.0);
      
      // 0,09 × 4,97 = R$ 0,4473 (água)
      // 0,4473 × 0,80 = R$ 0,3578 (esgoto)
      // Total = R$ 0,8051 ≈ R$ 0,81
      expect(economia, closeTo(0.81, 0.01));
    });

    test('Formata reais corretamente', () {
      expect(
        CalculoEconomiaService.formatarReais(123.45),
        equals('R\$ 123,45'),
      );
      expect(
        CalculoEconomiaService.formatarReais(1.5),
        equals('R\$ 1,50'),
      );
      expect(
        CalculoEconomiaService.formatarReais(1000.99),
        equals('R\$ 1000,99'),
      );
    });

    test('Formata litros corretamente', () {
      expect(
        CalculoEconomiaService.formatarLitros(500),
        equals('500.0 L'),
      );
      expect(
        CalculoEconomiaService.formatarLitros(1500),
        equals('1.50 m³'),
      );
      expect(
        CalculoEconomiaService.formatarLitros(2700),
        equals('2.70 m³'),
      );
    });

    test('Calcula custo por litro corretamente', () {
      // Para 13 m³ (13.000 litros) = R$ 140,71
      double custoPorLitro = CalculoEconomiaService.calcularCustoPorLitro(13.0);
      
      // R$ 140,71 ÷ 13.000 = R$ 0,01082 por litro
      expect(custoPorLitro, closeTo(0.01082, 0.00001));
    });
  });

  group('DeteccaoDesperdicio', () {
    test('Usa consumo médio padrão quando não especificado', () {
      final deteccao = DeteccaoDesperdicio(
        tipo: TipoDesperdicio.banhoLongo,
        dataHora: DateTime.now(),
      );
      
      expect(deteccao.litrosDesperdicados, equals(90.0));
    });

    test('Usa consumo customizado quando especificado', () {
      final deteccao = DeteccaoDesperdicio(
        tipo: TipoDesperdicio.banhoLongo,
        dataHora: DateTime.now(),
        litrosDesperdicados: 120.0,
      );
      
      expect(deteccao.litrosDesperdicados, equals(120.0));
    });

    test('Converte corretamente para metros cúbicos', () {
      final deteccao = DeteccaoDesperdicio(
        tipo: TipoDesperdicio.banhoLongo,
        dataHora: DateTime.now(),
        litrosDesperdicados: 2700.0,
      );
      
      expect(deteccao.metrosCubicosDesperdicados, equals(2.7));
    });
  });

  group('ResultadoEconomia', () {
    test('Calcula economia correta para banho longo', () {
      final deteccao = DeteccaoDesperdicio(
        tipo: TipoDesperdicio.banhoLongo,
        dataHora: DateTime.now(),
      );
      
      final resultado = CalculoEconomiaService.calcularEconomiaDesperdicio(deteccao);
      
      expect(resultado.litrosEconomizados, equals(90.0));
      expect(resultado.metrosCubicosEconomizados, equals(0.09));
      expect(resultado.valorEconomizadoReais, greaterThan(0));
    });

    test('Gera descrição de economia correta', () {
      final deteccao = DeteccaoDesperdicio(
        tipo: TipoDesperdicio.banhoLongo,
        dataHora: DateTime.now(),
      );
      
      final resultado = CalculoEconomiaService.calcularEconomiaDesperdicio(deteccao);
      
      expect(resultado.descricaoEconomia, contains('economizaria'));
      expect(resultado.descricaoEconomia, contains('L'));
      expect(resultado.descricaoEconomia, contains('R\$'));
    });
  });

  group('ResultadoEconomiaMensal', () {
    test('Calcula economia mensal correta', () {
      final mensal = CalculoEconomiaService.calcularEconomiaMensal(
        TipoDesperdicio.banhoLongo,
        diasPorMes: 30,
        ocorrenciasPorDia: 1,
      );
      
      // 90 L/dia × 30 dias = 2.700 L
      expect(mensal.litrosEconomizadosMensal, equals(2700.0));
      expect(mensal.metrosCubicosEconomizadosMensal, equals(2.7));
      expect(mensal.valorEconomizadoMensalReais, greaterThan(0));
    });

    test('Calcula economia anual correta', () {
      final mensal = CalculoEconomiaService.calcularEconomiaMensal(
        TipoDesperdicio.banhoLongo,
        diasPorMes: 30,
        ocorrenciasPorDia: 1,
      );
      
      expect(
        mensal.economiaAnual,
        equals(mensal.valorEconomizadoMensalReais * 12),
      );
    });

    test('Considera múltiplas ocorrências por dia', () {
      final mensal1 = CalculoEconomiaService.calcularEconomiaMensal(
        TipoDesperdicio.banhoLongo,
        diasPorMes: 30,
        ocorrenciasPorDia: 1,
      );
      
      final mensal2 = CalculoEconomiaService.calcularEconomiaMensal(
        TipoDesperdicio.banhoLongo,
        diasPorMes: 30,
        ocorrenciasPorDia: 2,
      );
      
      // Com 2 ocorrências, deve ser aproximadamente o dobro
      expect(
        mensal2.litrosEconomizadosMensal,
        equals(mensal1.litrosEconomizadosMensal * 2),
      );
    });

    test('Gera descrições detalhadas corretas', () {
      final mensal = CalculoEconomiaService.calcularEconomiaMensal(
        TipoDesperdicio.banhoLongo,
        diasPorMes: 30,
        ocorrenciasPorDia: 1,
      );
      
      expect(mensal.descricaoEconomiaMensal, contains('Economia mensal estimada'));
      expect(mensal.descricaoDetalhada, contains('corrigir este desperdício'));
      expect(mensal.descricaoEconomiaAnual, contains('Economia anual'));
    });
  });

  group('TipoDesperdicio', () {
    test('Cada tipo tem consumo médio definido', () {
      for (var tipo in TipoDesperdicio.values) {
        expect(tipo.consumoMedioLitros, greaterThan(0));
      }
    });

    test('Cada tipo tem nome definido', () {
      for (var tipo in TipoDesperdicio.values) {
        expect(tipo.nome, isNotEmpty);
      }
    });

    test('Cada tipo tem dica de economia definida', () {
      for (var tipo in TipoDesperdicio.values) {
        expect(tipo.dicaEconomia, isNotEmpty);
      }
    });

    test('Banho longo tem valores esperados', () {
      expect(TipoDesperdicio.banhoLongo.nome, equals('Banho longo'));
      expect(TipoDesperdicio.banhoLongo.consumoMedioLitros, equals(90.0));
      expect(
        TipoDesperdicio.banhoLongo.dicaEconomia,
        contains('5 minutos'),
      );
    });

    test('Torneira pingando tem valores esperados', () {
      expect(TipoDesperdicio.torneiraPingando.nome, equals('Torneira pingando'));
      expect(TipoDesperdicio.torneiraPingando.consumoMedioLitros, equals(46.0));
      expect(
        TipoDesperdicio.torneiraPingando.dicaEconomia,
        contains('Conserte'),
      );
    });
  });

  group('Cenários reais', () {
    test('Economia real: corrigir banho longo por um ano', () {
      // Usuário toma banho longo todos os dias por um ano
      final mensal = CalculoEconomiaService.calcularEconomiaMensal(
        TipoDesperdicio.banhoLongo,
        diasPorMes: 30,
        ocorrenciasPorDia: 1,
      );
      
      double economiaAnual = mensal.economiaAnual;
      
      // Deve economizar uma quantia significativa
      expect(economiaAnual, greaterThan(200)); // Mais de R$ 200/ano
      print('Economia anual banho longo: R\$ ${economiaAnual.toStringAsFixed(2)}');
    });

    test('Economia real: consertar torneira pingando', () {
      // Torneira pinga 24/7 por um mês
      final mensal = CalculoEconomiaService.calcularEconomiaMensal(
        TipoDesperdicio.torneiraPingando,
        diasPorMes: 30,
        ocorrenciasPorDia: 1,
      );
      
      // 46 L/dia × 30 = 1.380 L/mês
      expect(mensal.litrosEconomizadosMensal, equals(1380.0));
      print('Economia mensal torneira: R\$ ${mensal.valorEconomizadoMensalReais.toStringAsFixed(2)}');
    });

    test('Economia real: família de 4 pessoas com múltiplos banhos longos', () {
      // 4 pessoas, cada uma toma 1 banho longo por dia
      final mensal = CalculoEconomiaService.calcularEconomiaMensal(
        TipoDesperdicio.banhoLongo,
        diasPorMes: 30,
        ocorrenciasPorDia: 4,
      );
      
      // 90 L × 4 pessoas × 30 dias = 10.800 L
      expect(mensal.litrosEconomizadosMensal, equals(10800.0));
      print('Economia família (4 pessoas): R\$ ${mensal.economiaAnual.toStringAsFixed(2)}/ano');
    });
  });
}
