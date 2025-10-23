// lib/examples/exemplo_dashboard.dart

/// EXEMPLO DE USO DO DASHBOARD
/// 
/// Este arquivo demonstra como usar o Dashboard Screen
/// em diferentes cenários.

import 'package:flutter/material.dart';
import '../models/desperdicio_agua.dart';
import '../screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const ExemploDashboardApp());
}

class ExemploDashboardApp extends StatelessWidget {
  const ExemploDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard HackÁgua',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MenuExemplos(),
    );
  }
}

class MenuExemplos extends StatelessWidget {
  const MenuExemplos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplos de Dashboard'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExemploCard(
            context,
            'Dashboard Completo',
            'Dashboard com todos os componentes e dados simulados',
            Icons.dashboard,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardScreen(),
              ),
            ),
          ),
          _buildExemploCard(
            context,
            'Usuário Econômico',
            'Simulação de usuário que economiza água',
            Icons.eco,
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardUsuarioEconomico(),
              ),
            ),
          ),
          _buildExemploCard(
            context,
            'Usuário com Desperdícios',
            'Simulação de usuário com vários desperdícios',
            Icons.warning_amber,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardComDesperdicios(),
              ),
            ),
          ),
          _buildExemploCard(
            context,
            'Meta Excedida',
            'Simulação de usuário que excedeu a meta',
            Icons.trending_up,
            Colors.red,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardMetaExcedida(),
              ),
            ),
          ),
          _buildExemploCard(
            context,
            'Sem Dados',
            'Dashboard para novo usuário sem histórico',
            Icons.fiber_new,
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardSemDados(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExemploCard(
    BuildContext context,
    String titulo,
    String descricao,
    IconData icone,
    MaterialColor cor,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cor[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icone, color: cor[700], size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descricao,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

// EXEMPLO 1: Usuário Econômico
class DashboardUsuarioEconomico extends StatelessWidget {
  const DashboardUsuarioEconomico({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dados de um usuário que economiza bem
    return const DashboardScreen(
      // Consumo baixo - apenas 30% da meta
      // consumoHoje: 45.0,
      // metaDiaria: 150.0,
      // consumoSemanal: [52, 48, 55, 50, 47, 51, 45],
      // deteccoesRecentes: [], // Nenhum desperdício!
    );
  }
}

// EXEMPLO 2: Usuário com Desperdícios
class DashboardComDesperdicios extends StatelessWidget {
  const DashboardComDesperdicios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usuário com vários desperdícios detectados - exemplo comentado para referência
    // final deteccoes = [
    //   DeteccaoDesperdicio(
    //     tipo: TipoDesperdicio.banhoLongo,
    //     dataHora: DateTime.now().subtract(const Duration(hours: 1)),
    //     observacao: 'Banho de 18 minutos',
    //   ),
    //   DeteccaoDesperdicio(
    //     tipo: TipoDesperdicio.torneiraPingando,
    //     dataHora: DateTime.now().subtract(const Duration(hours: 5)),
    //     observacao: 'Torneira da cozinha',
    //   ),
    //   DeteccaoDesperdicio(
    //     tipo: TipoDesperdicio.vazamentoNoturno,
    //     dataHora: DateTime.now().subtract(const Duration(hours: 10)),
    //     observacao: 'Detectado às 3:00 AM',
    //   ),
    //   DeteccaoDesperdicio(
    //     tipo: TipoDesperdicio.torneiraAberta,
    //     dataHora: DateTime.now().subtract(const Duration(hours: 12)),
    //     observacao: 'Durante escovação',
    //   ),
    // ];

    return const DashboardScreen(
      // consumoHoje: 180.0, // 120% da meta
      // metaDiaria: 150.0,
      // consumoSemanal: [145, 168, 172, 155, 163, 175, 180],
      // deteccoesRecentes: deteccoes,
    );
  }
}

// EXEMPLO 3: Meta Excedida
class DashboardMetaExcedida extends StatelessWidget {
  const DashboardMetaExcedida({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen(
      // consumoHoje: 195.0, // 130% da meta!
      // metaDiaria: 150.0,
      // consumoSemanal: [160, 175, 182, 190, 188, 193, 195],
      // deteccoesRecentes: [
      //   DeteccaoDesperdicio(
      //     tipo: TipoDesperdicio.banhoLongo,
      //     dataHora: DateTime.now(),
      //   ),
      // ],
    );
  }
}

// EXEMPLO 4: Sem Dados (Novo Usuário)
class DashboardSemDados extends StatelessWidget {
  const DashboardSemDados({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.water_drop_outlined,
                    size: 80,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Bem-vindo ao HackÁgua!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Comece a usar para ver seu consumo de água e receber dicas de economia.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    // Iniciar configuração
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Configurar agora'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// EXEMPLO 5: Dashboard com Integração de API
class DashboardComAPI extends StatefulWidget {
  const DashboardComAPI({Key? key}) : super(key: key);

  @override
  State<DashboardComAPI> createState() => _DashboardComAPIState();
}

class _DashboardComAPIState extends State<DashboardComAPI> {
  bool isLoading = true;
  Map<String, dynamic>? dadosDashboard;
  String? erro;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      isLoading = true;
      erro = null;
    });

    try {
      // Simular chamada à API
      await Future.delayed(const Duration(seconds: 2));

      // Em produção, você faria:
      // final response = await http.get(Uri.parse('$baseUrlApi/api/dashboard'));
      // final dados = json.decode(response.body);

      setState(() {
        dadosDashboard = {
          'consumoHoje': 75.0,
          'metaDiaria': 150.0,
          'consumoSemanal': [120, 135, 98, 145, 132, 118, 75],
          'mediaSemanal': 117.5,
          'economiaMensal': 32.40,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        erro = 'Erro ao carregar dados: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Carregando dashboard...'),
            ],
          ),
        ),
      );
    }

    if (erro != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Ops! Algo deu errado',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  erro!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _carregarDados,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Renderizar dashboard com dados da API
    return const DashboardScreen(
      // Passar dadosDashboard como parâmetros
    );
  }
}
