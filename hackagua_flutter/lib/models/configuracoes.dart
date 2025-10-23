// lib/models/configuracoes.dart
class Configuracoes {
  String geofenceEndereco;
  int geofenceRaio;
  double sensibilidade; // 0.0 a 2.0 (Ex: Baixa=0, Média=1, Alta=2)
  int metaDiaria; // Em minutos
  bool processarSoEmCasa;
  bool descartarAudio;

  Configuracoes({
    required this.geofenceEndereco,
    required this.geofenceRaio,
    required this.sensibilidade,
    required this.metaDiaria,
    required this.processarSoEmCasa,
    required this.descartarAudio,
  });

  // Converte um JSON (da API) para um objeto Configuracoes
  factory Configuracoes.fromJson(Map<String, dynamic> json) {
    return Configuracoes(
      // Exemplo de como pegar dados aninhados
      geofenceEndereco: json['geofence']?['endereco'] ?? 'Não definido',
      geofenceRaio: (json['geofence']?['raio'] as num? ?? 50).toInt(),
      sensibilidade: (json['sensibilidade'] as num? ?? 1.0).toDouble(),
      metaDiaria: (json['metaDiaria'] as num? ?? 30).toInt(),
      processarSoEmCasa: json['privacidade']?['processarSoEmCasa'] ?? false,
      descartarAudio: json['privacidade']?['descartarAudio'] ?? true,
    );
  }

  // Converte o objeto Configuracoes para um JSON (para enviar à API)
  Map<String, dynamic> toJson() {
    return {
      'geofence': {
        'endereco': geofenceEndereco,
        'raio': geofenceRaio,
      },
      'sensibilidade': sensibilidade,
      'metaDiaria': metaDiaria,
      'privacidade': {
        'processarSoEmCasa': processarSoEmCasa,
        'descartarAudio': descartarAudio,
      }
    };
  }
}