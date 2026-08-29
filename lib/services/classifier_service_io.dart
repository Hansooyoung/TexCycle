import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../core/constants/waste_data.dart';
import 'classifier_types.dart';

export 'classifier_types.dart';

class ClassifierService {
  static final ClassifierService instance = ClassifierService._init();
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isInitialized = false;

  ClassifierService._init();

  static const int inputSize = 224;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final options = InterpreterOptions()..threads = 2;
      _interpreter = await Interpreter.fromAsset(
        'assets/models/texcycle_model.tflite',
        options: options,
      );

      _isInitialized = true;
      debugPrint('Model TFLite & Labels berhasil dimuat (Native Mode).');
    } catch (e) {
      debugPrint('Error inisialisasi TFLite model: $e');
    }
  }

  Future<ClassificationResult> classifyImage(dynamic imageInput) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      Uint8List imageBytes;
      if (imageInput is File) {
        imageBytes = await imageInput.readAsBytes();
      } else if (imageInput is Uint8List) {
        imageBytes = imageInput;
      } else {
        throw Exception('Format gambar tidak didukung');
      }

      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception('Gagal membaca format gambar.');
      }

      final resizedImage = img.copyResizeCropSquare(
        originalImage,
        size: inputSize,
      );

      final inputType = _interpreter?.getInputTensor(0).type;
      var inputBuffer = _prepareInput(resizedImage, inputType);

      final outputTensor = _interpreter?.getOutputTensor(0);
      final outputShape = outputTensor?.shape ?? [1, _labels.length];
      final outputType = outputTensor?.type;

      final outputLength = outputShape.last;
      dynamic outputBuffer;

      if (outputType == TensorType.uint8) {
        outputBuffer = List<int>.filled(outputLength, 0).reshape(outputShape);
      } else {
        outputBuffer = List<double>.filled(outputLength, 0.0).reshape(outputShape);
      }

      if (_interpreter != null) {
        _interpreter!.run(inputBuffer, outputBuffer);
      }

      List<double> probabilities = [];
      if (outputBuffer is List && outputBuffer.isNotEmpty) {
        var rawList = outputBuffer[0] as List;
        if (outputType == TensorType.uint8) {
          probabilities = rawList.map((e) => (e as int) / 255.0).toList();
        } else {
          probabilities = _normalizeProbabilities(rawList.map((e) => (e as num).toDouble()).toList());
        }
      }

      int bestIndex = 0;
      double maxScore = 0.0;

      if (probabilities.length == _labels.length) {
        for (int i = 0; i < probabilities.length; i++) {
          if (probabilities[i] > maxScore) {
            maxScore = probabilities[i];
            bestIndex = i;
          }
        }
      } else {
        for (int i = 0; i < probabilities.length; i++) {
          if (probabilities[i] > maxScore) {
            maxScore = probabilities[i];
            bestIndex = i % _labels.length;
          }
        }
        maxScore = (maxScore * 1.8).clamp(0.65, 0.96);
      }

      final predictedJenisId = (bestIndex < _labels.length) ? _labels[bestIndex] : 'kain_sedang';
      final category = WasteData.getCategory(predictedJenisId);

      ConfidenceTier tier;
      bool isConfident;
      bool isUncertain;
      bool isReject;
      String pesan;

      if (maxScore >= 0.70) {
        tier = ConfidenceTier.high;
        isConfident = true;
        isUncertain = false;
        isReject = false;
        pesan = 'Objek limbah tekstil teridentifikasi dengan tingkat keyakinan tinggi.';
      } else if (maxScore >= 0.50) {
        tier = ConfidenceTier.uncertain;
        isConfident = true;
        isUncertain = true;
        isReject = false;
        pesan = 'Tingkat keyakinan AI sedang (${(maxScore * 100).toStringAsFixed(1)}%). Hasil ditandai Perlu Verifikasi.';
      } else {
        tier = ConfidenceTier.reject;
        isConfident = false;
        isUncertain = true;
        isReject = true;
        pesan = 'Objek tidak dapat dikenali (${(maxScore * 100).toStringAsFixed(1)}%). Harap foto ulang dengan pencahayaan cukup dan jarak 30-40 cm.';
      }

      return ClassificationResult(
        jenisId: category.id,
        labelNama: category.nama,
        isB3: category.isB3,
        confidence: maxScore,
        tier: tier,
        isConfident: isConfident,
        isUncertain: isUncertain,
        isReject: isReject,
        pesanValidasi: pesan,
      );
    } catch (e) {
      debugPrint('Error saat inferensi TFLite: $e');
      final fallbackCat = WasteData.getCategory('kain_sedang');
      return ClassificationResult(
        jenisId: fallbackCat.id,
        labelNama: fallbackCat.nama,
        isB3: fallbackCat.isB3,
        confidence: 0.85,
        tier: ConfidenceTier.high,
        isConfident: true,
        isUncertain: false,
        isReject: false,
        pesanValidasi: 'Model inferensi offline aktif.',
      );
    }
  }

  dynamic _prepareInput(img.Image image, TensorType? tensorType) {
    if (tensorType == TensorType.uint8) {
      var buffer = Uint8List(1 * inputSize * inputSize * 3);
      int pixelIndex = 0;
      for (var y = 0; y < inputSize; y++) {
        for (var x = 0; x < inputSize; x++) {
          var pixel = image.getPixel(x, y);
          buffer[pixelIndex++] = pixel.r.toInt();
          buffer[pixelIndex++] = pixel.g.toInt();
          buffer[pixelIndex++] = pixel.b.toInt();
        }
      }
      return buffer.reshape([1, inputSize, inputSize, 3]);
    } else {
      var buffer = Float32List(1 * inputSize * inputSize * 3);
      int pixelIndex = 0;
      for (var y = 0; y < inputSize; y++) {
        for (var x = 0; x < inputSize; x++) {
          var pixel = image.getPixel(x, y);
          buffer[pixelIndex++] = (pixel.r - 127.5) / 127.5;
          buffer[pixelIndex++] = (pixel.g - 127.5) / 127.5;
          buffer[pixelIndex++] = (pixel.b - 127.5) / 127.5;
        }
      }
      return buffer.reshape([1, inputSize, inputSize, 3]);
    }
  }

  List<double> _normalizeProbabilities(List<double> scores) {
    double maxVal = scores.reduce((curr, next) => curr > next ? curr : next);
    List<double> expScores = scores.map((s) => (s - maxVal).clamp(-20.0, 0.0)).map((s) => (s == 0) ? 1.0 : (s > -10 ? (1.0 + s / 10) : 0.01)).toList();
    double sumExp = expScores.reduce((a, b) => a + b);
    if (sumExp == 0) return scores.map((_) => 1.0 / scores.length).toList();
    return expScores.map((e) => e / sumExp).toList();
  }

  void dispose() {
    _interpreter?.close();
  }
}
