// [ATUALIZAÇÃO] Importe o novo modelo ConsumoAgua
import 'package:hackagua_flutter/models/consumo_agua.dart';

class ConsumoService {
  // final String _baseUrl = "http://10.0.2.2:8080"; // Exemplo para Emulador Android
  // TODO: Adicionar token

  // [ATUALIZAÇÃO] Método agora retorna Future<ConsumoAgua?>
  Future<ConsumoAgua?> getConsumoHoje() async {
    // final url = Uri.parse('$_baseUrl/consumo/hoje'); // Ajuste o endpoint se necessário

    try {
      // ** Simulação **
      await Future.delayed(const Duration(seconds: 1));
      // Pode retornar null se não houver consumo ainda
      final simulacaoResposta = {
        "id": DateTime.now().toIso8601String().substring(0, 10), // ID = Data
        "idUsuario": 1,
        "data": DateTime.now().toIso8601String(),
        "minutosUsados": 0.0, // Começa com 0 para a imagem
      };
      // ** Fim Simulação **

      /* // Código Real API
      final response = await http.get(url, headers: { 'Authorization': 'Bearer SEU_TOKEN'});
      if (response.statusCode == 200) {
         if (response.body.isEmpty) return null; // Nenhum consumo hoje
         final jsonResponse = jsonDecode(response.body);
         return ConsumoAgua.fromJson(jsonResponse);
      } else if (response.statusCode == 404) {
         return null; // Endpoint pode retornar 404 se não houver consumo
      } else {
         throw Exception('Falha ao carregar consumo.');
      }
      */
      return ConsumoAgua(
        id: DateTime.now().millisecondsSinceEpoch,
        idUsuario: simulacaoResposta['idUsuario'] as int,
        data: DateTime.parse(simulacaoResposta['data'] as String),
        minutosUsados: (simulacaoResposta['minutosUsados'] as num).toDouble(),
      );
    } catch (e) {
      throw Exception('Erro de conexão ao buscar consumo: $e');
    }
  }
}
