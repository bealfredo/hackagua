import 'package:flutter/material.dart';
import 'package:hackagua_flutter/screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

const baseUrlApi = 'http://72.60.3.7:8080';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escuta d\'Água',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const HomeScreen(),
    );
  }
}
