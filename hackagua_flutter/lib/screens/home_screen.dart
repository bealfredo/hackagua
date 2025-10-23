import 'package:flutter/material.dart';
// Importa os pacotes de formatação de data
import 'package:intl/intl.dart' as intl;

// Esta tela precisa ser um StatefulWidget para guardar
// o item que está selecionado na barra de navegação inferior (BottomNavigationBar).
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Guarda o índice do item selecionado na barra inferior.
  // 0 = Início, 1 = Histórico, 2 = Alertas, 3 = Configurar
  int _selectedIndex = 0;

  // String para guardar a data formatada
  String _formattedDate = '';

  @override
  void initState() {
    super.initState();
    // Inicializa a formatação de data para Português (Brasil)
    // e define a data assim que a tela é carregada.
    _initializeDate();
  }

  void _initializeDate() {
    // Formata a data atual (já passando a locale 'pt_BR' para o DateFormat)
    // 'EEEE' = dia da semana por extenso (ex: quarta-feira)
    // 'd' = dia do mês
    // 'MMMM' = mês por extenso (ex: outubro)
    var formatter = intl.DateFormat('EEEE, d \'de\' MMMM', 'pt_BR');
    String date = formatter.format(DateTime.now());

    // Atualiza o estado para exibir a data na tela
    setState(() {
      // Deixa a primeira letra maiúscula (ex: "Quarta-feira...")
      _formattedDate = date[0].toUpperCase() + date.substring(1);
    });
  }

  // Método chamado quando um item da barra inferior é tocado
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aqui você pode adicionar lógica para trocar de tela
    // ou atualizar o corpo da tela com base no índice.
    // Por enquanto, apenas mudamos o item selecionado.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cor de fundo da tela (um cinza bem claro, como na imagem)
      backgroundColor: const Color(0xFFF7F9FA),

      // --- Barra de Navegação Inferior ---
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Ícone quando ativo
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Configurar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[700], // Cor do item ativo
        unselectedItemColor: Colors.grey[600], // Cor dos itens inativos
        onTap: _onItemTapped, // Função chamada ao tocar
        type: BottomNavigationBarType
            .fixed, // Garante que todos os 4 itens apareçam
        backgroundColor: Colors.white, // Fundo da barra
        elevation: 2.0, // Sombra
      ),

      // --- Corpo da Tela ---
      body: SafeArea(
        // Permite rolar a tela se o conteúdo for maior
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // Alinha os filhos à esquerda
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Cabeçalho (Logo, Data, Status)
                _buildHeader(),
                const SizedBox(height: 16),

                // 2. Card "Simular banho"
                _buildSimularBanhoCard(),
                const SizedBox(height: 16),

                // 3. Card "Hoje" (Meta diária)
                _buildHojeCard(),
                const SizedBox(height: 24),

                // 4. Seção "Alertas recentes"
                _buildAlertasSection(),
                const SizedBox(height: 24),

                // 5. Botões "Pausar" e "Ver histórico"
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets Auxiliares ---

  /// Constrói o cabeçalho com Logo, Data e Status
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Lado Esquerdo: Logo e Data
        Row(
          children: [
            Icon(Icons.water_drop_outlined, color: Colors.blue[700], size: 30),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Escuta d'Água",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                Text(
                  _formattedDate, // Usa a data formatada
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),

        // Lado Direito: Status "Monitorando"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.play_circle_fill, color: Colors.green[700], size: 16),
              const SizedBox(width: 6),
              Text(
                "Monitorando em casa",
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Constrói o card "Simular banho"
  Widget _buildSimularBanhoCard() {
    // NOTA: Para a borda tracejada (dashed) exata da imagem,
    // é preciso um pacote (ex: 'dotted_border').
    // Para simplificar, usamos um 'OutlinedButton' padrão.
    return OutlinedButton.icon(
      icon: const Icon(Icons.sync, color: Color(0xFF1D2939)),
      label: const Text(
        "Simular banho",
        style: TextStyle(
          color: Color(0xFF1D2939),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      onPressed: () {
        // Lógica para simular banho
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.grey[300]!, width: 1.5),
      ),
    );
  }

  /// Constrói o card "Hoje" com a meta diária
  Widget _buildHojeCard() {
    double progresso = 0.0; // 0.0 = 0%, 1.0 = 100%
    int minutosUsados = 0;
    int metaDiaria = 30;

    return Card(
      elevation: 0.5, // Sombra sutil
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
            // Linha 1: Título e Minutos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Text(
                      "Hoje",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                Text(
                  "$minutosUsados min",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Linha 2: Meta
            Text(
              "Meta diária: $metaDiaria minutos",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Linha 3: Barra de Progresso
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progresso,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600]!),
              ),
            ),
            const SizedBox(height: 8),

            // Linha 4: % da meta
            Text(
              "${(progresso * 100).toInt()}% da meta alcançada",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a seção "Alertas recentes"
  Widget _buildAlertasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da Seção
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Text(
                  "Alertas recentes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // Lógica para ver todos os alertas
              },
              child: Row(
                children: [
                  Text("Ver todos", style: TextStyle(color: Colors.blue[700])),
                  Icon(Icons.chevron_right, color: Colors.blue[700], size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Card de Alerta
        Card(
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Constrói os dois botões de ação ("Pausar" e "Ver histórico")
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Botão 1: Pausar
        Expanded(
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
            // InkWell permite que o Card seja clicável e tenha o efeito "ripple"
            child: InkWell(
              onTap: () {
                // Lógica para pausar
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.pause, color: Colors.grey[700], size: 28),
                    const SizedBox(height: 8),
                    Text(
                      "Pausar",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Botão 2: Ver histórico
        Expanded(
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
            child: InkWell(
              onTap: () {
                // Lógica para ver histórico
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.history, color: Colors.grey[700], size: 28),
                    const SizedBox(height: 8),
                    Text(
                      "Ver histórico",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
