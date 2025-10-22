import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

const String baseUrlApi = 'https://api.example.com';

Future<http.Response> loginStudent(String login, String senha) async {
  final url = Uri.parse('$baseUrlApi/auth');

  final requestBody = jsonEncode({
    'login': login,
    'senha': senha,
    'idTipoPerfil': 5,
  });

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'accept': '*/*'},
      body: requestBody,
    );

    return response;
  } catch (e) {
    // Repassando a exceção para ser tratada no AuthProvider
    rethrow;
  }
}

// Atualiza dados do próprio usuario (self-update) conforme o endpoint de PATCH /usuarios/selfupdate
Future<http.Response> updateUsuario(Map<String, dynamic> usuarioContato) async {
  final url = Uri.parse('$baseUrlApi/alunos/selfupdate');

  // Recupera token salvo no Hive (se existir)
  String? token;
  try {
    final box = await Hive.openBox('auth_box');
    token = box.get('auth_token');
  } catch (_) {}

  final headers = <String, String>{
    'Content-Type': 'application/json',
    'accept': '*/*',
  };
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = token.startsWith('Bearer ')
        ? token
        : 'Bearer $token';
  }

  final response = await http.patch(
    url,
    headers: headers,
    body: jsonEncode(usuarioContato),
  );

  return response;
}

Future<http.Response> uploadImagemUsuario(String userId, XFile imagem) async {
  final uri = Uri.parse('$baseUrlApi/alunos/$userId/upload/imagem');

  var request = http.MultipartRequest(
    'PATCH',
    uri,
  ); // Corrigido de POST para PATCH

  // Anexa token se existir
  try {
    final box = await Hive.openBox('auth_box');
    final token = box.get('auth_token');
    if (token is String && token.isNotEmpty) {
      request.headers['Authorization'] = token.startsWith('Bearer ')
          ? token
          : 'Bearer $token';
    }
  } catch (_) {}

  if (kIsWeb) {
    // Web: lê os bytes do arquivo e envia como multipart com nome do campo "imagem"
    var byteData = await imagem.readAsBytes();
    var multipartFile = http.MultipartFile.fromBytes(
      'imagem', // nome do campo conforme Swagger
      byteData,
      filename: imagem.name,
      contentType: MediaType('image', 'png'), // ajuste o tipo se necessário
    );
    request.files.add(multipartFile);
  } else {
    // Android/iOS: usa fromPath com nome do campo correto
    var multipartFile = await http.MultipartFile.fromPath(
      'imagem', // nome do campo conforme Swagger
      imagem.path,
      filename: imagem.name,
    );
    request.files.add(multipartFile);
  }

  final streamedResponse = await request.send();
  return http.Response.fromStream(streamedResponse);
}

/// Recupera as informações do usuário autenticado usando o token salvo
Future<http.Response> getUsuarioByToken() async {
  final url = Uri.parse('$baseUrlApi/alunos/findbytoken');

  // Recupera token salvo no Hive (se existir)
  String? token;
  try {
    final box = await Hive.openBox('auth_box');
    token = box.get('auth_token');
  } catch (_) {}

  final headers = <String, String>{'accept': '*/*'};
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = token.startsWith('Bearer ')
        ? token
        : 'Bearer $token';
  }

  final response = await http.get(url, headers: headers);
  return response;
}
