import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ControleScreen extends StatefulWidget {
  const ControleScreen({super.key});

  @override
  State<ControleScreen> createState() => _ControleScreenState();
}

class _ControleScreenState extends State<ControleScreen> {
  // record >=5 uses AudioRecorder
  final AudioRecorder _rec = AudioRecorder();
  StreamSubscription<Amplitude>? _ampSub;
  String? _currentFilePath; // arquivo temporário quando fallback para gravação em disco

  bool _listening = false; // toggle do usuário
  bool _sampling = false; // 2s ouvindo vs 2s descanso
  bool _noiseDetected = false; // tag de ruído

  // Duty cycle
  final Duration _sampleFor = const Duration(seconds: 2);
  final Duration _idleFor = const Duration(seconds: 2);
  Timer? _cycleTimer;

  // O plugin 'record' expõe amplitude em dBFS (0 = máximo, silêncio próximo de -90).
  // Portanto, os valores são negativos. Use um limiar como -45 dBFS (quanto mais próximo de 0, mais alto).
  double _thresholdDbFs = -45;
  double? _latestDbFs;
  // Suavização e histerese para evitar falso-positivos e efeito "grudado".
  double? _emaDbFs; // média móvel exponencial (dBFS)
  final double _alpha = 0.2; // fator de suavização ~200ms -> responde em ~1s
  double _hysteresisDb = 5; // para desligar, precisa cair ~5 dB abaixo do limiar

  @override
  void dispose() {
    _stopAll();
    super.dispose();
  }

  Future<bool> _ensureMicPermission() async {
    // Request through permission_handler for nicer UX on Android
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) return false;
    }
    // Also check plugin own method (covers platform nuances)
  return await _rec.hasPermission();
  }

  Future<void> _start() async {
    if (_listening) return;
    if (!await _ensureMicPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de microfone negada.')),
        );
      }
      return;
    }
    setState(() {
      _listening = true;
      _noiseDetected = false;
      _latestDbFs = null;
      _emaDbFs = null;
    });
    _beginSampleWindow();
  }

  void _beginSampleWindow() async {
    _sampling = true;
    _ampSub?.cancel();

    // Start recording (no path -> temp), then listen to amplitude
    if (!await _rec.isRecording()) {
      // Prefer stream mode (sem arquivo). Em alguns encoders o stream não é suportado (ex.: WAV).
      try {
        await _rec.startStream(const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 44100,
        ));
      } catch (_) {
        // Fallback: grava em arquivo temporário (WAV) e apaga ao finalizar a janela
        final dir = await getTemporaryDirectory();
        _currentFilePath =
            '${dir.path}/listen_${DateTime.now().millisecondsSinceEpoch}.wav';
        await _rec.start(
          const RecordConfig(encoder: AudioEncoder.wav, sampleRate: 44100),
          path: _currentFilePath!,
        );
      }
    }

    _ampSub = _rec.onAmplitudeChanged(const Duration(milliseconds: 200)).listen(
      (amp) {
        final db = amp.current; // dBFS: 0 (máx) .. -90 (silêncio)
        if (!db.isFinite) return;
        final val = db.clamp(-120, 0).toDouble();
        // atualiza suavização
        _emaDbFs = _emaDbFs == null ? val : (_emaDbFs! * (1 - _alpha) + val * _alpha);
        setState(() {
          _latestDbFs = _emaDbFs;
          // Histerese: liga acima do limiar, desliga quando cair limiar - hysteresis
          final onThresh = _thresholdDbFs;
          final offThresh = _thresholdDbFs - _hysteresisDb;
          if (!_noiseDetected && (_latestDbFs ?? -120) >= onThresh) {
            _noiseDetected = true;
          } else if (_noiseDetected && (_latestDbFs ?? -120) <= offThresh) {
            _noiseDetected = false;
          }
        });
      },
      onError: (e, s) {
        _stopAll();
      },
      cancelOnError: true,
    );

    _cycleTimer?.cancel();
    _cycleTimer = Timer(_sampleFor, _endSampleWindow);
  }

  void _endSampleWindow() async {
    _sampling = false;
    await _ampSub?.cancel();
    _ampSub = null;
    if (await _rec.isRecording()) {
      await _rec.stop();
    }

    // Remove arquivo temporário se criado
    if (_currentFilePath != null) {
      try {
        final f = File(_currentFilePath!);
        if (await f.exists()) {
          await f.delete();
        }
      } catch (_) {}
      _currentFilePath = null;
    }

    if (!_listening) return;

    _cycleTimer?.cancel();
    _cycleTimer = Timer(_idleFor, () {
      if (_listening) _beginSampleWindow();
    });
  }

  Future<void> _stopAll() async {
    _listening = false;
    _sampling = false;
    _cycleTimer?.cancel();
    _cycleTimer = null;
    await _ampSub?.cancel();
    _ampSub = null;
    if (await _rec.isRecording()) {
      await _rec.stop();
    }
    // Limpa arquivo temporário pendente
    if (_currentFilePath != null) {
      try {
        final f = File(_currentFilePath!);
        if (await f.exists()) {
          await f.delete();
        }
      } catch (_) {}
      _currentFilePath = null;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Controle')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _noiseDetected ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _noiseDetected ? Colors.redAccent : Colors.green,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _noiseDetected ? Icons.warning_amber_rounded : Icons.check_circle,
                      color: _noiseDetected ? Colors.redAccent : Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _noiseDetected ? 'Ruído alto detectado' : 'Sem ruído elevado',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _latestDbFs != null
                    ? 'Nível atual: ${_latestDbFs!.toStringAsFixed(1)} dBFS'
                    : 'Nível atual: -- dBFS',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 180,
                height: 180,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: _listening ? Colors.redAccent : theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_listening) {
                      _stopAll();
                    } else {
                      _start();
                    }
                  },
                  child: Text(
                    _listening ? 'Parar' : 'Ouvir',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(_sampling ? 'Amostrando áudio...' : (_listening ? 'Aguardando...' : 'Microfone desligado')),

              const SizedBox(height: 24),
              Column(
                children: [
                  Text('Limiar de detecção: ${_thresholdDbFs.toStringAsFixed(0)} dBFS'),
                  Slider(
                    value: _thresholdDbFs,
                    min: -90,
                    max: 0,
                    divisions: 90,
                    label: _thresholdDbFs.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _thresholdDbFs = v),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
