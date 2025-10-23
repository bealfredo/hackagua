import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hackagua_flutter/models/enums.dart';
import 'package:hackagua_flutter/services/detection_service.dart';
import 'package:hackagua_flutter/services/api_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DetectionService? _detectionService;
  final ApiService _apiService = ApiService();
  String _statusMessage = "Iniciando...";
  TipoEvento? _lastEvent;
  double _lastDuration = 0.0;
  bool _apiConnected = false;
  bool _trainingNoise = false;
  StreamSubscription<bool>? _noiseSub;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _checkApiConnection();
  }

  Future<void> _checkApiConnection() async {
    final isConnected = await _apiService.testConnection();
    if (mounted) {
      setState(() {
        _apiConnected = isConnected;
      });
    }
  }

  Future<void> _initializeService() async {
    try {
      _detectionService = DetectionService();
      // Ouve mudanças no status de ruído para treino
      _noiseSub?.cancel();
      _noiseSub = _detectionService!.trainingNoise$.listen((flag) {
        if (!mounted) return;
        setState(() {
          _trainingNoise = flag;
        });
      });
      // Aguarda um pouco para garantir que o serviço está pronto
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _startDetection();
      }
    } catch (e) {
      print("Erro ao inicializar serviço: $e");
      if (mounted) {
        setState(() {
          _statusMessage = "Erro ao iniciar";
        });
      }
    }
  }

  void _startDetection() {
    if (_detectionService == null) return;
    
    setState(() {
      _statusMessage = "Monitorando...";
    });
    _detectionService!.startRecording(
      onEvent: (tipo, duracao) {
        setState(() {
          _lastEvent = tipo;
          _lastDuration = duracao;
          _statusMessage = "Evento detectado!";
        });
      },
    );
  }

  @override
  void dispose() {
    _noiseSub?.cancel();
    _detectionService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... (o resto do build method continua abaixo)
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildStatusIndicator(),
              const SizedBox(height: 24),
              _buildSimularBanhoCard(),
              const SizedBox(height: 24),
              _buildConsumoDiarioCard(),
              if (_lastEvent != null) ...[
                const SizedBox(height: 24),
                _buildAlertasRecentesCard(context),
              ],
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final formattedDate = DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/logo.png', height: 50),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      "EscutaD'Agua",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                formattedDate,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: _apiConnected ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _apiConnected ? 'API Conectada' : 'API Desconectada',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  _trainingNoise ? const SizedBox(width: 12) : const SizedBox.shrink(),
                  _buildTrainingNoiseTag(),
                ],
              ),
            ],
          ),
        ),
        // O indicador de status foi removido daqui
      ],
    );
  }

  Widget _buildTrainingNoiseTag() {
    if (!_trainingNoise) return const SizedBox.shrink();
    final Color bg = const Color(0xFFFFF3E0);
    final Color fg = const Color(0xFFEF6C00);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.hearing, size: 14, color: Color(0xFFEF6C00)),
          SizedBox(width: 6),
          Text(
            'Ruído detectado',
            style: TextStyle(color: Color(0xFFEF6C00), fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_circle_outline, color: Color(0xFF2E7D32)),
          SizedBox(width: 8),
          Text(
            _statusMessage, // Usa a mensagem de status
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimularBanhoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shower_outlined),
              SizedBox(width: 8),
              Text(
                'Simular banho',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsumoDiarioCard() {
    return Card(
      elevation: 0,
      color: const Color(0xFFF0F4F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.show_chart, color: Colors.green[600]),
                    const SizedBox(width: 8),
                    const Text(
                      'Hoje',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '0 min',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Meta diária: 30 minutos',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.0,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '0% da meta alcançada',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertasRecentesCard(BuildContext context) {
    // Mostra o último evento detectado ou um placeholder
    final hasEvent = _lastEvent != null;
    String title = hasEvent
        ? "Último Evento Detectado"
        : "Nenhum alerta recente";
    String subtitle = hasEvent
        ? 'Tipo: ${_lastEvent!.toString().split('.').last}, Duração: ${_lastDuration.toStringAsFixed(1)}s'
        : 'O sistema está monitorando o consumo de água.';

    return Card(
      elevation: 0,
      color: const Color(0xFFF0F4F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'Alertas recentes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Navegar para a tela de todos os alertas
                  },
                  child: const Text('Ver todos >'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // Título dinâmico
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle, // Subtítulo dinâmico
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 0,
            color: const Color(0xFFF0F4F8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                // Para a detecção e reinicia
                _detectionService?.dispose();
                _initializeService();
              },
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Icon(Icons.mic),
                    SizedBox(height: 8),
                    Text('Iniciar Detecção'),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            elevation: 0,
            color: const Color(0xFFF0F4F8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Icon(Icons.history_outlined),
                    SizedBox(height: 8),
                    Text('Ver histórico'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
