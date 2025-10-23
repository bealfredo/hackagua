import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:hackagua_flutter/models/enums.dart';
// [CORREÇÃO] Removido o import 'audio_inference_service.dart' que causava o conflito de 'Interpreter'.
// import 'package:hackagua_flutter/services/audio_inference_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart'; // Este import está correto
import 'package:tflite_flutter/tflite_flutter.dart'; // Agora não há mais conflito
import 'package:wav/wav.dart';

class DetectionService {
  // [CORREÇÃO] A classe 'Record' é abstrata. Usamos a implementação 'AudioRecorder'.
  final AudioRecorder _audioRecorder = AudioRecorder();
  Interpreter? _interpreter;
  List<String>? _labels;
  Timer? _recordingTimer;
  DateTime? _startTime;

  // Configurações do modelo
  static const int _sampleRate = 16000;
  static const int _duration = 5;
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
    // O método 'hasPermission' existe em AudioRecorder, está correto.
    if (await _audioRecorder.hasPermission()) {
      _recordingTimer =
          Timer.periodic(const Duration(seconds: _duration), (timer) async {
        if (_startTime != null) {
          final duration =
              DateTime.now().difference(_startTime!).inSeconds.toDouble();
          final result = await stopRecordingAndClassify();
          if (result != null) {
            onEvent(result, duration);
          }
        }
        _startIntervalRecording();
      });
      _startIntervalRecording();
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
        final audioData = wav.channels.first;

        final preprocessedData = _preprocessAudio(audioData);

        if (_interpreter != null && _labels != null) {
          // O modelo espera um tensor com shape [80000]
          var input = preprocessedData;
          // O output terá o shape [1, num_classes]
          var output =
              List.filled(1 * _labels!.length, 0.0).reshape([1, _labels!.length]);

          _interpreter!.runForMultipleInputs([input], {0: output});

          final eventType = _postprocessOutput(output[0]);
          return eventType;
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
    if (maxValue > 0.8 && _labels != null) {
      final label = _labels![maxIndex];
      print(
          'Label detectado: $label com confiança de ${maxValue.toStringAsFixed(2)}');
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

  void dispose() {
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    _interpreter?.close();
  }
}