// lib/widgets/dashboard/estatisticas_card.dart

import 'package:flutter/material.dart';

class EstatisticasCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final MaterialColor cor;
  final double? tendencia; // Positivo = crescimento, Negativo = queda

  const EstatisticasCard({
    Key? key,
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.cor,
    this.tendencia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cor[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icone,
              color: cor[700],
              size: 24,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            titulo,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 6),
          
          Text(
            valor,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          
          if (tendencia != null) ...[
            const SizedBox(height: 8),
            _buildTendencia(),
          ],
        ],
      ),
    );
  }

  Widget _buildTendencia() {
    final isPositivo = tendencia! > 0;
    final corTendencia = isPositivo ? Colors.green : Colors.red;
    final iconeTendencia = isPositivo ? Icons.trending_up : Icons.trending_down;
    
    return Row(
      children: [
        Icon(
          iconeTendencia,
          color: corTendencia,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '${tendencia!.abs().toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: corTendencia,
          ),
        ),
      ],
    );
  }
}
