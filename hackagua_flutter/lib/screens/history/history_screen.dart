import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(title: const Text('Histórico')),
      body: const Center(
        child: Text(
          'Seu histórico aparecerá aqui',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
