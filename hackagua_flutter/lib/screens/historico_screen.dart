import 'package:flutter/material.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({Key? key}) : super(key: key);

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  // Lista para o toggle de "7 dias" / "30 dias"
  // [true, false] = "7 dias" selecionado
  // [false, true] = "30 dias" selecionado
  List<bool> _diasSelecionados = [true, false];

  // Índice para os filtros de eventos ("Todos", "Banho", etc.)
  int _filtroEventoSelecionado = 0;
  final List<String> _filtrosEvento = [
    "Todos",
    "Banho",
    "Torneira",
    "Descarga",
    "Vazamento",
  ];

  @override
  Widget build(BuildContext context) {
    // SafeArea garante que o conteúdo não fique sob as barras do sistema
    return SafeArea(
      // Permite rolar a tela
      child: SingleChildScrollView(
        // Cor de fundo clara, como na HomeScreen
        child: Container(
          color: const Color(0xFFF7F9FA),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Cabeçalho "Histórico"
              _buildHeader(),

              // 2. Card "Consumo por dia"
              _buildConsumoCard(),

              // 3. Seção "Eventos detectados"
              _buildEventosSection(),

              // Espaçamento extra no final da rolagem
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o cabeçalho
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: Colors.blue[700],
            size: 28,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Histórico",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              Text(
                "Acompanhe seu consumo de água",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Constrói o card de "Consumo por dia" com o gráfico
  Widget _buildConsumoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            children: [
              // Linha do Título e Toggle "7 dias / 30 dias"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Consumo por dia",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  ToggleButtons(
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("7 dias"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("30 dias"),
                      ),
                    ],
                    isSelected: _diasSelecionados,
                    onPressed: (int index) {
                      setState(() {
                        // Lógica para garantir que apenas um seja selecionado
                        _diasSelecionados = [false, false];
                        _diasSelecionados[index] = true;
                        // TODO: Recarregar os dados do gráfico (7 ou 30 dias)
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    selectedColor: Colors.white,
                    color: Colors.grey[700],
                    fillColor: Colors.blue[700],
                    borderColor: Colors.grey[300],
                    selectedBorderColor: Colors.blue[700],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- O Gráfico (placeholder simples) ---
              Container(
                height: 200,
                child: _buildGraficoConsumo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói a seção "Eventos detectados"
  Widget _buildEventosSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Eventos detectados",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          // --- Filtros de Eventos ---
          Container(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filtrosEvento.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ChoiceChip(
                  label: Text(_filtrosEvento[index]),
                  selected: _filtroEventoSelecionado == index,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _filtroEventoSelecionado = index;
                        // TODO: Recarregar a lista de eventos com o filtro
                      }
                    });
                  },
                  backgroundColor: Colors.grey[100],
                  selectedColor: Colors.blue[50],
                  labelStyle: TextStyle(
                    color: _filtroEventoSelecionado == index
                        ? Colors.blue[800]
                        : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: _filtroEventoSelecionado == index
                          ? Colors.blue[700]!
                          : Colors.grey[300]!,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // --- Item de Evento ---
          _buildItemEvento(),
          // Adicione mais _buildItemEvento() aqui conforme necessário
        ],
      ),
    );
  }

  /// Constrói um único item da lista de eventos
  Widget _buildItemEvento() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Icon(Icons.water_drop_outlined, color: Colors.blue[700]),
        ),
        title: Text(
          "Torneira aberta",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Text(
          "12:22 • 2min 0s",
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.circle, color: Colors.orange[400], size: 12),
        onTap: () {
          // Lógica para ver detalhes do evento
        },
      ),
    );
  }

  /// Constrói um gráfico de barras simples (placeholder) usando widgets padrão.
  Widget _buildGraficoConsumo() {
    // Valores de exemplo (máximo 20)
    final values = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 19.5];
    final labels = ['16/10', '17/10', '18/10', '19/10', '20/10', '21/10', '22/10'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (i) => _makeBar(values[i])),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              labels.length,
              (i) => Expanded(
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeBar(double value) {
    // Normaliza para 0..1 com base em max 20
    final fraction = (value / 20).clamp(0.0, 1.0);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 140 * fraction + 4, // base height scaled
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
