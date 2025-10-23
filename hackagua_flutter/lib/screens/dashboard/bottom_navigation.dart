import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import '../history/history_screen.dart';
import '../alerts/alerts_screen.dart';
import '../settings/settings_screen.dart';
import '../controle/controle_screen.dart';

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<RootNavigation> {
  int currentIndex = 0;

  void _navigateTo(int index) {
    if (!mounted) return;
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Ensure we react to auth changes (e.g., logout)
    final auth = context.watch<AuthProvider>();
    final user = auth.user; // not used here but keeps Consumer rebuilds consistent

    final pages = <Widget>[
      HomeScreen(onNavigate: _navigateTo),
      const HistoryScreen(),
      const ControleScreen(),
      const AlertsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: _navigateTo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history_edu),
            label: 'Histórico',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_voice_outlined),
            selectedIcon: Icon(Icons.settings_voice),
            label: 'Controle',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alertas',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Configurar',
          ),
        ],
      ),
    );
  }
}
