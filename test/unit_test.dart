import 'package:flutter_test/flutter_test.dart';
import 'package:texcycle/core/constants/waste_data.dart';
import 'package:texcycle/core/localization/app_locale.dart';
import 'package:texcycle/models/scan_record.dart';

void main() {
  group('1. Pengujian WasteData & Klasifikasi 8 Kategori Limbah', () {
    test('Memastikan seluruh 8 kelas limbah tekstil terdaftar lengkap', () {
      final expectedClasses = [
        'kain_besar',
        'kain_sedang',
        'kain_kecil',
        'benang',
        'kemasan',
        'limbah_cair',
        'sludge',
        'majun',
      ];

      for (final cls in expectedClasses) {
        final cat = WasteData.getCategory(cls);
        expect(cat.id, equals(cls), reason: 'Kategori $cls harus terdaftar');
        expect(cat.nama.isNotEmpty, isTrue);
      }
    });

    test('Validasi integritas status B3 vs Non-B3', () {
      // Non-B3 (Aman)
      expect(WasteData.getCategory('kain_besar').isB3, isFalse);
      expect(WasteData.getCategory('kain_sedang').isB3, isFalse);
      expect(WasteData.getCategory('kain_kecil').isB3, isFalse);
      expect(WasteData.getCategory('benang').isB3, isFalse);
      expect(WasteData.getCategory('kemasan').isB3, isFalse);

      // B3 (Berbahaya)
      expect(WasteData.getCategory('limbah_cair').isB3, isTrue);
      expect(WasteData.getCategory('sludge').isB3, isTrue);
      expect(WasteData.getCategory('majun').isB3, isTrue);
    });

    test('Memastikan seluruh limbah B3 memiliki 5 Prosedur Wajib DLH', () {
      final b3Classes = ['limbah_cair', 'sludge', 'majun'];

      for (final cls in b3Classes) {
        final cat = WasteData.getCategory(cls);
        expect(cat.prosedurB3.length, equals(5),
            reason: '$cls harus memiliki tepat 5 SOP DLH');
        for (final sop in cat.prosedurB3) {
          expect(sop.isNotEmpty, isTrue);
        }
      }
    });

    test('Memastikan seluruh limbah Non-B3 memiliki rekomendasi upcycling', () {
      final nonB3Classes = ['kain_besar', 'kain_sedang', 'kain_kecil', 'benang', 'kemasan'];

      for (final cls in nonB3Classes) {
        final cat = WasteData.getCategory(cls);
        expect(cat.rekomendasi.isNotEmpty, isTrue,
            reason: '$cls harus memiliki minimal 1 rekomendasi upcycling');
      }
    });

    test('Fallback aman jika ID limbah tidak dikenal', () {
      final unknown = WasteData.getCategory('kategori_acak_tidak_dikenal');
      expect(unknown.id, equals('unknown'));
      expect(unknown.isB3, isFalse);
      expect(unknown.nama, contains('Lainnya'));
    });
  });

  group('2. Pengujian Model Data ScanRecord & Konversi SQLite', () {
    test('Serialisasi toMap() dan deserialisasi fromMap() konsisten', () {
      final original = ScanRecord(
        id: 42,
        imagePath: '/data/user/0/com.texcycle.app/files/scan_123.jpg',
        jenisId: 'sludge',
        labelNama: 'Sludge IPAL (Lumpur Endapan Tekstil)',
        kategoriB3: 1,
        confidence: 0.945,
        isUncertain: 0,
        catatan: 'Lumpur sedimentasi IPAL bak 2',
        createdAt: '2026-08-29 14:30:00',
      );

      final map = original.toMap();
      expect(map['id'], equals(42));
      expect(map['jenis_id'], equals('sludge'));
      expect(map['kategori_b3'], equals(1));
      expect(map['confidence'], equals(0.945));
      expect(map['is_uncertain'], equals(0));
      expect(map['catatan'], equals('Lumpur sedimentasi IPAL bak 2'));

      final reconstructed = ScanRecord.fromMap(map);
      expect(reconstructed.id, equals(original.id));
      expect(reconstructed.imagePath, equals(original.imagePath));
      expect(reconstructed.jenisId, equals(original.jenisId));
      expect(reconstructed.labelNama, equals(original.labelNama));
      expect(reconstructed.kategoriB3, equals(original.kategoriB3));
      expect(reconstructed.confidence, equals(original.confidence));
      expect(reconstructed.isUncertain, equals(original.isUncertain));
      expect(reconstructed.catatan, equals(original.catatan));
      expect(reconstructed.createdAt, equals(original.createdAt));
      expect(reconstructed.isB3, isTrue);
      expect(reconstructed.needsVerification, isFalse);
    });

    test('Flag isUncertain bekerja dengan presisi', () {
      final uncertainRecord = ScanRecord(
        imagePath: '/path/test.jpg',
        jenisId: 'kain_sedang',
        labelNama: 'Kain Sedang',
        kategoriB3: 0,
        confidence: 0.58,
        isUncertain: 1,
        createdAt: '2026-08-29 14:35:00',
      );

      expect(uncertainRecord.isB3, isFalse);
      expect(uncertainRecord.needsVerification, isTrue);
    });
  });

  group('3. Pengujian Advance Computer Vision Sensorik (Luminance & Stability)', () {
    String evaluateLighting(double lum) {
      if (lum < 42.0) return 'dark';
      if (lum < 75.0) return 'dim';
      if (lum > 225.0) return 'glare';
      return 'optimal';
    }

    bool isMotionJitter(double current, double last) {
      return (current - last).abs() > 28.0;
    }

    test('Klasifikasi tingkat kecerahan Y-Luminance akurat', () {
      expect(evaluateLighting(20.0), equals('dark'));
      expect(evaluateLighting(41.9), equals('dark'));
      expect(evaluateLighting(42.0), equals('dim'));
      expect(evaluateLighting(70.0), equals('dim'));
      expect(evaluateLighting(75.0), equals('optimal'));
      expect(evaluateLighting(140.0), equals('optimal'));
      expect(evaluateLighting(225.0), equals('optimal'));
      expect(evaluateLighting(230.0), equals('glare'));
    });

    test('Deteksi guncangan gerak (motion blur threshold) akurat', () {
      expect(isMotionJitter(100.0, 105.0), isFalse); // Delta 5 (Stabil)
      expect(isMotionJitter(100.0, 128.0), isFalse); // Delta 28 (Batas stabil)
      expect(isMotionJitter(100.0, 135.0), isTrue);  // Delta 35 (Guncangan)
      expect(isMotionJitter(150.0, 110.0), isTrue);  // Delta 40 (Guncangan turun)
    });
  });

  group('4. Pengujian Fitur Multi-Bahasa (AppLocale & AppText)', () {
    test('Peralihan bahasa ID ke EN dan sebaliknya bekerja reaktif & konsisten', () {
      AppLocale.setLocale('id');
      expect(AppLocale.isEn, isFalse);
      expect(AppLocale.currentLocale, equals('id'));
      expect(AppText.navHome, equals('Beranda'));
      expect(AppText.btnScanNow, equals('Identifikasi Limbah Sekarang'));

      // Switch ke English (US)
      AppLocale.setLocale('en');
      expect(AppLocale.isEn, isTrue);
      expect(AppLocale.currentLocale, equals('en'));
      expect(AppText.navHome, equals('Home'));
      expect(AppText.btnScanNow, equals('Scan Textile Waste Now'));

      // Toggle kembali ke ID
      AppLocale.toggleLocale();
      expect(AppLocale.isEn, isFalse);
      expect(AppLocale.currentLocale, equals('id'));
      expect(AppText.navHome, equals('Beranda'));
    });

    test('Memastikan seluruh string AppText terdefinisi lengkap & non-empty di kedua bahasa', () {
      for (final lang in ['id', 'en']) {
        AppLocale.setLocale(lang);
        expect(AppText.appTitle.isNotEmpty, isTrue);
        expect(AppText.navHome.isNotEmpty, isTrue);
        expect(AppText.navHistory.isNotEmpty, isTrue);
        expect(AppText.navGuide.isNotEmpty, isTrue);
        expect(AppText.navSettings.isNotEmpty, isTrue);
        expect(AppText.stat30Days.isNotEmpty, isTrue);
        expect(AppText.cameraReady.isNotEmpty, isTrue);
        expect(AppText.cameraDark.isNotEmpty, isTrue);
        expect(AppText.cameraDim.isNotEmpty, isTrue);
        expect(AppText.cameraMotion.isNotEmpty, isTrue);
        expect(AppText.resultTitle.isNotEmpty, isTrue);
        expect(AppText.historyTitle.isNotEmpty, isTrue);
        expect(AppText.guideTitle.isNotEmpty, isTrue);
        expect(AppText.settingsTitle.isNotEmpty, isTrue);
        expect(AppText.langPrefTitle.isNotEmpty, isTrue);
      }
    });
  });
}
