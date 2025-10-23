import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(title: const Text('Alertas')),
      body: const Center(
        child: Text(
          'Seus alertas aparecerão aqui',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
