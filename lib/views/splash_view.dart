import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../core/localization/app_locale.dart';
import '../services/classifier_service.dart';
import 'home_view.dart';

class SplashView extends StatefulWidget {
  final bool autoPreload;
  const SplashView({super.key, this.autoPreload = true});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String _loadingStatus = AppText.splashPreloadingDb;
  double _progressValue = 0.15;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();
    if (widget.autoPreload) {
      _startAsyncPreloading();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _startAsyncPreloading() async {
    final startTime = DateTime.now();

    try {
      // Tahap 1: Memuat Basis Data SQLite Lokal
      if (mounted) {
        setState(() {
          _loadingStatus = 'Menyiapkan Basis Data Riwayat...';
          _progressValue = 0.40;
        });
      }
      await DatabaseHelper.instance.database;

      // Tahap 2: Pra-pemanasan Model TFLite On-Device
      if (mounted) {
        setState(() {
          _loadingStatus = AppText.splashPreloadingAi;
          _progressValue = 0.75;
        });
      }
      await ClassifierService.instance.initialize().catchError((e) {
        debugPrint('Pre-warm AI notice: $e');
      });

      // Tahap 3: Deteksi Sensor Kamera
      if (mounted) {
        setState(() {
          _loadingStatus = AppLocale.isEn ? 'Calibrating Camera Lens...' : 'Mengalibrasi Lensa Kamera...';
          _progressValue = 0.95;
        });
      }
      try {
        await availableCameras();
      } catch (_) {}

      // Tahap 4: Finalisasi
      if (mounted) {
        setState(() {
          _loadingStatus = AppText.splashPreloadingDone;
          _progressValue = 1.0;
        });
      }

      // Pastikan ada waktu minimum animasi (~900 ms) agar transisi nyaman di mata
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      if (elapsed < 900) {
        await Future.delayed(Duration(milliseconds: 900 - elapsed));
      }

      if (!mounted) return;

      // Transisi Halus (Fade Transition) ke HomeView
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => const HomeView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } catch (e) {
      debugPrint('Startup warning: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F3813), // Deep Eco Forest Green
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Badge Sirkular Eco-Green
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1B5E20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4), width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.recycling_rounded,
                        color: Colors.greenAccent,
                        size: 58,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Judul & Tagline
                  const Text(
                    'TexCycle',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppText.splashSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Progress Bar Indikator Halus
                  SizedBox(
                    width: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progressValue,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Status Pemuatan Async
                  Text(
                    _loadingStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppText.splashVersion,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
