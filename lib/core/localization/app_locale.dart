import 'package:flutter/material.dart';

/// Pengelola status bahasa global aplikasi TexCycle
class AppLocale {
  static final ValueNotifier<String> localeNotifier = ValueNotifier<String>('id');

  static String get currentLocale => localeNotifier.value;
  static bool get isEn => localeNotifier.value == 'en';

  static void setLocale(String langCode) {
    if (langCode == 'en' || langCode == 'id') {
      localeNotifier.value = langCode;
    }
  }

  static void toggleLocale() {
    setLocale(isEn ? 'id' : 'en');
  }
}

/// Kamus teks dwibahasa: Bahasa Indonesia & English (US)
/// Dirancang ringkas, lugas, dan bebas teks bertele-tele
class AppText {
  // Navigation & General
  static String get appTitle => 'TexCycle';
  static String get navHome => AppLocale.isEn ? 'Home' : 'Beranda';
  static String get navHistory => AppLocale.isEn ? 'History' : 'Riwayat';
  static String get navGuide => AppLocale.isEn ? 'DIY Guide' : 'Panduan';
  static String get navSettings => AppLocale.isEn ? 'Settings' : 'Pengaturan';
  static String get cancel => AppLocale.isEn ? 'Cancel' : 'Batal';
  static String get delete => AppLocale.isEn ? 'Delete' : 'Hapus';
  static String get save => AppLocale.isEn ? 'Save' : 'Simpan';
  static String get close => AppLocale.isEn ? 'Close' : 'Tutup';
  static String get back => AppLocale.isEn ? 'Back' : 'Kembali';

  // Splash Screen
  static String get splashSubtitle => AppLocale.isEn
      ? 'Textile Waste Intelligence Platform'
      : 'Platform Tata Kelola Limbah Tekstil';
  static String get splashPreloadingDb => AppLocale.isEn
      ? 'Preparing Local Database...'
      : 'Menyiapkan Basis Data Riwayat...';
  static String get splashPreloadingAi => AppLocale.isEn
      ? 'Preheating On-Device AI Engine...'
      : 'Memanaskan Model AI TFLite...';
  static String get splashPreloadingDone => AppLocale.isEn
      ? 'System Ready • Launching TexCycle'
      : 'Sistem Siap • Membuka TexCycle';
  static String get splashVersion => AppLocale.isEn
      ? 'v1.3 • 100% On-Device Engine'
      : 'Versi 1.3 • 100% On-Device Engine';

  // Home Screen
  static String get offlineStatus => AppLocale.isEn
      ? '100% On-Device • Offline Active'
      : '100% On-Device • Mode Offline Aktif';
  static String get stat30Days => AppLocale.isEn
      ? '30-Day Activity Overview'
      : 'Ringkasan Aktivitas 30 Hari Terakhir';
  static String get totalScans => AppLocale.isEn ? 'Total Scans' : 'Total Scan';
  static String get nonB3Safe => AppLocale.isEn ? 'Non-B3 Safe' : 'Non-B3 Aman';
  static String get b3Hazardous => AppLocale.isEn ? 'B3 Hazardous' : 'B3 Berbahaya';
  static String get b3WarningTitle => AppLocale.isEn
      ? 'Hazardous Waste Alert'
      : 'Peringatan Limbah Berbahaya';
  static String get b3WarningMsg => AppLocale.isEn
      ? 'Hazardous waste detected in the last 7 days. Ensure proper disposal per DLH protocols.'
      : 'Terdeteksi limbah B3 dalam 7 hari terakhir. Pastikan penyimpanan terpisah sesuai SOP DLH.';
  static String get btnScanNow => AppLocale.isEn
      ? 'Scan Textile Waste Now'
      : 'Identifikasi Limbah Sekarang';
  static String get quickHistoryTitle => AppLocale.isEn ? 'Scan History' : 'Riwayat Scan';
  static String get quickHistorySubtitle => AppLocale.isEn
      ? 'Inventory logs & CSV export'
      : 'Log limbah & ekspor CSV';
  static String get quickGuideTitle => AppLocale.isEn ? 'Upcycling Guides' : 'Panduan Upcycling';
  static String get quickGuideSubtitle => AppLocale.isEn
      ? 'DIY tutorials for scrap fabrics'
      : 'Ide kreasi olah kain perca';
  static String get quickSettingsTitle => AppLocale.isEn ? 'Storage & Tools' : 'Pengaturan & Memori';
  static String get quickSettingsSubtitle => AppLocale.isEn
      ? 'Storage diagnostic & cache'
      : 'Info memori & reset cache';

  // Camera / Scan HUD
  static String get cameraTitle => AppLocale.isEn ? 'Smart Vision Scanner' : 'Kamera Cerdas TexCycle';
  static String get cameraReady => AppLocale.isEn
      ? 'Optimal Lighting • Camera Ready'
      : 'Pencahayaan cukup • Kamera stabil & siap potret';
  static String get cameraDark => AppLocale.isEn
      ? 'Too Dark • Turn On Flash'
      : 'Pencahayaan Sangat Gelap • Aktifkan Flash';
  static String get cameraDim => AppLocale.isEn
      ? 'Low Light • Suggest Flash'
      : 'Pencahayaan Redup • Sarankan Nyalakan Flash';
  static String get cameraMotion => AppLocale.isEn
      ? 'Motion Detected • Hold Steady'
      : 'Gerakan Terdeteksi • Tahan Kamera Lebih Stabil';
  static String get cameraGlare => AppLocale.isEn
      ? 'Too Bright • Adjust Angle'
      : 'Pencahayaan Terlalu Silau • Geser Sudut Objek';
  static String get btnFlashOn => AppLocale.isEn ? 'Turn On Flash' : 'Nyalakan Flash';
  static String get btnFlashOff => AppLocale.isEn ? 'Turn Off Flash' : 'Matikan Flash';
  static String get btnGallery => AppLocale.isEn ? 'Gallery' : 'Galeri';
  static String get btnCapture => AppLocale.isEn ? 'Capture' : 'Potret';
  static String get distanceGuide => AppLocale.isEn
      ? 'Position fabric 30–40 cm inside viewfinder'
      : 'Posisikan kain 30–40 cm di dalam bingkai';
  static String get capturingPhoto => AppLocale.isEn
      ? 'Capturing high-res image...'
      : 'Memotret citra resolusi tinggi...';
  static String get analyzingImage => AppLocale.isEn
      ? 'Analyzing with On-Device AI...'
      : 'Menganalisis citra dengan AI...';

  // Results Screen
  static String get resultTitle => AppLocale.isEn ? 'Classification Result' : 'Hasil Identifikasi';
  static String get badgeNonB3 => AppLocale.isEn ? 'Category: Non-B3 (Safe)' : 'Kategori: Non-B3 (Aman)';
  static String get badgeB3 => AppLocale.isEn ? 'Category: B3 (Hazardous)' : 'Kategori: B3 (Berbahaya)';
  static String get confidenceScore => AppLocale.isEn ? 'AI Confidence' : 'Akurasi Model';
  static String get marketValue => AppLocale.isEn ? 'Estimated Scrap Value' : 'Estimasi Nilai Jual';
  static String get upcyclingTitle => AppLocale.isEn ? 'Recommended DIY Projects' : 'Rekomendasi Kreasi DIY';
  static String get dlhProtocolTitle => AppLocale.isEn ? 'DLH Mandatory Handling Protocols' : 'Prosedur Standar Wajib DLH';
  static String get weightInputLabel => AppLocale.isEn ? 'Estimated Weight (kg)' : 'Estimasi Berat (kg)';
  static String get weightInputHint => AppLocale.isEn ? 'e.g. 2.5' : 'Contoh: 2.5';
  static String get btnSaveRecord => AppLocale.isEn ? 'Save to History' : 'Simpan Ke Riwayat';
  static String get savedSuccess => AppLocale.isEn ? 'Scan record saved!' : 'Data scan berhasil disimpan!';

  // Validation / Uncertain Dialogs
  static String get unkObjectTitle => AppLocale.isEn ? 'Unrecognized Object' : 'Objek Tidak Dikenali';
  static String get unkObjectBtn => AppLocale.isEn ? 'Retake Photo' : 'Foto Ulang';
  static String get moderateAccuracyTitle => AppLocale.isEn ? 'Moderate Confidence' : 'Akurasi Sedang';
  static String get moderateAccuracyBtnAccept => AppLocale.isEn ? 'Accept & Save' : 'Terima & Simpan';
  static String get moderateAccuracyBtnRetake => AppLocale.isEn ? 'Retake' : 'Foto Ulang';

  // History Screen
  static String get historyTitle => AppLocale.isEn ? 'Waste Scan History' : 'Riwayat Identifikasi';
  static String get searchHint => AppLocale.isEn ? 'Search waste name...' : 'Cari jenis limbah...';
  static String get filterAll => AppLocale.isEn ? 'All' : 'Semua';
  static String get filterNonB3 => AppLocale.isEn ? 'Non-B3' : 'Non-B3';
  static String get filterB3 => AppLocale.isEn ? 'B3' : 'B3';
  static String get filterVerify => AppLocale.isEn ? 'Needs Verify' : 'Verifikasi';
  static String get emptyHistory => AppLocale.isEn ? 'No scan records found.' : 'Belum ada riwayat identifikasi.';
  static String get exportCsv => AppLocale.isEn ? 'Export CSV' : 'Ekspor CSV';
  static String get shareCsv => AppLocale.isEn ? 'Share CSV' : 'Bagikan CSV';
  static String get detailTitle => AppLocale.isEn ? 'Scan Details' : 'Detail Identifikasi';
  static String get dateScanned => AppLocale.isEn ? 'Date' : 'Tanggal';
  static String get weightLogged => AppLocale.isEn ? 'Weight' : 'Berat';

  // Guide Screen
  static String get guideTitle => AppLocale.isEn ? 'Upcycling & DIY Guides' : 'Panduan Upcycling & Daur Ulang';
  static String get guideSubtitle => AppLocale.isEn
      ? '100% Offline DIY tutorials for textile scraps'
      : 'Tutorial daur ulang kain perca 100% offline';
  static String get stepByStep => AppLocale.isEn ? 'Steps:' : 'Langkah Pengerjaan:';
  static String get toolsAndMaterials => AppLocale.isEn ? 'Tools & Materials:' : 'Alat & Bahan:';

  // Settings Screen
  static String get settingsTitle => AppLocale.isEn ? 'Settings & System' : 'Pengaturan & Sistem';
  static String get langPrefTitle => AppLocale.isEn ? 'Language / Bahasa' : 'Pilihan Bahasa';
  static String get langPrefSubtitle => AppLocale.isEn ? 'Select display language' : 'Pilih bahasa tampilan aplikasi';
  static String get langId => 'Bahasa Indonesia';
  static String get langEn => 'English (US)';
  static String get storageTitle => AppLocale.isEn ? 'Local Storage Usage' : 'Penggunaan Ruang Simpan';
  static String get clearCacheBtn => AppLocale.isEn ? 'Clear Photo Cache' : 'Bersihkan Cache Foto';
  static String get clearCacheSuccess => AppLocale.isEn ? 'Temporary photo cache cleared!' : 'Cache foto sementara dibersihkan!';
  static String get deleteOldRecordsBtn => AppLocale.isEn ? 'Delete Records > 6 Months' : 'Hapus Riwayat > 6 Bulan';
  static String get deleteAllRecordsBtn => AppLocale.isEn ? 'Clear All Data' : 'Hapus Seluruh Data';
  static String get privacyTitle => AppLocale.isEn ? '100% Privacy & Offline Guarantee' : 'Jaminan Privasi & Offline 100%';
  static String get privacyDesc => AppLocale.isEn
      ? 'All photos, classification models, and database records remain exclusively on your device. Zero cloud sync, zero data leaks.'
      : 'Seluruh foto, model AI, dan data riwayat disimpan secara lokal di perangkat Anda tanpa pernah dikirim ke server luar.';
  static String get appVersionLabel => AppLocale.isEn ? 'Version 1.3.0 • Production Release' : 'Versi 1.3.0 • Production Release';

  // Additional Result & Guide View Labels
  static String get sizeOrCharacteristics => AppLocale.isEn ? 'Size / Shape:' : 'Ukuran/Bentuk:';
  static String get economicValueTitle => AppLocale.isEn
      ? 'Recommendations & Economic Potential'
      : 'Rekomendasi & Potensi Nilai Ekonomi';
  static String get marketValuePrefix => AppLocale.isEn ? 'Estimated Scrap Value:' : 'Estimasi Nilai Jual:';
  static String get dlhTitleBadge => AppLocale.isEn
      ? '5 DLH Mandatory Protocols (Hazardous)'
      : '5 Prosedur Standar DLH (Kategori B3)';
  static String get dlhHotlineLabel => AppLocale.isEn
      ? 'Official Local DLH Hazardous Pickup'
      : 'Layanan Penjemputan Resmi DLH Terdekat';
  static String get dlhHotlineSub => AppLocale.isEn
      ? 'Emergency Line: (021) 1500-xxx'
      : 'Kontak Darurat: (021) 1500-xxx';
  static String get catLargeScraps => AppLocale.isEn ? 'Large Scraps' : 'Kain Besar';
  static String get catMediumScraps => AppLocale.isEn ? 'Medium Scraps' : 'Kain Sedang';
  static String get catSmallScraps => AppLocale.isEn ? 'Small Scraps' : 'Kain Kecil';
  static String get catYarnThread => AppLocale.isEn ? 'Yarn / Thread' : 'Sisa Benang';
  static String get catPackaging => AppLocale.isEn ? 'Packaging / Spools' : 'Kemasan Karton';
  static String get catAllTutorials => AppLocale.isEn ? 'All Tutorials' : 'Semua Tutorial';
}
