class ConsumoAgua {
  int? id; // Long id
  int idUsuario; // Long idUsuario
  DateTime data; // DateTime data
  double minutosUsados; // double minutosUsados

  ConsumoAgua({
    this.id,
    required this.idUsuario,
    required this.data,
    required this.minutosUsados,
  });
}
