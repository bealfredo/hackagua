// lib/screens/detalhes_economia_screen.dart

import 'package:flutter/material.dart';
import '../models/desperdicio_agua.dart';
import '../services/calculo_economia_service.dart';

/// Tela que mostra detalhes de economia para um tipo específico de desperdício
class DetalhesEconomiaScreen extends StatelessWidget {
  final TipoDesperdicio tipoDesperdicio;
  final String tituloAlerta;
  final String descricaoAlerta;

  const DetalhesEconomiaScreen({
    Key? key,
    required this.tipoDesperdicio,
    required this.tituloAlerta,
    required this.descricaoAlerta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcular economias
    final deteccao = DeteccaoDesperdicio(
      tipo: tipoDesperdicio,
      dataHora: DateTime.now(),
    );
    
    final economia = CalculoEconomiaService.calcularEconomiaDesperdicio(deteccao);
    final economiaMensal = CalculoEconomiaService.calcularEconomiaMensal(
      tipoDesperdicio,
      diasPorMes: 30,
      ocorrenciasPorDia: 1,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('Detalhes de Economia'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card do Alerta
            _buildAlertCard(),

            // Seção: Como funciona o cálculo
            _buildSection(
              title: "Como calculamos a economia",
              icon: Icons.calculate_outlined,
              child: _buildCalculoExplicacao(),
            ),

            // Seção: Economia Detalhada
            _buildSection(
              title: "Impacto da economia",
              icon: Icons.insights,
              child: _buildEconomiaDetalhada(economia, economiaMensal),
            ),

            // Seção: Tarifas do Tocantins
            _buildSection(
              title: "Tarifas BRK Ambiental - Tocantins",
              icon: Icons.attach_money,
              child: _buildTabelaTarifas(),
            ),

            // Seção: Dicas Práticas
            _buildSection(
              title: "Como economizar",
              icon: Icons.eco,
              child: _buildDicasPraticas(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard() {
    IconData icon;
    Color iconColor;
    
    switch (tipoDesperdicio) {
      case TipoDesperdicio.banhoLongo:
        icon = Icons.shower;
        iconColor = Colors.blue[700]!;
        break;
      case TipoDesperdicio.vazamentoNoturno:
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.red[700]!;
        break;
      case TipoDesperdicio.torneiraPingando:
        icon = Icons.water_damage_outlined;
        iconColor = Colors.orange[700]!;
        break;
      default:
        icon = Icons.water_drop;
        iconColor = Colors.blue[700]!;
    }

    return Container(
      margin: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tituloAlerta,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tipoDesperdicio.nome,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            descricaoAlerta,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculoExplicacao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Usamos as tarifas oficiais da BRK Ambiental (Tocantins) para calcular quanto você economizaria:",
          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
        ),
        const SizedBox(height: 16),
        _buildCalculoStep("1", "Medimos o volume de água desperdiçado em litros"),
        _buildCalculoStep("2", "Convertemos para metros cúbicos (m³ = 1.000 litros)"),
        _buildCalculoStep("3", "Aplicamos a tarifa progressiva por faixa de consumo"),
        _buildCalculoStep("4", "Adicionamos 80% de taxa de esgoto"),
      ],
    );
  }

  Widget _buildCalculoStep(String numero, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                numero,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEconomiaDetalhada(
    ResultadoEconomia economia,
    ResultadoEconomiaMensal economiaMensal,
  ) {
    return Column(
      children: [
        _buildEconomiaCard(
          "Por Ocorrência",
          economia.litrosEconomizados,
          economia.valorEconomizadoReais,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildEconomiaCard(
          "Por Mês (30 dias)",
          economiaMensal.litrosEconomizadosMensal,
          economiaMensal.valorEconomizadoMensalReais,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildEconomiaCard(
          "Por Ano (365 dias)",
          economiaMensal.litrosEconomizadosMensal * 12,
          economiaMensal.economiaAnual,
          Colors.purple,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber[700], size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Corrija este desperdício e economize até ${CalculoEconomiaService.formatarReais(economiaMensal.economiaAnual)} por ano!",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[900],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEconomiaCard(
    String periodo,
    double litros,
    double reais,
    MaterialColor cor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cor[50]!, cor[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            periodo,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: cor[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CalculoEconomiaService.formatarLitros(litros),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cor[900],
                    ),
                  ),
                  Text(
                    "de água",
                    style: TextStyle(
                      fontSize: 12,
                      color: cor[700],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CalculoEconomiaService.formatarReais(reais),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cor[900],
                    ),
                  ),
                  Text(
                    "economizados",
                    style: TextStyle(
                      fontSize: 12,
                      color: cor[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabelaTarifas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tarifa progressiva residencial (2025):",
          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
        ),
        const SizedBox(height: 12),
        _buildTarifaRow("0 - 10 m³", "R\$ 4,97/m³", true),
        _buildTarifaRow("11 - 15 m³", "R\$ 9,49/m³", false),
        _buildTarifaRow("16 - 20 m³", "R\$ 10,97/m³", false),
        _buildTarifaRow("21 - 30 m³", "R\$ 11,72/m³", false),
        _buildTarifaRow("31 - 40 m³", "R\$ 12,10/m³", false),
        _buildTarifaRow("Acima de 40 m³", "R\$ 12,80/m³", false),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Taxa de esgoto: 80% do valor da água\n1 m³ = 1.000 litros",
                  style: TextStyle(fontSize: 13, color: Colors.blue[900]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTarifaRow(String faixa, String valor, bool isFirst) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isFirst ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFirst ? Colors.green[200]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            faixa,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isFirst ? Colors.green[800] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDicasPraticas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.green[700], size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "Dica principal",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                tipoDesperdicio.dicaEconomia,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green[800],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildDicaItem("Instale arejadores nas torneiras (economia de até 60%)"),
        _buildDicaItem("Use bacias sanitárias com duplo acionamento (3/6L)"),
        _buildDicaItem("Coloque um balde no chuveiro para reutilizar água"),
        _buildDicaItem("Conserte vazamentos imediatamente"),
      ],
    );
  }

  Widget _buildDicaItem(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
