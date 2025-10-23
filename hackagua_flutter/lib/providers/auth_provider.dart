import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/usuario.dart';
import '../services/usuario_service.dart';

class AuthProvider extends ChangeNotifier {
  Usuario? _user;
  bool _isLoading = false;
  final String _boxName = 'auth_box';
  String? _errorMessage;
  String? _token;

  Usuario? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;

  AuthProvider() {
    checkLoginStatus();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  static Future<void> initHive() async {
    await Hive.initFlutter();
  }

  Future<void> _saveUserData() async {
    final box = await Hive.openBox(_boxName);

    if (_user == null) {
      await box.delete('user_data');
      await box.delete('auth_token');
      return;
    }

    final userData = _user!.toJson();

    // print('Salvando usuário no Hive: $_user');

    await box.put('user_data', userData);
    if (_token != null && _token!.isNotEmpty) {
      await box.put('auth_token', _token);
    }
  }

  // Carregar dados do usuário
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    final box = await Hive.openBox(_boxName);
    final cachedUserData = box.get('user_data');
    _token = box.get('auth_token');

    // Fallback: tenta carregar do cache primeiro (exibição imediata/offline)
    if (cachedUserData != null) {
      try {
        _user = Usuario.fromJson(cachedUserData);
      } catch (_) {
        _user = null;
      }
    } else {
      _user = null;
    }
    notifyListeners();

    // Se existir token, sempre buscar informações atualizadas do usuário
    if (_token != null && _token!.isNotEmpty) {
      try {
        final response = await getUsuarioByToken();

        // Atualiza token se servidor enviar um novo no header
        final headers = response.headers;
        final refreshedToken =
            headers['authorization'] ??
            headers['Authorization'] ??
            headers['x-auth-token'] ??
            headers['token'];
        if (refreshedToken != null && refreshedToken.isNotEmpty) {
          _token = refreshedToken;
          await box.put('auth_token', _token);
        }

        if (response.statusCode >= 200 &&
            response.statusCode < 300 &&
            response.body.isNotEmpty) {
          try {
            final data = jsonDecode(utf8.decode(response.bodyBytes));
            _user = Usuario.fromJson(data);
            // Atualiza o cache com as novas informações
            await _saveUserData();
          } catch (_) {
            // Se falhar ao parsear, mantém dados do cache
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          // Token inválido/expirado: limpa sessão
          _user = null;
          _token = null;
          await box.delete('user_data');
          await box.delete('auth_token');
        } else {
          // Outros erros do servidor: mantém cache (modo offline)
        }
      } catch (_) {
        // Erro de rede: mantém dados em cache
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Métodos login e logout
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null; // Limpa a mensagem de erro anterior
    notifyListeners();

    try {
      // Chama o serviço de login com os parâmetros na ordem correta
      http.Response response = await loginStudent(email, password);

      // Captura token do header (case-insensitive em http package)
      final headers = response.headers;
      final tokenFromHeader =
          headers['authorization'] ??
          headers['Authorization'] ??
          headers['x-auth-token'] ??
          headers['token'];
      if (tokenFromHeader != null && tokenFromHeader.isNotEmpty) {
        _token = tokenFromHeader;
        final box = await Hive.openBox(_boxName);
        await box.put('auth_token', _token);
      }

      // Se recebeu uma resposta com corpo
      if (response.body.isNotEmpty) {
        try {
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));

          if (response.statusCode >= 400) {
            _isLoading = false;

            // Extrai a mensagem de erro específica do campo auth
            if (responseData.containsKey('errors') &&
                responseData['errors'] is List &&
                responseData['errors'].isNotEmpty) {
              for (final error in responseData['errors']) {
                if (error['fieldName'] == 'auth') {
                  _errorMessage =
                      error['message']; // "Login ou senha inválidos"
                  break;
                }
              }
            }

            // Se não encontrou mensagem específica, usa a mensagem geral
            if (_errorMessage == null && responseData.containsKey('message')) {
              _errorMessage = responseData['message']; // "Erro de validação."
            }

            // Mensagem padrão se nenhuma mensagem foi encontrada
            _errorMessage ??= 'Erro ao fazer login. Tente novamente.';

            // print('Erro de autenticação: $_errorMessage');
            notifyListeners();
            return false;
          }

          // Login bem-sucedido - processa os dados do usuário
          try {
            _user = Usuario.fromJson(responseData);
            await _saveUserData();
            _isLoading = false;
            notifyListeners();
            return true;
          } catch (e) {
            _isLoading = false;
            _errorMessage = 'Erro ao processar dados do usuário: $e';
            notifyListeners();
            return false;
          }
        } catch (e) {
          // Erro ao processar o JSON
          _isLoading = false;
          _errorMessage = 'Erro ao processar resposta do servidor';
          // print('Erro ao processar JSON: $e');
          notifyListeners();
          return false;
        }
      }
      // Resposta sem corpo
      else if (response.statusCode >= 400) {
        _isLoading = false;
        _errorMessage = 'Erro no servidor (${response.statusCode})';
        notifyListeners();
        return false;
      }

      // Chegou aqui, mas não deveria (caso inesperado)
      _isLoading = false;
      _errorMessage = 'Resposta inesperada do servidor';
      notifyListeners();
      return false;
    } on TimeoutException {
      _isLoading = false;
      _errorMessage = 'Tempo de conexão esgotado. Tente novamente mais tarde.';
      notifyListeners();
      return false;
    } on SocketException catch (e) {
      _isLoading = false;
      // Mensagens mais úteis para problemas comuns
      final msg = e.message.toLowerCase();
      if (msg.contains('failed host lookup') || msg.contains('host lookup')) {
        _errorMessage =
            'Não foi possível resolver o servidor. Verifique seu sinal de internet ou a URL do servidor.';
      } else if (msg.contains('connection refused')) {
        _errorMessage =
            'Conexão recusada pelo servidor. O serviço pode estar fora do ar.';
      } else if (msg.contains('network is unreachable')) {
        _errorMessage =
            'Rede indisponível. Verifique sua conexão com a internet.';
      } else {
        _errorMessage = 'Erro de conexão: verifique sua internet.';
      }
      notifyListeners();
      return false;
    } on HandshakeException {
      _isLoading = false;
      _errorMessage =
          'Falha de certificado SSL/TLS. Tente novamente ou contate o suporte.';
      notifyListeners();
      return false;
    } catch (_) {
      _isLoading = false;
      _errorMessage = 'Não foi possível concluir o login. Tente novamente.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    await _saveUserData();
    notifyListeners();
  }
}
