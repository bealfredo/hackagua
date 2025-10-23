// lib/widgets/dashboard/grafico_semanal_card.dart

import 'package:flutter/material.dart';

class GraficoSemanalCard extends StatelessWidget {
  final List<double> dadosSemanal;
  final double metaDiaria;

  const GraficoSemanalCard({
    Key? key,
    required this.dadosSemanal,
    required this.metaDiaria,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    final maxValor = dadosSemanal.reduce((a, b) => a > b ? a : b);
    
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consumo Semanal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Últimos 7 dias',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bar_chart,
                  color: Colors.purple[700],
                  size: 24,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Gráfico de barras
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                dadosSemanal.length,
                (index) => _buildBarra(
                  dias[index],
                  dadosSemanal[index],
                  maxValor,
                  dadosSemanal[index] <= metaDiaria,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Legenda
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegenda(Colors.green[400]!, 'Dentro da meta'),
              const SizedBox(width: 20),
              _buildLegenda(Colors.red[400]!, 'Acima da meta'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarra(String dia, double valor, double maxValor, bool dentroDaMeta) {
    final alturaMaxima = 140.0;
    final altura = (valor / maxValor * alturaMaxima).clamp(20.0, alturaMaxima);
    final cor = dentroDaMeta ? Colors.green[400]! : Colors.red[400]!;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${valor.toInt()}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: altura,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cor.withOpacity(0.7), cor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          dia,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLegenda(Color cor, String texto) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
