import 'package:flutter/material.dart';
import 'package:hackagua_flutter/models/enums.dart';
import 'package:hackagua_flutter/models/evento_agua.dart';
import 'package:hackagua_flutter/services/communication_service.dart';
import 'package:hackagua_flutter/services/detection_service.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  final DetectionService _detectionService = DetectionService();
  final CommunicationService _communicationService = CommunicationService();
  bool _isDetecting = false;
  final List<EventoAgua> _detectedEvents = [];

  @override
  void initState() {
    super.initState();
  }

  void _onEventDetected(TipoEvento tipo, double duracao) {
    final newEvent = EventoAgua(
      id: DateTime.now().millisecondsSinceEpoch,
      idUsuario: 1, // Mock user ID
      registroDeTempo: DateTime.now(),
      tipo: tipo,
      duracaoSegundos: duracao,
      gastoLitros: 0.0,
      descricao: 'Evento detectado: ${tipo.toString()}',
    );

    setState(() {
      _detectedEvents.add(newEvent);
    });

    _communicationService.sendEvent(newEvent);
  }

  void _toggleDetection() {
    if (_isDetecting) {
      _detectionService.dispose();
    } else {
      _detectionService.startRecording(onEvent: _onEventDetected);
    }
    setState(() {
      _isDetecting = !_isDetecting;
    });
  }

  @override
  void dispose() {
    _detectionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detecção de Ruído')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _toggleDetection,
              child: Text(_isDetecting ? 'Parar Detecção' : 'Iniciar Detecção'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _detectedEvents.length,
              itemBuilder: (context, index) {
                final event = _detectedEvents[index];
                return ListTile(
                  title: Text(event.descricao),
                  subtitle: Text(
                    'Duração: ${event.duracaoSegundos.toStringAsFixed(2)}s - ${event.registroDeTempo}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
