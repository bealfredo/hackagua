import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/usuario.dart';
import 'package:http/http.dart' as http;
import '../services/usuario_service.dart';
import '../main.dart'; // Para acessar baseUrlApi

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
    
    final userData = {
      'id': _user!.id,
      'nome': _user!.nome,
      'sobrenome': _user!.sobrenome,
      'imagens': _user!.imagens,
      'imagemPrincipal': _user!.imagemPrincipal,
      'login': _user!.login,
      'cpf': _user!.cpf,
      'dataNascimento': _user!.dataNascimento.toIso8601String(),
      'corRaca': _user!.corRaca,
      'uf': _user!.uf,
      'cidade': _user!.cidade,
      'bairro': _user!.bairro,
      'cep': _user!.cep,
      'logradouro': _user!.logradouro,
      'numero': _user!.numero,
      'complemento': _user!.complemento,
      'emailPessoal': _user!.emailPessoal,
      'telefoneCelular1': _user!.telefoneCelular1,
      'telefoneCelular2': _user!.telefoneCelular2,
      'telefoneFixo': _user!.telefoneFixo,
    };

    // final userData = _user!.toJson();
    
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
        final refreshedToken = headers['authorization'] ?? headers['Authorization'] ?? headers['x-auth-token'] ?? headers['token'];
        if (refreshedToken != null && refreshedToken.isNotEmpty) {
          _token = refreshedToken;
          await box.put('auth_token', _token);
        }

        if (response.statusCode >= 200 && response.statusCode < 300 && response.body.isNotEmpty) {
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
      print('🔐 Iniciando login para: $email');
      
      // Chama o serviço de login com os parâmetros na ordem correta
      http.Response response = await loginStudent(email, password);

      // Captura token do header (case-insensitive em http package)
      final headers = response.headers;
      final tokenFromHeader = headers['authorization'] ?? headers['Authorization'] ?? headers['x-auth-token'] ?? headers['token'];
      if (tokenFromHeader != null && tokenFromHeader.isNotEmpty) {
        _token = tokenFromHeader;
        final box = await Hive.openBox(_boxName);
        await box.put('auth_token', _token);
        print('✅ Token salvo: ${_token?.substring(0, 20)}...');
      }

      // Se recebeu uma resposta com corpo
      if (response.body.isNotEmpty) {
        try {
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));
          
          if (response.statusCode >= 400) {
            _isLoading = false;
            
            print('❌ Erro ${response.statusCode}: $responseData');
            
            // Extrai a mensagem de erro específica do campo auth
            if (responseData.containsKey('errors') && 
                responseData['errors'] is List && 
                responseData['errors'].isNotEmpty) {
              
              for (final error in responseData['errors']) {
                if (error['fieldName'] == 'auth') {
                  _errorMessage = error['message']; // "Login ou senha inválidos"
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
            
            print('📋 Mensagem de erro: $_errorMessage');
            notifyListeners();
            return false;
          }
          
          // Login bem-sucedido - processa os dados do usuário
          try {
            print('✅ Login bem-sucedido! Processando dados do usuário...');
            _user = Usuario.fromJson(responseData);
            await _saveUserData();
            _isLoading = false;
            notifyListeners();
            return true;
          } catch (e) {
            _isLoading = false;
            _errorMessage = 'Erro ao processar dados do usuário: $e';
            print('❌ Erro ao processar usuário: $e');
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
        print('⚠️ Resposta sem corpo com status ${response.statusCode}');
        notifyListeners();
        return false;
      }
      
      // Chegou aqui, mas não deveria (caso inesperado)
      _isLoading = false;
      _errorMessage = 'Resposta inesperada do servidor';
      print('⚠️ Resposta sem corpo com status ${response.statusCode}');
      notifyListeners();
      return false;
      
    } on TimeoutException catch (e) {
      // Timeout específico
      _isLoading = false;
      _errorMessage = 'Tempo esgotado. Verifique sua conexão e tente novamente.';
      print('⏱️ Timeout: $e');
      notifyListeners();
      return false;
    } on SocketException catch (e) {
      // Erro de conexão de rede
      _isLoading = false;
      _errorMessage = 'Sem conexão com o servidor. Verifique:\n'
          '• Se está conectado à internet\n'
          '• Se o servidor está rodando\n'
          '• Se a URL está correta ($baseUrlApi)';
      print('🌐 Erro de rede: $e');
      notifyListeners();
      return false;
    } catch (e) {
      // Erro de conexão ou outro erro inesperado
      _isLoading = false;
      _errorMessage = 'Erro inesperado: ${e.toString()}';
      print('❌ Erro inesperado: $e');
      notifyListeners();
      return false;
    }
  }  Future<void> logout() async {
    _user = null;
  _token = null;
    await _saveUserData();
    notifyListeners();
  }
}