import 'package:flutter/material.dart';

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
              
              // Card "Crítico"
              _buildAlertaAnteriorCard(
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.red[700]!,
                title: "Água detectada à noite",
                subtitle: "Som de água detectado às 2:30 da madrugada. Verifique possível vazamento.",
                tagText: "Crítico",
                tagBgColor: Colors.red[50]!,
                tagFgColor: Colors.red[800]!,
              ),
              
              // Card "Informação"
              _buildAlertaAnteriorCard(
                icon: Icons.info_outline,
                iconColor: Colors.blue[700]!,
                title: "Banho longo detectado",
                subtitle: "Seu último banho durou 9 minutos. Considere reduzir o tempo.",
                tagText: "Informação",
                tagBgColor: Colors.blue[50]!,
                tagFgColor: Colors.blue[800]!,
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
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
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
                  Icon(Icons.error_outline, color: Colors.orange[700], size: 28),
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
                  OutlinedButton.icon(
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text("Marcar como visto"),
                    onPressed: () { /* Lógica para marcar como visto */ },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[800], padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    icon: const Icon(Icons.notifications_off_outlined, size: 18),
                    label: const Text("Silenciar por 24h"),
                    onPressed: () { /* Lógica para silenciar */ },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
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

  /// Constrói um card de alerta padrão (para a seção "Anteriores")
  Widget _buildAlertaAnteriorCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String tagText,
    required Color tagBgColor,
    required Color tagFgColor,
  }) {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
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
}