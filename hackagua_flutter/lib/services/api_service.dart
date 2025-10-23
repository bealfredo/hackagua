import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hackagua_flutter/models/enums.dart';

class ApiService {
  static const String baseUrl = 'http://72.60.3.7:8081';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Envia um evento de detecção de água para a API
  Future<bool> sendWaterEvent({
    required TipoEvento tipoEvento,
    required double duracao,
    required DateTime timestamp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/eventos'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tipo': tipoEvento.toString().split('.').last,
          'duracao': duracao,
          'timestamp': timestamp.toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Evento enviado com sucesso para a API');
        return true;
      } else {
        print('Erro ao enviar evento: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao conectar com a API: $e');
      return false;
    }
  }

  /// Busca o histórico de eventos da API
  Future<List<Map<String, dynamic>>> getEventHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/eventos'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Erro ao buscar histórico: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao conectar com a API: $e');
      return [];
    }
  }

  /// Busca estatísticas de consumo
  Future<Map<String, dynamic>?> getStatistics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/estatisticas'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Erro ao buscar estatísticas: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao conectar com a API: $e');
      return null;
    }
  }

  /// Testa a conexão com a API
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao testar conexão com a API: $e');
      return false;
    }
  }
}
