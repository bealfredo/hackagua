import 'package:flutter/material.dart';
// (Adjust package name if needed)
import 'package:hackagua_flutter/models/alerta.dart';
import 'package:hackagua_flutter/models/enums.dart';
import 'package:hackagua_flutter/services/alerta_service.dart';

class AlertasScreen extends StatefulWidget {
  const AlertasScreen({Key? key}) : super(key: key);

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  final AlertaService _alertaService = AlertaService();
  late Future<List<Alerta>> _alertasFuturo;

  @override
  void initState() {
    super.initState();
    // Busca os alertas quando a tela é carregada
    _fetchAlertas();
  }

  void _fetchAlertas() {
    // Busca todos os alertas (não lidos e lidos)
    // O service poderia ter métodos separados, mas vamos filtrar aqui
    _alertasFuturo = _alertaService.getAlertasRecentes(limite: 10); // Busca mais para ter lidos
  }

  // Função para marcar alerta como lido (exemplo)
  Future<void> _marcarComoLido(int? alertaId) async {
    if (alertaId == null) return;
    // TODO: Chamar um método no AlertaService para atualizar o status na API
    print("Marcar alerta $alertaId como lido");
    // Após sucesso na API, recarregar a lista
    setState(() {
      _fetchAlertas(); // Recarrega os dados
    });
  }

   // Função para silenciar alerta (exemplo)
  Future<void> _silenciarAlerta(int? alertaId) async {
    if (alertaId == null) return;
    // TODO: Chamar um método no AlertaService para suspender o alerta na API
    print("Silenciar alerta $alertaId por 24h");
     // Após sucesso na API, recarregar a lista
    setState(() {
      _fetchAlertas(); // Recarrega os dados (ou remove localmente)
    });
  }


  @override
  Widget build(BuildContext context) {
    // Esta tela NÃO tem Scaffold, é controlada pelo MainScreen
    return SafeArea(
      child: FutureBuilder<List<Alerta>>(
        future: _alertasFuturo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Erro ao carregar alertas: ${snapshot.error}', textAlign: TextAlign.center),
                ));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Se não há dados ou a lista está vazia
             final List<Alerta> alertas = []; // Lista vazia
             final List<Alerta> naoLidos = [];
             final List<Alerta> anteriores = [];
            return _buildContent(context, alertas, naoLidos, anteriores);
          }

          // Filtra os alertas recebidos
          final List<Alerta> alertas = snapshot.data!;
          final List<Alerta> naoLidos = alertas.where((a) => !a.estaLido).toList();
          final List<Alerta> anteriores = alertas.where((a) => a.estaLido).toList();

          return _buildContent(context, alertas, naoLidos, anteriores);
        },
      ),
    );
  }

  /// Constrói o conteúdo principal da tela (cabeçalho, seções, listas)
  Widget _buildContent(BuildContext context, List<Alerta> todosAlertas, List<Alerta> naoLidos, List<Alerta> anteriores) {
     return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Cabeçalho "Alertas" (com contagem dinâmica)
                _buildHeader(naoLidos.length),

                // 2. Seção "Não lidos"
                _buildSectionHeader("Não lidos"),
                if (naoLidos.isEmpty)
                  _buildEmptyState("Nenhum alerta novo.")
                else
                  // Usa ListView.builder para o caso de ter múltiplos não lidos
                  ListView.builder(
                    shrinkWrap: true, // Para caber dentro do SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(), // Desabilita scroll da lista interna
                    itemCount: naoLidos.length,
                    itemBuilder: (context, index) {
                      return _buildNaoLidoCard(naoLidos[index]);
                    },
                  ),

                // 3. Seção "Anteriores"
                _buildSectionHeader("Anteriores"),
                 if (anteriores.isEmpty)
                  _buildEmptyState("Nenhum alerta anterior.")
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: anteriores.length,
                    itemBuilder: (context, index) {
                      // Usa o card genérico para alertas lidos
                      return _buildAlertaAnteriorCard(anteriores[index]);
                    },
                  ),


                // Espaço no final
                const SizedBox(height: 24),
              ],
            ),
          );
  }


  /// Constrói o cabeçalho principal da tela (com contagem dinâmica)
  Widget _buildHeader(int countNaoLidos) {
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
            countNaoLidos == 1 ? "1 novo" : "$countNaoLidos novos", // Texto dinâmico
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
  Widget _buildNaoLidoCard(Alerta alerta) {
    // Mapeia o TipoAlerta para a cor da tag/ícone "Atenção"
    final Color cardColor = Colors.yellow[50]!;
    final Color tagBgColor = Colors.orange[100]!;
    final Color tagFgColor = Colors.orange[800]!;
    final Color iconColor = Colors.orange[700]!;
    final IconData iconData = Icons.error_outline; // Ícone padrão para "Atenção"

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
                  Icon(iconData, color: iconColor, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alerta.titulo, // Dinâmico
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alerta.mensagem, // Dinâmico
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // A tag "Atenção" é fixa para não lidos neste design
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
                      onPressed: () => _marcarComoLido(alerta.id), // Chama a função
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
                      icon: const Icon(Icons.notifications_off_outlined, size: 16),
                      label: const Text(
                        "Silenciar 24h",
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () => _silenciarAlerta(alerta.id), // Chama a função
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

  /// Constrói um card de alerta padrão (para a seção "Anteriores")
  /// Este método agora determina o ícone, cor e tag baseado no `alerta.tipo`.
  Widget _buildAlertaAnteriorCard(Alerta alerta) {

    // Determina a aparência baseado no TipoAlerta (do UML)
    IconData iconData;
    Color iconColor;
    String tagText;
    Color tagBgColor;
    Color tagFgColor;

    switch (alerta.tipo) {
      case TipoAlerta.VAZAMENTO_DETECTADO:
      case TipoAlerta.USO_DE_AGUA_NOTURNO:
        iconData = Icons.warning_amber_rounded;
        iconColor = Colors.red[700]!;
        tagText = "Crítico";
        tagBgColor = Colors.red[50]!;
        tagFgColor = Colors.red[800]!;
        break;
      case TipoAlerta.BANHO_LONGO:
        iconData = Icons.info_outline;
        iconColor = Colors.blue[700]!;
        tagText = "Informação";
        tagBgColor = Colors.blue[50]!;
        tagFgColor = Colors.blue[800]!;
        break;
      case TipoAlerta.ALTO_CONSUMO:
        iconData = Icons.error_outline; // Mantendo o ícone de 'Atenção' se não for crítico/info
        iconColor = Colors.orange[700]!;
        tagText = "Atenção";
        tagBgColor = Colors.orange[100]!;
        tagFgColor = Colors.orange[800]!;
        break;
    }

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
              Icon(iconData, color: iconColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alerta.titulo, // Dinâmico
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alerta.mensagem, // Dinâmico
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

  /// Widget para exibir quando uma lista de alertas está vazia
  Widget _buildEmptyState(String message) {
     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
       child: Center(
         child: Text(
          message, 
          style: const TextStyle(color: Colors.grey, fontSize: 16),
          textAlign: TextAlign.center,
        )
       ),
     );
  }
}
