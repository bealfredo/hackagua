class Usuario {
  int id;
  String nome;
  String sobrenome;
  List<String> imagens;
  String imagemPrincipal;
  String login;
  String cpf;
  DateTime dataNascimento;

  String? corRaca;
  String? uf;
  String? cidade;
  String? bairro;
  String? cep;
  String? logradouro;
  String? numero;
  String? complemento;
  String? emailPessoal;
  String? telefoneCelular1;
  String? telefoneCelular2;
  String? telefoneFixo;

  Usuario({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.imagens,
    required this.imagemPrincipal,
    required this.login,
    required this.cpf,
    required this.dataNascimento,
    this.corRaca,
    this.uf,
    this.cidade,
    this.bairro,
    this.cep,
    this.logradouro,
    this.numero,
    this.complemento,
    this.emailPessoal,
    this.telefoneCelular1,
    this.telefoneCelular2,
    this.telefoneFixo,
  });

  factory Usuario.fromJson(dynamic jsonData) {
    // Garantir que estamos trabalhando com um Map
    final json = jsonData as Map;

    return Usuario(
      id: (json['id'] as num).toInt(),
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      imagens: List<String>.from(json['imagens'] ?? []),
      imagemPrincipal: json['imagemPrincipal'] ?? '',
      login: json['login'],
      cpf: json['cpf'],
      dataNascimento: json['dataNascimento'] is DateTime
          ? json['dataNascimento']
          : DateTime.parse(json['dataNascimento']),
      // Novos campos
      corRaca: json['corRaca'],
      uf: json['uf'],
      cidade: json['cidade'],
      bairro: json['bairro'],
      cep: json['cep'],
      logradouro: json['logradouro'],
      numero: json['numero'],
      complemento: json['complemento'],
      emailPessoal: json['emailPessoal'],
      telefoneCelular1: json['telefoneCelular1'],
      telefoneCelular2: json['telefoneCelular2'],
      telefoneFixo: json['telefoneFixo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sobrenome': sobrenome,
      'imagens': imagens,
      'imagemPrincipal': imagemPrincipal,
      'login': login,
      'cpf': cpf,
      'dataNascimento': dataNascimento.toIso8601String(),
      'corRaca': corRaca,
      'uf': uf,
      'cidade': cidade,
      'bairro': bairro,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'emailPessoal': emailPessoal,
      'telefoneCelular1': telefoneCelular1,
      'telefoneCelular2': telefoneCelular2,
      'telefoneFixo': telefoneFixo,
    };
  }
}
