import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(title: const Text('Configurar')),
      body: const Center(
        child: Text(
          'Configurações do aplicativo',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
