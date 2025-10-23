// lib/services/audio_inference_service.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

/// Fallback stub for Interpreter when the tflite_flutter package is missing
/// or not yet added to pubspec.yaml. This provides the minimal interface
/// used in this file so the project can compile; at runtime you should
/// remove this stub and rely on the real Interpreter from the package.
class Interpreter {
  Interpreter();

  /// Mimics the API used in this file. Throws by default to indicate the
  /// real implementation should be provided by the tflite_flutter package.
  static Future<Interpreter> fromAsset(String asset) async {
    throw UnsupportedError(
      'Interpreter.fromAsset is not implemented. Add tflite_flutter to pubspec.yaml and remove this stub.',
    );
  }

  void allocateTensors() {}

  void run(Object input, Object output) {}

  void close() {}
}

class AudioInferenceService {
  late Interpreter _interpreter;
  late List<String> _labels;
  bool _isModelLoaded = false;

  // Configurações do modelo que serão carregadas do JSON
  late int _expectedInputSamples;

  AudioInferenceService() {
    _loadModel();
  }

  bool get isLoaded => _isModelLoaded;

  Future<void> _loadModel() async {
    try {
      // 1. Carregar o modelo TFLite
      _interpreter = await Interpreter.fromAsset(
        'tflite/classificador_agua_hackathon.tflite',
      );

      // 2. Carregar os metadados (labels.json)
      final labelsJson = await rootBundle.loadString(
        'assets/tflite/labels.json',
      );
      final Map<String, dynamic> modelConfig = json.decode(labelsJson);

      _labels = List<String>.from(modelConfig['classes']);
      // int sampleRate = modelConfig['sample_rate']; // Não usado no momento
      _expectedInputSamples = modelConfig['expected_waveform_length'];

      // Alocar tensores
      _interpreter.allocateTensors();
      _isModelLoaded = true;
      print('✅ Modelo TFLite e labels carregados com sucesso!');
      print('Labels: $_labels');
    } catch (e) {
      print('❌ Erro ao carregar o modelo: $e');
    }
  }

  /// Executa a inferência em um buffer de áudio.
  /// O buffer deve ser Float32List e ter o tamanho esperado pelo modelo.
  Future<Map<String, double>> runInference(Float32List audioBuffer) async {
    if (!_isModelLoaded) {
      print('⚠️ Modelo não carregado. Tentando carregar novamente...');
      await _loadModel();
      if (!_isModelLoaded) {
        throw Exception("Modelo não pôde ser carregado.");
      }
    }

    // Garante que o buffer de entrada tem o tamanho correto
    if (audioBuffer.length != _expectedInputSamples) {
      throw ArgumentError(
        'Buffer de áudio tem tamanho ${audioBuffer.length}, mas o modelo espera $_expectedInputSamples.',
      );
    }

    // Prepara a saída
    // O modelo retorna um tensor com as probabilidades para cada classe.
    // Ex: [[0.1, 0.8, 0.05, ...]]
    // Cria uma lista 2D: uma linha com tantas colunas quanto labels.
    var output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    // Executa a inferência
    _interpreter.run(audioBuffer, output);

    // Processa o resultado
    final probabilities = output[0];

    // Mapeia os labels para suas probabilidades
    final Map<String, double> results = {};
    for (int i = 0; i < _labels.length; i++) {
      results[_labels[i]] = probabilities[i];
    }

    return results;
  }

  void close() {
    if (_isModelLoaded) {
      _interpreter.close();
    }
  }
}
