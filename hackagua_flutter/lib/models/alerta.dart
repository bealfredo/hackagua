import 'package:hackagua_flutter/models/enums.dart';

class Alerta {
  int? id; // Long id
  int idUsuario; // Long idUsuario
  TipoAlerta tipo; // TipoAlerta tipo
  String titulo; // String titulo
  String mensagem; // String mensagem
  DateTime criadoEm; // DateTime criadoEm
  bool estaLido; // bool estaLido
  bool estaSuspenso; // bool estaSuspenso

  Alerta({
    this.id,
    required this.idUsuario,
    required this.tipo,
    required this.titulo,
    required this.mensagem,
    required this.criadoEm,
    required this.estaLido,
    required this.estaSuspenso,
  });
}
