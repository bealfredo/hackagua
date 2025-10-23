// lib/widgets/dashboard/economia_potencial_card.dart

import 'package:flutter/material.dart';
import '../../models/desperdicio_agua.dart';
import '../../services/calculo_economia_service.dart';

class EconomiaPotencialCard extends StatelessWidget {
  final List<DeteccaoDesperdicio> deteccoes;

  const EconomiaPotencialCard({
    Key? key,
    required this.deteccoes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcular economia total
    double totalLitros = 0;
    double totalReais = 0;
    
    for (var deteccao in deteccoes) {
      final resultado = CalculoEconomiaService.calcularEconomiaDesperdicio(deteccao);
      totalLitros += resultado.litrosEconomizados;
      totalReais += resultado.valorEconomizadoReais;
    }
    
    final economiaMensal = totalReais * 30;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.savings_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Economia Potencial',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Se corrigir os desperdícios',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: _buildMetrica(
                  'Hoje',
                  CalculoEconomiaService.formatarReais(totalReais),
                  '${totalLitros.toStringAsFixed(0)} L',
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildMetrica(
                  'Mensal',
                  CalculoEconomiaService.formatarReais(economiaMensal),
                  '${(totalLitros * 30).toStringAsFixed(0)} L',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Corrija ${deteccoes.length} desperdício${deteccoes.length > 1 ? 's' : ''} detectado${deteccoes.length > 1 ? 's' : ''} para economizar!',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
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

  Widget _buildMetrica(String label, String valorPrincipal, String valorSecundario) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valorPrincipal,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          valorSecundario,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
