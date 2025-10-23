class Usuario {
  int? id; // Long id na UML
  String nome; // String nome
  String email; // String email
  String senha; // String senha
  double metaDiaria; // double metaDiaria

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.metaDiaria,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      metaDiaria: (json['metaDiaria'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'metaDiaria': metaDiaria,
    };
  }
}
