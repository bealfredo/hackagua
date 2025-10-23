// lib/screens/config_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackagua_flutter/models/configuracoes.dart';
import 'package:hackagua_flutter/services/config_service.dart'; // Para o campo de texto de números

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  // Instância do nosso serviço
  final ConfigService _configService = ConfigService();

  // Variáveis de estado para guardar os valores ATUAIS da tela
  // Elas começam como 'null' e são preenchidas ao carregar
  bool _isLoading = true;
  String? _endereco;
  int? _raio;
  double? _sensibilidade;
  int? _metaDiaria;
  bool? _processarSoEmCasa;
  bool? _descartarAudio;

  // Controlador para o campo de texto da "Meta"
  late TextEditingController _metaController;

  @override
  void initState() {
    super.initState();
    _metaController = TextEditingController();
    // Inicia o carregamento dos dados da API
    _carregarConfiguracoes();
  }

  @override
  void dispose() {
    _metaController.dispose(); // Limpa o controlador
    super.dispose();
  }

  /// MÉTODO DE CARREGAMENTO
  /// Busca os dados da API e atualiza o estado da tela
  Future<void> _carregarConfiguracoes() async {
    try {
      final config = await _configService.getConfiguracoes();
      // Quando os dados chegam, atualiza as variáveis de estado
      setState(() {
        _endereco = config.geofenceEndereco;
        _raio = config.geofenceRaio;
        _sensibilidade = config.sensibilidade;
        _metaDiaria = config.metaDiaria;
        _processarSoEmCasa = config.processarSoEmCasa;
        _descartarAudio = config.descartarAudio;

        _metaController.text = config.metaDiaria
            .toString(); // Atualiza o campo de texto

        _isLoading = false; // Para o "loading"
      });
    } catch (e) {
      // Tratar erro (ex: mostrar um SnackBar)
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        // Verifica se o widget ainda está na tela
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar configurações: $e')),
        );
      }
    }
  }

  /// MÉTODO DE SALVAMENTO
  /// Pega os valores ATUAIS do estado e envia para a API
  Future<void> _salvarConfiguracoes() async {
    // Garante que todos os dados foram carregados antes de tentar salvar
    if (_isLoading ||
        _sensibilidade == null ||
        _metaDiaria == null ||
        _processarSoEmCasa == null ||
        _descartarAudio == null ||
        _endereco == null ||
        _raio == null) {
      return;
    }

    // 1. Cria um novo objeto 'Configuracoes' com os valores do estado
    final configAtual = Configuracoes(
      geofenceEndereco: _endereco!,
      geofenceRaio: _raio!,
      sensibilidade: _sensibilidade!,
      metaDiaria: _metaDiaria!,
      processarSoEmCasa: _processarSoEmCasa!,
      descartarAudio: _descartarAudio!,
    );

    // 2. Envia para o serviço
    try {
      await _configService.salvarConfiguracoes(configAtual);
      // Mostra um feedback de sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configuração salva!'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // Mostra um feedback de erro
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // SafeArea garante que o conteúdo não fique sob a barra de status
    return SafeArea(
      // Se _isLoading for true, mostra um 'loading'
      // Senão, mostra o conteúdo
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildGeofenceCard(),
                  _buildSensibilidadeCard(),
                  _buildMetaDiariaCard(),
                  _buildPrivacidadeCard(),
                  _buildSobreCard(),
                  // Espaçamento extra no final para não colar na barra de navegação
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  // --- Widgets Auxiliares (divididos para clareza) ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Configurações",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Personalize o funcionamento do app",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildGeofenceCard() {
    return _buildConfigCard(
      icon: Icons.location_on_outlined,
      iconColor: Colors.green[700]!,
      title: "Minha casa (Geofence)",
      subtitle: "O app monitora apenas quando você está nesta área",
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity, // Garante que o container ocupe a largura
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _endereco ?? "Carregando...",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Raio: $_raio m",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Usamos InkWell dentro do Card para um ListTile sem padding extra
          InkWell(
            onTap: () {
              // TODO: Lógica para abrir tela de mapa
            },
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(Icons.map_outlined, color: Colors.black54),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Alterar área",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensibilidadeCard() {
    // Mapeia o valor do slider (0.0-2.0) para um texto
    String getSensibilidadeTexto(double valor) {
      if (valor < 0.5) return "Muito Baixa";
      if (valor < 1.0) return "Baixa";
      if (valor < 1.5) return "Média";
      return "Alta";
    }

    return _buildConfigCard(
      icon: Icons.sensors,
      iconColor: Colors.blue[700]!,
      title: "Sensibilidade de detecção",
      subtitle: "Detecta apenas sons muito claros",
      child: Column(
        children: [
          Slider(
            value: _sensibilidade ?? 1.0, // Valor atual do estado
            min: 0.0,
            max: 2.0,
            divisions: 4, // 0.0, 0.5, 1.0, 1.5, 2.0
            label: getSensibilidadeTexto(_sensibilidade ?? 1.0),
            onChanged: (double newValue) {
              // 1. Atualiza o estado da tela (UI)
              setState(() {
                _sensibilidade = newValue;
              });
            },
            // 2. Salva na API quando o usuário solta o slider
            onChangeEnd: (double newValue) {
              _salvarConfiguracoes();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ), // Ajuste para alinhar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Baixa", style: TextStyle(color: Colors.grey[600])),
                Text(
                  getSensibilidadeTexto(_sensibilidade ?? 1.0),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text("Alta", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaDiariaCard() {
    return _buildConfigCard(
      icon: Icons.track_changes_outlined,
      iconColor: Colors.orange[700]!,
      title: "Meta diária",
      subtitle: "Quanto tempo de água você quer usar por dia?",
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: _metaController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // Teclado apenas para números
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              // 1. Salva na API quando o usuário confirma (ex: aperta "Done")
              onEditingComplete: () {
                setState(() {
                  _metaDiaria =
                      int.tryParse(_metaController.text) ?? _metaDiaria;
                });
                _salvarConfiguracoes();
                FocusScope.of(context).unfocus(); // Esconde o teclado
              },
            ),
          ),
          const SizedBox(width: 16),
          Text(
            "minutos",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacidadeCard() {
    return _buildConfigCard(
      icon: Icons.shield_outlined,
      iconColor: Colors.green[700]!,
      title: "Privacidade",
      subtitle: "Controle como seus dados são processados",
      child: Column(
        children: [
          SwitchListTile(
            title: const Text(
              "Processar só em casa",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              "Monitoramento ativo apenas dentro da geofence",
            ),
            value: _processarSoEmCasa ?? false,
            onChanged: (bool newValue) {
              // 1. Atualiza o estado da tela
              setState(() {
                _processarSoEmCasa = newValue;
              });
              // 2. Salva na API imediatamente
              _salvarConfiguracoes();
            },
            contentPadding: EdgeInsets.zero, // Remove padding padrão
          ),
          const Divider(),
          SwitchListTile(
            title: const Text(
              "Descartar áudio imediatamente",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text("Nenhum áudio é salvo após o processamento"),
            value: _descartarAudio ?? true,
            onChanged: (bool newValue) {
              // 1. Atualiza o estado da tela
              setState(() {
                _descartarAudio = newValue;
              });
              // 2. Salva na API imediatamente
              _salvarConfiguracoes();
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSobreCard() {
    return _buildConfigCard(
      icon: Icons.info_outline,
      iconColor: Colors.grey[700]!,
      title: "Sobre o app",
      subtitle: null, // Sem subtítulo
      child: Column(
        children: [
          _buildSobreItem("Versão", "1.0.0"),
          _buildSobreItem("Desenvolvido por", "Equipe Escuta d'Água"),
          const SizedBox(height: 16),
          Text(
            "Processamento local • Privacidade garantida • Código aberto",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSobreItem(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              titulo,
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              valor,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget "Molde" para os Cards ---
  Widget _buildConfigCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 36,
                  ), // Alinha com o título
                  child: Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
