import 'package:hackagua_flutter/models/enums.dart';

class EventoAgua {
  int? id; // Long id
  int idUsuario; // Long idUsuario
  DateTime registroDeTempo; // DateTime registroDeTempo
  TipoEvento tipo; // TipoEvento tipo
  double duracaoSegundos; // double duracaoSegundos
  double gastoLitros; // double gastoLitros - Adicionado para persistir o resultado do cálculo
  String descricao; // String descricao

  EventoAgua({
    this.id,
    required this.idUsuario,
    required this.registroDeTempo,
    required this.tipo,
    required this.duracaoSegundos,
    required this.gastoLitros,
    required this.descricao,
  });
}
