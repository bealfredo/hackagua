// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hackagua_flutter/navigation/navbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';

const baseUrlApi = 'http://72.60.3.7:8080';

const Color primaryGray = Color(0xFF333333);
const Color secondaryGray = Color(0xFF4D4D4D);
const Color accentGray = Color(0xFF666666);
const Color lightGray = Color(0xFFAAAAAA);
const Color backgroundColor = Color(0xFF222222);

const primaryColor = Color.fromARGB(255, 38, 74, 179);
const primaryColorLight = secondaryGray;
const secondaryColor = accentGray;
const secondaryColorLight = lightGray;
const fontColor = Colors.white;
// Cor de fundo padrão para páginas claras
const lightPageBackground = Color(0xFFEFEFEF);

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar Hive
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            navigatorKey: appNavigatorKey,
            title: 'HackÁgua',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
