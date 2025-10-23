import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hackagua_flutter/services/audio_inference_service.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:wav/wav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCapturing = false;
  bool _isProcessing = false; // Novo estado para indicar processamento
  late AudioInferenceService _audioInferenceService;
  late AudioRecorder _audioRecorder;

  @override
  void initState() {
    super.initState();
    _audioInferenceService = AudioInferenceService();
    _audioRecorder = AudioRecorder();
    // Inicializa o serviço de inferência
    _initAudioService();
  }
  
  Future<void> _initAudioService() async {
    // O serviço será inicializado quando necessário
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _toggleCapture() async {
    if (_isCapturing || _isProcessing) {
      // Se já está capturando ou processando, não faz nada
      return;
    }

    // 1. Verifica permissão
    if (!await _audioRecorder.hasPermission()) {
      _showErrorDialog("Permissão para usar o microfone foi negada.");
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    // 2. Define o caminho do arquivo temporário
    final Directory tempDir = await getTemporaryDirectory();
    final String path = '${tempDir.path}/recording.wav';

    // 3. Começa a gravar
    try {
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: path,
      );

      // 4. Grava por 5 segundos
      await Future.delayed(const Duration(seconds: 5));
    } catch (e) {
      _showErrorDialog("Não foi possível iniciar a gravação: ${e.toString()}");
      setState(() {
        _isCapturing = false;
      });
      return;
    } finally {
      if (await _audioRecorder.isRecording()) {
        // 5. Para a gravação
        await _audioRecorder.stop();
      }
    }

    setState(() {
      _isCapturing = false;
      _isProcessing = true; // Inicia o processamento
    });

    // 6. Processa o áudio e mostra o resultado
    await _processAndInfer(path);

    setState(() {
      _isProcessing = false; // Finaliza o processamento
    });
  }

  Future<void> _processAndInfer(String path) async {
    try {
      // Lê o arquivo .wav
      final file = File(path);
      if (!await file.exists()) {
        _showErrorDialog("Arquivo de áudio não encontrado.");
        return;
      }
      final wav = await Wav.readFile(path);

      // Converte o áudio para o formato que o modelo espera (Float32List)
      // O modelo espera um array de 1 dimensão.
      final audioBuffer = wav.channels.expand((ch) => ch).toList();
      final floatBuffer = Float32List.fromList(
        audioBuffer.map((e) => e.toDouble()).toList(),
      );

      // Executa a inferência
      final output = await _audioInferenceService.runInference(floatBuffer);

      // Encontra o resultado com maior probabilidade
      String bestLabel = 'N/A';
      double highestProb = 0.0;
      output.forEach((label, prob) {
        if (prob > highestProb) {
          highestProb = prob;
          bestLabel = label;
        }
      });

      // Mostra o resultado
      _showResultDialog(bestLabel, highestProb);
    } catch (e) {
      _showErrorDialog("Falha ao processar o áudio: ${e.toString()}");
    }
  }

  void _showResultDialog(String label, double probability) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Resultado da Análise"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Som detectado: $label"),
            const SizedBox(height: 8),
            Text("Probabilidade: ${(probability * 100).toStringAsFixed(2)}%"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erro"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSimularBanhoCard(),
              const SizedBox(height: 24),
              _buildConsumoDiarioCard(),
              const SizedBox(height: 24),
              _buildAlertasRecentesCard(context),
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
                  Icon(Icons.water_drop_outlined, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      "Escuta d'Água",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.play_circle_outline, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'Monitorando em\ncasa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
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
                  const Text(
                    'Alto consumo hoje',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Você já usou 18 minutos de água hoje, 60% da sua meta.',
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
              onTap: _toggleCapture,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    if (_isProcessing)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(_isCapturing ? Icons.pause : Icons.mic_none),
                    const SizedBox(height: 8),
                    Text(
                      _isCapturing
                          ? 'Pausar'
                          : (_isProcessing ? 'Analisando...' : 'Pausar'),
                    ),
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
