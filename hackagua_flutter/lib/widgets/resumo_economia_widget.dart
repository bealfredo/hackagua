// lib/widgets/resumo_economia_widget.dart

import 'package:flutter/material.dart';
import '../models/desperdicio_agua.dart';
import '../services/calculo_economia_service.dart';

/// Widget que exibe um resumo da economia potencial do usuário
class ResumoEconomiaWidget extends StatelessWidget {
  final List<DeteccaoDesperdicio> deteccoes;

  const ResumoEconomiaWidget({
    Key? key,
    required this.deteccoes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (deteccoes.isEmpty) {
      return _buildSemDeteccoes();
    }

    // Calcular totais
    double totalLitros = 0;
    double totalReais = 0;

    for (var deteccao in deteccoes) {
      final resultado = CalculoEconomiaService.calcularEconomiaDesperdicio(deteccao);
      totalLitros += resultado.litrosEconomizados;
      totalReais += resultado.valorEconomizadoReais;
    }

    // Calcular economia mensal estimada (assumindo padrão diário)
    double economiaMensalReais = totalReais * 30;
    double economiaMensalLitros = totalLitros * 30;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[900]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
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
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Potencial de Economia",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Baseado em seus desperdícios",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Economia hoje
            _buildEconomiaCard(
              label: "Detectado hoje",
              litros: totalLitros,
              reais: totalReais,
              icon: Icons.today,
            ),

            const SizedBox(height: 12),

            // Economia mensal projetada
            _buildEconomiaCard(
              label: "Projeção mensal",
              litros: economiaMensalLitros,
              reais: economiaMensalReais,
              icon: Icons.calendar_month,
              isProjection: true,
            ),

            const SizedBox(height: 16),

            // Estatísticas de desperdícios
            _buildDeteccoesSummary(),

            const SizedBox(height: 16),

            // Botão de ação
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navegar para tela de alertas ou detalhes
                },
                icon: const Icon(Icons.tips_and_updates, size: 20),
                label: const Text("Ver dicas de economia"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[900],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemDeteccoes() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Parabéns!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Nenhum desperdício detectado hoje.\nVocê está usando água de forma consciente!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEconomiaCard({
    required String label,
    required double litros,
    required double reais,
    required IconData icon,
    bool isProjection = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isProjection ? 0.15 : 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      CalculoEconomiaService.formatarLitros(litros),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      CalculoEconomiaService.formatarReais(reais),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeteccoesSummary() {
    // Contar desperdícios por tipo
    Map<TipoDesperdicio, int> contagem = {};
    for (var deteccao in deteccoes) {
      contagem[deteccao.tipo] = (contagem[deteccao.tipo] ?? 0) + 1;
    }

    // Pegar os 3 mais frequentes
    var topTres = contagem.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    topTres = topTres.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Principais desperdícios:",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...topTres.map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.key.nome,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${entry.value}x",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

/// Widget compacto para mostrar economia em cards menores
class EconomiaCompactaWidget extends StatelessWidget {
  final TipoDesperdicio tipoDesperdicio;
  final VoidCallback? onTap;

  const EconomiaCompactaWidget({
    Key? key,
    required this.tipoDesperdicio,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final economiaMensal = CalculoEconomiaService.calcularEconomiaMensal(
      tipoDesperdicio,
      diasPorMes: 30,
      ocorrenciasPorDia: 1,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tipoDesperdicio.nome,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Economia/mês:",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[800],
                    ),
                  ),
                  Text(
                    CalculoEconomiaService.formatarReais(
                      economiaMensal.valorEconomizadoMensalReais,
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
