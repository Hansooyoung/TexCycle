import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal lokal Indonesia
  await initializeDateFormatting('id_ID', null);

  runApp(const TexCycleApp());
}

class TexCycleApp extends StatelessWidget {
  const TexCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TexCycle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20), // Hijau Lingkungan
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFF2E7D32),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        fontFamily: 'Roboto',
      ),
      home: const SplashView(),
    );
  }
}
