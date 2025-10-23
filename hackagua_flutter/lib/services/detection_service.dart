import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:hackagua_flutter/models/enums.dart';
import 'package:hackagua_flutter/services/api_service.dart';
// [CORREÇÃO] Removido o import 'audio_inference_service.dart' que causava o conflito de 'Interpreter'.
// import 'package:hackagua_flutter/services/audio_inference_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart'; // Este import está correto
import 'package:tflite_flutter/tflite_flutter.dart'; // Agora não há mais conflito
import 'package:wav/wav.dart';

class DetectionService {
  // [CORREÇÃO] A classe 'Record' é abstrata. Usamos a implementação 'AudioRecorder'.
  final AudioRecorder _audioRecorder = AudioRecorder();
  final ApiService _apiService = ApiService();
  Interpreter? _interpreter;
  List<String>? _labels;
  Timer? _recordingTimer;
  DateTime? _startTime;
  double _rmsThreshold = 0.03; // Menos sensível: requer mais energia para considerar ruído
  
  // Emite true quando um ruído potencial para treino for detectado no último intervalo
  final StreamController<bool> _trainingNoiseController = StreamController<bool>.broadcast();

  Stream<bool> get trainingNoise$ => _trainingNoiseController.stream;

  // Configurações do modelo
  static const int _sampleRate = 16000;
  static const int _duration = 1; // Janela curta para "escutar o tempo todo"
  static const int _expectedInputLength = _sampleRate * _duration;

  DetectionService() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset(
        'assets/tflite/classificador_agua_hackathon.tflite',
        options: interpreterOptions,
      );

      final labelsData =
          await rootBundle.loadString('assets/tflite/labels.json');
      final jsonData = json.decode(labelsData);
      _labels = List<String>.from(jsonData['classes']);

      print('Modelo e labels carregados com sucesso.');
      print('Labels: $_labels');
    } catch (e) {
      print("Erro ao carregar o modelo: $e");
    }
  }

  Future<void> startRecording(
      {required Function(TipoEvento, double) onEvent}) async {
    try {
      // Verifica e solicita permissão antes de usar o gravador
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        print("Permissão de áudio não concedida.");
        return;
      }

      _recordingTimer =
          Timer.periodic(const Duration(seconds: _duration), (timer) async {
        if (_startTime != null) {
          final duration =
              DateTime.now().difference(_startTime!).inSeconds.toDouble();
          final result = await stopRecordingAndClassify();
          if (result != null) {
            onEvent(result, duration);
            // Envia o evento para a API
            _apiService.sendWaterEvent(
              tipoEvento: result,
              duracao: duration,
              timestamp: DateTime.now(),
            );
          }
        }
        _startIntervalRecording();
      });
      _startIntervalRecording();
    } catch (e) {
      print("Erro ao iniciar gravação: $e");
    }
  }

  Future<void> _startIntervalRecording() async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/recording.wav';

    // [CORREÇÃO] O método 'startRecorder' agora se chama 'start'.
    // Ele também precisa de um 'RecordConfig' para definir o formato.
    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav, // Grava em formato WAV
        sampleRate: _sampleRate,   // Taxa de amostragem do modelo
        numChannels: 1,            // Áudio mono
      ),
      path: filePath,
    );
    _startTime = DateTime.now();
  }

  Future<TipoEvento?> stopRecordingAndClassify() async {
    // [CORREÇÃO] O método 'stopRecorder' agora se chama 'stop'.
    final path = await _audioRecorder.stop();
    
    if (path != null) {
      final audioFile = File(path);
      try {
  final wav = await Wav.readFile(path);
  // O modelo espera um canal (mono)
  final rawChannel = wav.channels.first;
  final normalized = _normalizeSamples(rawChannel);

  // Calcula a energia média (RMS) do sinal para inferir se houve som relevante
  final rms = _computeRms(normalized);
  final dbfs = rms > 0 ? 20 * math.log(rms) / math.ln10 : -120.0; // dBFS

  final preprocessedData = _preprocessAudio(normalized);

        if (_interpreter != null && _labels != null) {
          // O modelo espera um tensor com shape [80000]
          var input = preprocessedData;
          // O output terá o shape [1, num_classes]
          var output =
              List.filled(1 * _labels!.length, 0.0).reshape([1, _labels!.length]);

          _interpreter!.runForMultipleInputs([input], {0: output});

          // Pós-processamento com acesso à confiança máxima
          final probs = output[0];
          int maxIndex = 0;
          double maxValue = 0.0;
          for (int i = 0; i < probs.length; i++) {
            if (probs[i] > maxValue) {
              maxValue = probs[i];
              maxIndex = i;
            }
          }

          TipoEvento? eventType;
          if (_labels != null && _labels!.isNotEmpty && maxValue > 0.5) {
            final label = _labels![maxIndex];
            eventType = _mapLabelToTipoEvento(label);
          } else {
            eventType = null;
          }

          // "Ruído detectado": energia acima do limiar (independente do classificador)
          final bool noiseDetected = rms > _rmsThreshold;
          print('DEBUG Audio: RMS=${rms.toStringAsFixed(4)} (${dbfs.toStringAsFixed(1)} dBFS), maxProb=${maxValue.toStringAsFixed(2)}, noiseDetected=$noiseDetected');
          _trainingNoiseController.add(noiseDetected);

          return eventType;
        } else {
          // Se não conseguimos classificar, ainda assim avaliamos ruído pelo RMS
          final bool noiseDetected = rms > _rmsThreshold;
          print('DEBUG Audio (sem classificador): RMS=${rms.toStringAsFixed(4)} (${dbfs.toStringAsFixed(1)} dBFS), noiseDetected=$noiseDetected');
          _trainingNoiseController.add(noiseDetected);
        }
      } catch (e) {
        print("Erro durante a classificação: $e");
      } finally {
        // Esta é a sua lógica correta para não armazenar o áudio
        await audioFile.delete();
      }
    }
    return null;
  }

  Float32List _preprocessAudio(List<double> audioData) {
    final processedList = Float32List(_expectedInputLength);
    for (int i = 0; i < _expectedInputLength; i++) {
      if (i < audioData.length) {
        processedList[i] = audioData[i];
      } else {
        // Preenche com silêncio se o áudio for mais curto
        processedList[i] = 0.0;
      }
    }
    return processedList;
  }

  TipoEvento? _postprocessOutput(List<double> output) {
    int maxIndex = 0;
    double maxValue = 0.0;
    for (int i = 0; i < output.length; i++) {
      if (output[i] > maxValue) {
        maxValue = output[i];
        maxIndex = i;
      }
    }

    // Limiar de confiança para considerar a detecção válida
    if (_labels == null || _labels!.isEmpty) {
      return null;
    }

    final label = _labels![maxIndex];
    print(
        'DEBUG: Maior probabilidade: $label com confiança de ${maxValue.toStringAsFixed(2)}');

    if (maxValue > 0.5) {
      return _mapLabelToTipoEvento(label);
    }

    return null;
  }

  TipoEvento? _mapLabelToTipoEvento(String label) {
    switch (label.toLowerCase()) {
      case 'torneira_aberta':
        return TipoEvento.TORNEIRA_ABERTA;
        
      case 'som_descarga':
      case 'descarga':
        return TipoEvento.DESCARGA;

      case 'goteira':
      case 'vazamento':
        // [CORREÇÃO] O correto é 'TipoEvento', como manda o UML.
        return TipoEvento.VAZAMENTO; 

      case 'chuveiro':
      case 'duche': // 'DUCHE' está no seu UML
        return TipoEvento.ALTO_CONSUMO;

      case 'escovando_dentes':
        // [CORREÇÃO] Mapeado para torneira, que é mais lógico
        return TipoEvento.TORNEIRA_ABERTA; 
      
      // Mapeamentos diretos do seu UML
      case 'alto_consumo':
        return TipoEvento.ALTO_CONSUMO;
      case 'deteccao_noturna':
        return TipoEvento.DETECCAO_NOTURNA;
        
      default:
        // Retorna nulo se o label não for mapeado (ex: ruído de fundo)
        return null;
    }
  }

  Future<void> dispose() async {
    _recordingTimer?.cancel();
    // Verifica se o gravador está gravando antes de parar e liberar.
    final isRecording = await _audioRecorder.isRecording();
    if (isRecording) {
      await _audioRecorder.stop();
    }
    _audioRecorder.dispose();
    _interpreter?.close();
    await _trainingNoiseController.close();
    print("DetectionService finalizado.");
  }

  // Calcula RMS do sinal [-1,1]
  double _computeRms(List<double> samples) {
    if (samples.isEmpty) return 0.0;
    double sumSquares = 0.0;
    for (final s in samples) {
      sumSquares += s * s;
    }
    return math.sqrt(sumSquares / samples.length);
  }

  // Normaliza amostras para [-1, 1]. Se os valores estiverem além, assume PCM 16-bit.
  List<double> _normalizeSamples(List<double> samples) {
    if (samples.isEmpty) return samples;
    double maxAbs = 0.0;
    for (final s in samples) {
      final a = s.abs();
      if (a > maxAbs) maxAbs = a;
    }
    // Se já parece normalizado
    if (maxAbs <= 1.0) return samples;
    // Assume 16-bit PCM
    const double scale = 32768.0;
    return samples.map((s) => (s / scale).clamp(-1.0, 1.0)).toList();
  }

  // Permite ajustar o limiar de RMS dinamicamente, se necessário
  void setRmsThreshold(double value) {
    _rmsThreshold = value.clamp(0.0, 1.0);
  }
}