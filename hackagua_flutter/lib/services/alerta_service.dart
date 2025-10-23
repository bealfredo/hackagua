import 'package:hackagua_flutter/models/alerta.dart';
import 'package:hackagua_flutter/models/enums.dart';

class AlertaService {
  // final String _baseUrl = "http://10.0.2.2:8080"; // Exemplo para Emulador Android
  // TODO: Adicionar token de autenticação

  Future<List<Alerta>> getAlertasRecentes({int limite = 10}) async {
    // final url = Uri.parse('$_baseUrl/alertas/recentes?limite=$limite');
    try {
      // ** Simulação **
      await Future.delayed(const Duration(milliseconds: 900));
      final simulacaoResposta = [
        {
          "id": 123,
          "idUsuario": 1,
          "tipo": "ALTO_CONSUMO", // Deve corresponder ao Enum
          "titulo": "Alto consumo hoje",
          "mensagem": "Você já usou 18 minutos de água hoje, 60% da sua meta.",
          "criadoEm": DateTime.now().toIso8601String(),
          "estaLido": false,
          "estaSuspenso": false
        },
        {
          "id": 124,
          "idUsuario": 1,
          "tipo": "VAZAMENTO_DETECTADO",
          "titulo": "Água detectada à noite",
          "mensagem":
              "Som de água detectado às 2:30 da madrugada. Verifique possível vazamento.",
          "criadoEm":
              DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          "estaLido": true,
          "estaSuspenso": false
        },
        {
          "id": 125,
          "idUsuario": 1,
          "tipo": "BANHO_LONGO",
          "titulo": "Banho longo detectado",
          "mensagem":
              "Seu último banho durou 15 minutos. Considere reduzir o tempo para 5 minutos.",
          "criadoEm":
              DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
          "estaLido": true,
          "estaSuspenso": false
        }
      ];
      // ** Fim Simulação **

      /* // Código Real API
      final response = await http.get(url, headers: { 'Authorization': 'Bearer SEU_TOKEN'});
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Alerta.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar alertas');
      }
      */

      return simulacaoResposta.map((json) {
        // Converte a string do tipo para o enum correspondente
        TipoAlerta tipo = TipoAlerta.values.firstWhere(
          (e) => e.toString().split('.').last == json['tipo'],
          orElse: () => TipoAlerta.ALTO_CONSUMO, // Valor padrão
        );

        return Alerta(
          id: json['id'] as int,
          idUsuario: json['idUsuario'] as int,
          tipo: tipo,
          titulo: json['titulo'] as String,
          mensagem: json['mensagem'] as String,
          criadoEm: DateTime.parse(json['criadoEm'] as String),
          estaLido: json['estaLido'] as bool,
          estaSuspenso: json['estaSuspenso'] as bool,
        );
      }).toList();
    } catch (e) {
      throw Exception('Erro de conexão ao buscar alertas: $e');
    }
  }
}
