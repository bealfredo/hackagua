import 'dart:convert';

import 'package:hackagua_flutter/models/configuracoes.dart';

class ConfigService {
  final String _baseUrl = "https://api.escutadagua.com.br/v1";
  // TODO: Pegar o token de autenticação salvo (do AuthService)
  final String _token = "SEU_TOKEN_DE_AUTH_AQUI";

  Future<Configuracoes> getConfiguracoes() async {
    final url = Uri.parse('$_baseUrl/configuracoes');
    try {
      // **Simulação de API para testes (REMOVA ISSO EM PRODUÇÃO)**
      // Vamos simular uma espera e uma resposta da API
      await Future.delayed(const Duration(milliseconds: 800));
      final simulacaoResposta = {
        "geofence": {
          "endereco": "Rua 9 de Julho, Quadra 15, Lote 25 - Setor Bela Vista",
          "raio": 50,
        },
        "sensibilidade": 1.0,
        "metaDiaria": 30,
        "privacidade": {"processarSoEmCasa": false, "descartarAudio": true},
      };
      return Configuracoes.fromJson(simulacaoResposta);
      // **Fim da Simulação**

      /*
      // CÓDIGO REAL DA API (USE ESTE EM PRODUÇÃO)
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Configuracoes.fromJson(jsonResponse);
      } else {
        throw Exception('Falha ao carregar configurações.');
      }
      */
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Salva o objeto de configurações completo na API
  Future<void> salvarConfiguracoes(Configuracoes config) async {
    final url = Uri.parse('$_baseUrl/configuracoes');
    try {
      final body = jsonEncode(config.toJson()); // Usa o método toJson do modelo

      // **Simulação de API para testes (REMOVA ISSO EM PRODUÇÃO)**
      await Future.delayed(const Duration(milliseconds: 500));
      print('Configurações salvas (simulação): $body');
      // **Fim da Simulação**

      /*
      // CÓDIGO REAL DA API (USE ESTE EM PRODUÇÃO)
      final response = await http.put( // ou http.post
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: body,
      );

      if (response.statusCode != 200 && response.statusCode != 204) { // 204 = No Content
        // Se a API falhar ao salvar
        throw Exception('Falha ao salvar configurações.');
      }
      */
    } catch (e) {
      throw Exception('Erro de conexão ao salvar: $e');
    }
  }
}
