// lib/widgets/dashboard/meta_diaria_card.dart

import 'package:flutter/material.dart';

class MetaDiariaCard extends StatelessWidget {
  final double consumoAtual;
  final double metaDiaria;

  const MetaDiariaCard({
    Key? key,
    required this.consumoAtual,
    required this.metaDiaria,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restante = (metaDiaria - consumoAtual).clamp(0, double.infinity);
    final percentualUsado = (consumoAtual / metaDiaria * 100).clamp(0, 100);
    
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.flag_outlined,
                  color: Colors.blue[700],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meta Diária',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Acompanhe seu progresso',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn(
                'Usado',
                '${consumoAtual.toStringAsFixed(0)} L',
                Colors.blue,
                Icons.water_drop,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              _buildMetricColumn(
                'Restante',
                '${restante.toStringAsFixed(0)} L',
                Colors.green,
                Icons.eco,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              _buildMetricColumn(
                'Meta',
                '${metaDiaria.toStringAsFixed(0)} L',
                Colors.orange,
                Icons.flag,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: percentualUsado < 100 ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  percentualUsado < 100 ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: percentualUsado < 100 ? Colors.green[700] : Colors.red[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    percentualUsado < 100
                        ? 'Você ainda tem ${restante.toStringAsFixed(0)} litros disponíveis hoje!'
                        : 'Atenção! Você excedeu sua meta em ${(consumoAtual - metaDiaria).toStringAsFixed(0)} litros.',
                    style: TextStyle(
                      fontSize: 13,
                      color: percentualUsado < 100 ? Colors.green[900] : Colors.red[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String valor, MaterialColor cor, IconData icone) {
    return Column(
      children: [
        Icon(icone, color: cor[700], size: 20),
        const SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: cor[800],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
