// lib/widgets/dashboard/alertas_recentes_card.dart

import 'package:flutter/material.dart';
import '../../models/desperdicio_agua.dart';

class AlertasRecentesCard extends StatelessWidget {
  final List<DeteccaoDesperdicio> deteccoes;
  final VoidCallback? onVerTodos;

  const AlertasRecentesCard({
    Key? key,
    required this.deteccoes,
    this.onVerTodos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    'Alertas Recentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Últimas detecções',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              if (onVerTodos != null)
                TextButton(
                  onPressed: onVerTodos,
                  child: const Text('Ver todos'),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (deteccoes.isEmpty)
            _buildVazio()
          else
            ...deteccoes.take(3).map((deteccao) => _buildAlertaItem(deteccao)),
        ],
      ),
    );
  }

  Widget _buildVazio() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green[400],
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhum alerta hoje!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Você está usando água conscientemente',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertaItem(DeteccaoDesperdicio deteccao) {
    final cor = _getCorAlerta(deteccao.tipo);
    final icone = _getIconeAlerta(deteccao.tipo);
    final tempoAtras = _getTempoAtras(deteccao.dataHora);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icone,
              color: cor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deteccao.tipo.nome,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${deteccao.litrosDesperdicados.toStringAsFixed(0)} litros desperdiçados',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            tempoAtras,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCorAlerta(TipoDesperdicio tipo) {
    switch (tipo) {
      case TipoDesperdicio.vazamentoNoturno:
        return Colors.red;
      case TipoDesperdicio.banhoLongo:
        return Colors.orange;
      case TipoDesperdicio.torneiraPingando:
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }

  IconData _getIconeAlerta(TipoDesperdicio tipo) {
    switch (tipo) {
      case TipoDesperdicio.vazamentoNoturno:
        return Icons.warning_amber_rounded;
      case TipoDesperdicio.banhoLongo:
        return Icons.shower;
      case TipoDesperdicio.torneiraPingando:
        return Icons.water_damage_outlined;
      case TipoDesperdicio.torneiraAberta:
        return Icons.water_drop;
      default:
        return Icons.info_outline;
    }
  }

  String _getTempoAtras(DateTime dataHora) {
    final diferenca = DateTime.now().difference(dataHora);
    
    if (diferenca.inMinutes < 60) {
      return '${diferenca.inMinutes}min';
    } else if (diferenca.inHours < 24) {
      return '${diferenca.inHours}h';
    } else {
      return '${diferenca.inDays}d';
    }
  }
}
