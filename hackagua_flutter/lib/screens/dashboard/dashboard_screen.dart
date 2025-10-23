import 'package:flutter/material.dart';
import 'package:hackagua_flutter/widgets/dashboard/alertas_recentes_card.dart';
import 'package:hackagua_flutter/widgets/dashboard/economia_potencial_card.dart';
import 'package:hackagua_flutter/widgets/dashboard/estatisticas_card.dart';
import 'package:hackagua_flutter/widgets/dashboard/grafico_semanal_card.dart';
import 'package:hackagua_flutter/widgets/dashboard/meta_diaria_card.dart';

import '../../models/desperdicio_agua.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dados simulados - substitua pela integração com sua API
  final double consumoHoje = 45.0; // litros
  final double metaDiaria = 150.0; // litros
  final List<double> consumoSemanal = [
    120,
    135,
    98,
    145,
    132,
    118,
    45,
  ]; // litros por dia

  final List<DeteccaoDesperdicio> deteccoesRecentes = [
    DeteccaoDesperdicio(
      tipo: TipoDesperdicio.banhoLongo,
      dataHora: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    DeteccaoDesperdicio(
      tipo: TipoDesperdicio.vazamentoNoturno,
      dataHora: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double percentualMeta = (consumoHoje / metaDiaria * 100)
        .clamp(0, 100)
        .toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _atualizarDados,
          child: CustomScrollView(
            slivers: [
              // AppBar customizado
              _buildSliverAppBar(),

              // Conteúdo do dashboard
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Resumo do consumo de hoje
                    ConsumoHojeCard(
                      consumoLitros: consumoHoje,
                      metaLitros: metaDiaria,
                      percentual: percentualMeta,
                    ),

                    const SizedBox(height: 16),

                    // Meta diária
                    MetaDiariaCard(
                      consumoAtual: consumoHoje,
                      metaDiaria: metaDiaria,
                    ),

                    const SizedBox(height: 16),

                    // Gráfico semanal
                    GraficoSemanalCard(
                      dadosSemanal: consumoSemanal,
                      metaDiaria: metaDiaria,
                    ),

                    const SizedBox(height: 16),

                    // Cards lado a lado
                    Row(
                      children: [
                        // Estatísticas
                        Expanded(
                          child: EstatisticasCard(
                            titulo: "Média Semanal",
                            valor:
                                "${_calcularMedia(consumoSemanal).toStringAsFixed(0)} L",
                            icone: Icons.timeline,
                            cor: Colors.blue,
                            tendencia: -5.2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Economia
                        Expanded(
                          child: EstatisticasCard(
                            titulo: "Economia/Mês",
                            valor: "R\$ 24,50",
                            icone: Icons.trending_down,
                            cor: Colors.green,
                            tendencia: 12.3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Economia potencial
                    if (deteccoesRecentes.isNotEmpty)
                      EconomiaPotencialCard(deteccoes: deteccoesRecentes),

                    const SizedBox(height: 16),

                    // Alertas recentes
                    AlertasRecentesCard(
                      deteccoes: deteccoesRecentes,
                      onVerTodos: () {
                        // Navegar para tela de alertas
                      },
                    ),

                    const SizedBox(height: 24),

                    // Dicas de economia
                    _buildDicasCard(),

                    const SizedBox(height: 100), // Espaço para bottom nav
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final now = DateTime.now();
    final saudacao = _getSaudacao();

    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    saudacao,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // Abrir notificações
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDicasCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[400]!, Colors.green[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.eco, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Dica do Dia',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Reduza seu banho para 5 minutos e economize até 90 litros de água por dia. Use um timer ou playlist de 5 minutos como guia!',
            style: TextStyle(fontSize: 15, color: Colors.white, height: 1.5),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Ver mais dicas
              },
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Ver mais dicas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSaudacao() {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Bom dia';
    if (hora < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  double _calcularMedia(List<double> valores) {
    if (valores.isEmpty) return 0;
    return valores.reduce((a, b) => a + b) / valores.length;
  }

  Future<void> _atualizarDados() async {
    // Simular carregamento
    await Future.delayed(const Duration(seconds: 1));

    // Aqui você faria a chamada à API
    setState(() {
      // Atualizar dados
    });
  }
}

class ConsumoHojeCard extends StatelessWidget {
  final double consumoLitros;
  final double metaLitros;
  final double percentual;

  const ConsumoHojeCard({
    Key? key,
    required this.consumoLitros,
    required this.metaLitros,
    required this.percentual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Consumo hoje',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${consumoLitros.toStringAsFixed(1)} L',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Meta: ${metaLitros.toStringAsFixed(0)} L',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: (percentual / 100).clamp(0.0, 1.0),
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  Center(
                    child: Text(
                      '${percentual.toStringAsFixed(0)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
