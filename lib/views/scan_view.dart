import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';
import '../services/classifier_service.dart';
import 'result_view.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  CameraController? _cameraController;
  List<CameraDescription> _availableCameras = [];
  int _currentCameraIndex = 0;
  bool _isCameraReady = false;
  bool _isCameraError = false;
  String _cameraErrorMessage = '';
  bool _isFlashOn = false;
  bool _isProcessing = false;
  bool _isStreaming = false;

  // Advance Computer Vision Sensor State
  int _lastSampleTimestamp = 0;
  double _currentLuminance = 120.0;
  double _lastLuminance = 120.0;
  bool _isMotionDetected = false;
  double _currentZoom = 1.0;
  double _maxZoom = 1.0;

  // Feedback Dinamis Real-Time
  String _feedbackMessage = 'Mengalibrasi sensor lensa...';
  Color _feedbackColor = Colors.greenAccent;
  IconData _feedbackIcon = Icons.sensors;

  // Animasi Laser Scanner
  late AnimationController _scannerAnimController;
  late Animation<double> _scannerAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scannerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _scannerAnimController, curve: Curves.easeInOut),
    );

    _initializeInAppCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerAnimController.dispose();
    _stopImageStreamSafely();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopImageStreamSafely();
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCameraController(controller.description);
    }
  }

  Future<void> _initializeInAppCamera() async {
    try {
      _availableCameras = await availableCameras();
      if (_availableCameras.isNotEmpty) {
        int backIndex = _availableCameras.indexWhere(
          (cam) => cam.lensDirection == CameraLensDirection.back,
        );
        _currentCameraIndex = backIndex != -1 ? backIndex : 0;
        await _initCameraController(_availableCameras[_currentCameraIndex]);
      } else {
        setState(() {
          _isCameraReady = false;
          _isCameraError = true;
          _cameraErrorMessage = 'Tidak ada sensor kamera terdeteksi di perangkat ini.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCameraReady = false;
          _isCameraError = true;
          _cameraErrorMessage = 'Kamera tidak dapat diakses: $e';
        });
      }
    }
  }

  Future<void> _initCameraController(CameraDescription cameraDescription) async {
    final CameraController controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _cameraController = controller;

    try {
      await controller.initialize();
      if (!mounted) return;

      try {
        _maxZoom = await controller.getMaxZoomLevel();
      } catch (_) {
        _maxZoom = 1.0;
      }

      setState(() {
        _isCameraReady = true;
        _isCameraError = false;
        _isFlashOn = false;
        _currentZoom = 1.0;
        _feedbackMessage = 'Pencahayaan cukup • Kamera stabil & siap potret';
        _feedbackColor = Colors.greenAccent;
        _feedbackIcon = Icons.check_circle_outline;
      });

      _startImageStreamSafely();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isCameraReady = false;
        _isCameraError = true;
        _cameraErrorMessage = 'Gagal menginisialisasi lensa: $e';
      });
    }
  }

  void _startImageStreamSafely() {
    if (_isStreaming || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      _cameraController!.startImageStream((CameraImage image) {
        final now = DateTime.now().millisecondsSinceEpoch;
        // Rate-limit: Analisis setiap ~250 ms (4 FPS) agar konsumsi CPU tetap < 1%
        if (now - _lastSampleTimestamp < 250) return;
        _lastSampleTimestamp = now;

        if (image.planes.isNotEmpty && image.planes[0].bytes.isNotEmpty) {
          final bytes = image.planes[0].bytes;
          int sum = 0;
          int count = 0;

          // Sampling cepat setiap 128 byte pada kanal Y (Luminance)
          for (int i = 0; i < bytes.length; i += 128) {
            sum += bytes[i];
            count++;
          }

          if (count > 0) {
            final lum = sum / count;
            final delta = (lum - _lastLuminance).abs();
            final isMotion = delta > 28.0;
            _lastLuminance = lum;

            if (mounted) {
              setState(() {
                _currentLuminance = lum;
                _isMotionDetected = isMotion;
                _updateSensorFeedback(lum, isMotion);
              });
            }
          }
        }
      });
      _isStreaming = true;
    } catch (_) {
      // Graceful fallback jika platform/driver tidak mendukung image stream
      _isStreaming = false;
    }
  }

  void _updateSensorFeedback(double lum, bool isMotion) {
    if (lum < 42.0) {
      // Kategori 1: Gelap Parah
      _feedbackMessage = 'Pencahayaan Sangat Gelap • Aktifkan Flash';
      _feedbackColor = Colors.redAccent;
      _feedbackIcon = Icons.brightness_low;
    } else if (lum < 75.0) {
      // Kategori 2: Redup / Kurang Jelas
      _feedbackMessage = 'Pencahayaan Redup • Sarankan Nyalakan Flash';
      _feedbackColor = Colors.amberAccent;
      _feedbackIcon = Icons.brightness_medium;
    } else if (isMotion) {
      // Kategori 3: Guncangan Terdeteksi
      _feedbackMessage = 'Gerakan Terdeteksi • Tahan Kamera Lebih Stabil';
      _feedbackColor = Colors.amberAccent;
      _feedbackIcon = Icons.vibration;
    } else if (lum > 225.0) {
      // Kategori 4: Silau Berlebih
      _feedbackMessage = 'Pencahayaan Terlalu Silau • Geser Sudut Objek';
      _feedbackColor = Colors.orangeAccent;
      _feedbackIcon = Icons.wb_sunny;
    } else {
      // Kategori 5: Kondisi Prima
      _feedbackMessage = 'Pencahayaan & Ketajaman Prima • Jarak 30–40 cm';
      _feedbackColor = Colors.greenAccent;
      _feedbackIcon = Icons.check_circle_outline;
    }
  }

  Future<void> _stopImageStreamSafely() async {
    if (_isStreaming && _cameraController != null) {
      try {
        await _cameraController!.stopImageStream();
      } catch (_) {}
      _isStreaming = false;
    }
  }

  Future<void> _setZoom(double zoomLevel) async {
    if (_cameraController == null || !_isCameraReady) return;
    try {
      final target = zoomLevel.clamp(1.0, _maxZoom);
      await _cameraController!.setZoomLevel(target);
      setState(() => _currentZoom = target);
    } catch (_) {}
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_isCameraReady) return;

    try {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
        setState(() {
          _isFlashOn = false;
        });
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
        setState(() {
          _isFlashOn = true;
        });
      }
    } catch (_) {}
  }

  Future<void> _switchCamera() async {
    if (_availableCameras.length < 2 || _isProcessing) return;

    await _stopImageStreamSafely();
    final nextIndex = (_currentCameraIndex + 1) % _availableCameras.length;
    _currentCameraIndex = nextIndex;
    await _cameraController?.dispose();
    await _initCameraController(_availableCameras[_currentCameraIndex]);
  }

  Future<void> _captureFromInAppLens() async {
    if (_isProcessing) return;

    if (_cameraController == null || !_isCameraReady) {
      await _pickFromNative(ImageSource.camera);
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
        _feedbackMessage = 'Memotret citra resolusi tinggi...';
        _feedbackColor = Colors.white;
      });

      // Hentikan stream sementara untuk membebaskan hardware shutter
      await _stopImageStreamSafely();

      final XFile photo = await _cameraController!.takePicture();
      final imageFile = File(photo.path);

      await _classifyAndRoute(imageFile);
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _startImageStreamSafely();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil gambar dari lensa: $e')),
        );
      }
    }
  }

  Future<void> _pickFromNative(ImageSource source) async {
    if (_isProcessing) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() => _isProcessing = true);
      final imageFile = File(pickedFile.path);
      await _classifyAndRoute(imageFile);
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat memproses foto: $e')),
        );
      }
    }
  }

  Future<void> _classifyAndRoute(File imageFile) async {
    try {
      final result = await ClassifierService.instance.classifyImage(imageFile);

      if (!mounted) return;
      setState(() => _isProcessing = false);

      if (result.isReject) {
        _showRejectDialog(result.pesanValidasi);
      } else if (result.isUncertain) {
        _showUncertainDialog(imageFile, result);
      } else {
        _navigateToResult(imageFile, result);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _startImageStreamSafely();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menjalankan analisis AI: $e')),
        );
      }
    }
  }

  void _navigateToResult(File imageFile, ClassificationResult result) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultView(
          imageFile: imageFile,
          classification: result,
        ),
      ),
    );
  }

  void _showRejectDialog(String pesan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Objek Tidak Dikenali',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text(pesan, style: const TextStyle(fontSize: 13)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _startImageStreamSafely();
            },
            child: const Text('Foto Ulang'),
          ),
        ],
      ),
    );
  }

  void _showUncertainDialog(File imageFile, ClassificationResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Akurasi Sedang',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.pesanValidasi, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.analytics_outlined, size: 16, color: Colors.amber),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Prediksi: ${result.labelNama} (${(result.confidence * 100).toStringAsFixed(1)}%)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startImageStreamSafely();
            },
            child: const Text('Foto Ulang', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToResult(imageFile, result);
            },
            child: const Text('Tetap Simpan', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final luxPercent = ((_currentLuminance / 255.0) * 100).clamp(0, 100).toInt();

    return PopScope(
      canPop: !_isProcessing,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _isProcessing ? null : () => Navigator.pop(context),
          ),
          title: const Text(
            'Advance Lens Scanner',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            if (_isCameraReady) ...[
              IconButton(
                tooltip: 'Lampu Kilat / Torch',
                icon: Icon(
                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: _isFlashOn ? Colors.amberAccent : Colors.white70,
                ),
                onPressed: _isProcessing ? null : _toggleFlash,
              ),
              if (_availableCameras.length > 1)
                IconButton(
                  tooltip: 'Ganti Kamera',
                  icon: const Icon(Icons.flip_camera_ios_outlined, color: Colors.white70),
                  onPressed: _isProcessing ? null : _switchCamera,
                ),
            ],
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Advance Real-Time HUD Status Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_feedbackIcon, size: 16, color: _feedbackColor),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _feedbackMessage,
                          style: TextStyle(color: _feedbackColor, fontSize: 12, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // Viewfinder Frame dengan Live Lens & Advance HUD Overlay
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isProcessing ? Colors.greenAccent : _feedbackColor.withValues(alpha: 0.8),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _feedbackColor.withValues(alpha: 0.2),
                          blurRadius: 16,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(21),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // 1. Live Camera Preview (atau Fallback jika error/web)
                          if (_isCameraReady && _cameraController != null)
                            Center(child: CameraPreview(_cameraController!))
                          else if (_isCameraError)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.videocam_off_outlined, size: 54, color: Colors.grey.shade600),
                                    const SizedBox(height: 12),
                                    Text(
                                      _cameraErrorMessage,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2E7D32),
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () => _pickFromNative(ImageSource.camera),
                                      icon: const Icon(Icons.camera_alt, size: 18),
                                      label: const Text('Buka Kamera Bawaan HP'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            const Center(
                              child: CircularProgressIndicator(color: Colors.greenAccent),
                            ),

                          // 2. Grid Reticle Panduan
                          Opacity(
                            opacity: 0.15,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Divider(color: Colors.white, thickness: 1),
                                const Divider(color: Colors.white, thickness: 1),
                              ],
                            ),
                          ),

                          // 3. Center Dynamic Focus Reticle
                          Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _feedbackColor.withValues(alpha: 0.75),
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _feedbackColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 4. Laser Scanning Bar Animasi
                          AnimatedBuilder(
                            animation: _scannerAnimation,
                            builder: (context, child) {
                              return Positioned(
                                top: MediaQuery.of(context).size.height * 0.4 * _scannerAnimation.value,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        _feedbackColor.withValues(alpha: 0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _feedbackColor.withValues(alpha: 0.5),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // 5. Live HUD Meter di Bagian Atas Viewfinder
                          Positioned(
                            top: 12,
                            left: 12,
                            right: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Lux Indicator Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: _feedbackColor.withValues(alpha: 0.5)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.lightbulb_outline, size: 13, color: _feedbackColor),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Lux: $luxPercent%',
                                        style: TextStyle(
                                          color: _feedbackColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Indikator Gerakan / Menstabilkan
                                if (_isMotionDetected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade900.withValues(alpha: 0.85),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.vibration, size: 12, color: Colors.white),
                                        SizedBox(width: 4),
                                        Text(
                                          'Menstabilkan...',
                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Chip Rekomendasi Senter (Jika Gelap dan Flash Off)
                                if (_currentLuminance < 75.0 && !_isFlashOn)
                                  GestureDetector(
                                    onTap: _toggleFlash,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade800,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.amber.withValues(alpha: 0.4),
                                            blurRadius: 8,
                                          )
                                        ],
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.flash_on, size: 13, color: Colors.white),
                                          SizedBox(width: 4),
                                          Text(
                                            'Nyalakan Flash',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Jarak Ideal Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    '30–40 cm',
                                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 6. Zoom Controller (1x / 2x Toggle)
                          if (_maxZoom >= 1.5)
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildZoomButton(1.0, '1x'),
                                    const SizedBox(width: 4),
                                    _buildZoomButton(2.0, '2x'),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Panel Kontrol Pemotretan di Bawah
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Tombol Galeri
                      IconButton(
                        tooltip: 'Pilih dari Galeri',
                        iconSize: 30,
                        icon: const Icon(Icons.photo_library_outlined, color: Colors.white70),
                        onPressed: _isProcessing ? null : () => _pickFromNative(ImageSource.gallery),
                      ),

                      // Tombol Shutter Utama
                      GestureDetector(
                        onTap: _isProcessing ? null : _captureFromInAppLens,
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: const Color(0xFF2E7D32),
                            boxShadow: [
                              BoxShadow(
                                color: _feedbackColor.withValues(alpha: 0.4),
                                blurRadius: 16,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 34),
                          ),
                        ),
                      ),

                      // Tombol Kamera Bawaan Native (Alternatif)
                      IconButton(
                        tooltip: 'Kamera Bawaan HP',
                        iconSize: 28,
                        icon: const Icon(Icons.tune_outlined, color: Colors.white70),
                        onPressed: _isProcessing ? null : () => _pickFromNative(ImageSource.camera),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Shimmer / Radar Pulse Overlay saat Inferensi AI
            if (_isProcessing)
              Container(
                color: Colors.black.withValues(alpha: 0.85),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            color: Colors.greenAccent,
                            strokeWidth: 3,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Menganalisis Serat & Komposisi Limbah...',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Inferensi On-Device MobileNetV2 • 100% Offline',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        ),
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

  Widget _buildZoomButton(double zoom, String label) {
    final isSelected = (_currentZoom - zoom).abs() < 0.2;
    return GestureDetector(
      onTap: () => _setZoom(zoom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
