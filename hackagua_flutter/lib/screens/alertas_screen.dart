import 'package:flutter/material.dart';

import '../models/desperdicio_agua.dart';
import '../services/calculo_economia_service.dart';
import 'detalhes_economia_screen.dart';

class AlertasScreen extends StatelessWidget {
  const AlertasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cor de fundo padrão para a tela
    const Color backgroundColor = Color(0xFFF7F9FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      // SafeArea para evitar que o conteúdo fique atrás da barra de status
      body: SafeArea(
        // SingleChildScrollView permite que a tela role
        child: SingleChildScrollView(
          child: Column(
            // Alinha todo o conteúdo à esquerda
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabeçalho "Alertas"
              _buildHeader(),

              // 2. Seção "Não lidos"
              _buildSectionHeader("Não lidos"),
              _buildNaoLidoCard(),

              // 3. Seção "Anteriores"
              _buildSectionHeader("Anteriores"),

              // Card "Crítico" - Vazamento Noturno
              _buildAlertaComEconomiaCard(
                context,
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.red[700]!,
                title: "Água detectada à noite",
                subtitle:
                    "Som de água detectado às 2:30 da madrugada. Verifique possível vazamento.",
                tagText: "Crítico",
                tagBgColor: Colors.red[50]!,
                tagFgColor: Colors.red[800]!,
                tipoDesperdicio: TipoDesperdicio.vazamentoNoturno,
              ),

              // Card "Informação" - Banho Longo
              _buildAlertaComEconomiaCard(
                context,
                icon: Icons.info_outline,
                iconColor: Colors.blue[700]!,
                title: "Banho longo detectado",
                subtitle:
                    "Seu último banho durou 15 minutos. Considere reduzir o tempo para 5 minutos.",
                tagText: "Informação",
                tagBgColor: Colors.blue[50]!,
                tagFgColor: Colors.blue[800]!,
                tipoDesperdicio: TipoDesperdicio.banhoLongo,
              ),

              // Espaço no final
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o cabeçalho principal da tela
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Alertas",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "1 novo",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// Constrói o título de uma seção (ex: "Não lidos", "Anteriores")
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  /// Constrói o card especial "Não lido" com botões de ação
  Widget _buildNaoLidoCard() {
    // Cor de fundo especial para o card "Não lido"
    final Color cardColor = Colors.yellow[50]!;
    final Color tagBgColor = Colors.orange[100]!;
    final Color tagFgColor = Colors.orange[800]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 0.5,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.orange[100]!, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // --- Conteúdo principal do card ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.orange[700],
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Alto consumo hoje",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Você já usou 18 minutos de água hoje, 60% da sua meta.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildTag("Atenção", tagBgColor, tagFgColor),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 4),

              // --- Botões de Ação ---
              Row(
                children: [
                  Flexible(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text(
                        "Marcar visto",
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        /* Lógica para marcar como visto */
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        side: BorderSide(color: Colors.grey[400]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: TextButton.icon(
                      icon: const Icon(
                        Icons.notifications_off_outlined,
                        size: 16,
                      ),
                      label: const Text(
                        "Silenciar 24h",
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        /* Lógica para silenciar */
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget auxiliar para criar as "tags" (ex: "Crítico", "Atenção")
  Widget _buildTag(String text, Color bgColor, Color fgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fgColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Constrói um card de alerta com cálculo de economia de água
  Widget _buildAlertaComEconomiaCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String tagText,
    required Color tagBgColor,
    required Color tagFgColor,
    required TipoDesperdicio tipoDesperdicio,
  }) {
    // Criar uma detecção de desperdício
    final deteccao = DeteccaoDesperdicio(
      tipo: tipoDesperdicio,
      dataHora: DateTime.now(),
    );

    // Calcular economia
    final economia = CalculoEconomiaService.calcularEconomiaDesperdicio(
      deteccao,
    );
    final economiaMensal = CalculoEconomiaService.calcularEconomiaMensal(
      tipoDesperdicio,
      diasPorMes: 30,
      ocorrenciasPorDia: 1,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 0.5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho do alerta
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: iconColor, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildTag(tagText, tagBgColor, tagFgColor),
                ],
              ),

              const SizedBox(height: 16),
              Divider(color: Colors.grey[300], height: 1),
              const SizedBox(height: 16),

              // Seção de Economia
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.water_drop,
                          color: Colors.green[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "💰 Economia Potencial",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Economia por ocorrência
                    _buildEconomiaItem(
                      "Por ocorrência:",
                      "${CalculoEconomiaService.formatarLitros(economia.litrosEconomizados)} • ${CalculoEconomiaService.formatarReais(economia.valorEconomizadoReais)}",
                      Colors.green[700]!,
                    ),
                    const SizedBox(height: 8),

                    // Economia mensal
                    _buildEconomiaItem(
                      "Economia mensal:",
                      "${CalculoEconomiaService.formatarLitros(economiaMensal.litrosEconomizadosMensal)} • ${CalculoEconomiaService.formatarReais(economiaMensal.valorEconomizadoMensalReais)}",
                      Colors.green[800]!,
                    ),
                    const SizedBox(height: 8),

                    // Economia anual
                    _buildEconomiaItem(
                      "Economia anual:",
                      CalculoEconomiaService.formatarReais(
                        economiaMensal.economiaAnual,
                      ),
                      Colors.green[900]!,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Dica de economia
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "💡 Dica para economizar",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tipoDesperdicio.dicaEconomia,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Botão para ver detalhes
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesEconomiaScreen(
                          tipoDesperdicio: tipoDesperdicio,
                          tituloAlerta: title,
                          descricaoAlerta: subtitle,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text("Ver detalhes completos"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget auxiliar para exibir um item de economia
  Widget _buildEconomiaItem(String label, String valor, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label, 
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          valor,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
