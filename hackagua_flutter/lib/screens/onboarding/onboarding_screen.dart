import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final int userId;

  const OnboardingScreen({super.key, required this.userId});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  Future<void> _finish() async {
    final box = await Hive.openBox('auth_box');
    await box.put('onboarding_seen_${widget.userId}', true);

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFFF3FAF6);
    const Color green = Color(0xFF2F7D32);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                children: const [
                  _Page(
                    icon: Icons.water_drop,
                    title: 'Seu celular reconhece água\npelo som',
                    description:
                        'Detectamos automaticamente quando torneiras, chuveiros e descargas são usados, ajudando você a economizar água e dinheiro.',
                  ),
                  _Page(
                    icon: Icons.lock,
                    title: 'Privacidade em primeiro lugar',
                    description:
                        'Todo o processamento acontece no seu aparelho. Nenhum áudio é salvo ou enviado para a internet. Seus dados ficam apenas com você.',
                  ),
                  _Page(
                    icon: Icons.home_filled,
                    title: 'Somente em casa',
                    description:
                        'Você define a área da sua casa, e o app só monitora quando você está dentro dela. Fora de casa, o monitoramento é pausado automaticamente.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => _Dot(active: _page == i)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_page < 2) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    } else {
                      await _finish();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_page < 2 ? 'Próximo' : 'Continuar',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _Page({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    const Color text = Color(0xFF0F172A);
    const Color sub = Color(0xFF475569);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(icon, size: 96, color: Colors.blueAccent),
          const SizedBox(height: 18),
          const Icon(Icons.water_drop_outlined, size: 28, color: Color(0xFF2F7D32)),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: text,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: sub,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 22 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF2F7D32) : const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
