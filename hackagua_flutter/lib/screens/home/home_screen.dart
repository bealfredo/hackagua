import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigate;

  const HomeScreen({Key? key, this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com foto e nome
              _buildHeader(user, authProvider, context),
              
              const SizedBox(height: 32),
              
              // Card de recomendação
              _buildRecomendacaoCard(),
              
              const SizedBox(height: 32),
              
              // Título "Serviços"
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 21),
                child: Text(
                  'Serviços',
                  style: TextStyle(
                    color: Color(0xFF15131F),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Cards de serviços
              _buildServicosCards(),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic user, AuthProvider authProvider, BuildContext context) {
    final userImageUrl = 'https://ui-avatars.com/api/?name=${user?.nome ?? "Usuario"}&size=80&background=4263EB&color=fff';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Foto do usuário
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE7B918),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    userImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF4263EB),
                        child: Center(
                          child: Text(
                            user?.nome?.substring(0, 1).toUpperCase() ?? 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Saudação e nome
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: 0.50,
                    child: Text(
                      _getSaudacao(),
                      style: const TextStyle(
                        color: Color(0xFF15131F),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                  Text(
                    user?.nome ?? 'Usuário',
                    style: const TextStyle(
                      color: Color(0xFF15131F),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Botão de logout
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Tem certeza que deseja sair?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Fecha o diálogo primeiro
                        Navigator.pop(context);
                        // Limpa a sessão
                        await authProvider.logout();
                        // Redireciona para a tela de login removendo o histórico
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(),
                            ),
                            (_) => false,
                          );
                        }
                      },
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: OvalBorder(),
              ),
              child: const Icon(Icons.logout, color: Color(0xFF15131F)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicosCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Column(
        children: [
          _buildServicoCard(
            icon: Icons.location_on,
            iconColor: const Color(0xFF4263EB),
            titulo: 'Rodoviárias',
            descricao: 'Veja todas as rodoviárias cadastradas',
            onTap: () {
              onNavigate?.call(1); // Índice de Rodoviárias
            },
          ),
          const SizedBox(height: 16),
          _buildServicoCard(
            icon: Icons.directions_bus,
            iconColor: const Color(0xFF259D84),
            titulo: 'Viagens',
            descricao: 'Consulte as viagens de ônibus disponíveis',
            onTap: () {
              onNavigate?.call(2); // Índice de Viagens
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServicoCard({
    required IconData icon,
    required Color iconColor,
    required String titulo,
    required String descricao,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: ShapeDecoration(
                color: iconColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Color(0xFF15131F),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.30,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descricao,
                    style: TextStyle(
                      color: const Color(0xFF15131F).withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.40,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF15131F),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecomendacaoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Stack(
        children: [
          Container(
            height: 121,
            decoration: ShapeDecoration(
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800"),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: const ShapeDecoration(
                color: Color(0xE8555555),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              child: const Text(
                'Recomendação - Palmas - TO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSaudacao() {
    final hora = DateTime.now().hour;
    if (hora < 12) {
      return 'Bom dia,';
    } else if (hora < 18) {
      return 'Boa tarde,';
    } else {
      return 'Boa noite,';
    }
  }
}