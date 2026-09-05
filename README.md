# ♻️ TexCycle - Mobile Application (Version 1.3.0)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.13+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.1+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Edge AI](https://img.shields.io/badge/AI-100%25%20Offline%20On--Device-green.svg)](https://tensorflow.org/lite)
[![Tests](https://img.shields.io/badge/Tests-15%2F15%20Passed%20(100%25)-success)](test/)
[![Bilingual](https://img.shields.io/badge/Language-ID%20%7C%20EN%20(1--Tap%20Switch)-blue)](lib/core/localization/)
[![License](https://img.shields.io/badge/License-Proprietary-lightgrey.svg)](#)

Aplikasi mobile cerdas berbasis **Flutter** untuk klasifikasi, pemilahan, edukasi mitigasi lingkungan, serta panduan pemanfaatan kembali (*upcycling*) limbah tekstil industri konveksi skala mikro (UMKM). Dilengkapi mesin inferensi **Edge AI (TensorFlow Lite)** yang beroperasi **100% On-Device & Offline** tanpa memerlukan koneksi internet.

---

## 🌟 Fitur Utama Versi 1.3

1. **🧠 100% On-Device Edge AI Vision**:
   - Model klasifikasi citra terkompresi (`texcycle_model.tflite`) yang mengenali 8 kelas limbah tekstil secara instan di perangkat.
   - Dilengkapi modul *Computer Vision Fallback & Sensorik* untuk mendeteksi kondisi pencahayaan dan karakteristik tekstil.

2. **🏷️ Klasifikasi Komprehensif 8 Kategori Limbah**:
   - **Kategori Non-B3 (Upcyclable)**: Limbah Kain (Perca Besar, Sedang, Serpihan), Sisa Benang/Tali, dan Kemasan Plastik Gulungan.
   - **Kategori B3 (Hazardous)**: Limbah Cair Kimia (Pewarna/Pemutih), Sludge IPAL Tekstil Kering, dan Kain Majun Terkontaminasi Oli Mesin.

3. **🛡️ 5 Standar Operasional Prosedur (SOP) B3 DLH**:
   - Menampilkan peringatan bahaya dan panduan 5 langkah penanganan limbah B3 sesuai regulasi Dinas Lingkungan Hidup (DLH) & KLHK.
   - Tombol cepat akses layanan penjemputan resmi limbah berbahaya.

4. **✂️ 6 Panduan Kerajinan Daur Ulang (DIY Upcycling)**:
   - Modul tutorial interaktif langkah-demi-langkah (Tote Bag, Pouch Kosmetik, Masker Kain 3-Lapis, Bros/Scrunchie Bunga, Rumbai Gantungan Kunci, dan Wadah Pensil Silinder Karton).
   - Filter durasi, tingkat kesulitan, serta rincian alat dan bahan.

5. **🌐 Sistem Dwibahasa Reaktif Penuh (Full Bilingual ID & EN)**:
   - Pengalihan bahasa instan 1-ketukan (*1-tap switch*) antara **Bahasa Indonesia** dan **English (US)** di seluruh antarmuka dan basis data edukasi.

6. **📊 Basis Data Riwayat Lokal & Ekspor CSV**:
   - Penyimpanan riwayat pemindaian berbasis SQLite lokal (`sqflite`).
   - Fitur ekspor rekapitulasi audit limbah ke format CSV standar via WhatsApp atau Email.

---

## 📁 Struktur Direktori Proyek

```text
texcycle/
├── .github/
│   └── workflows/
│       └── flutter_ci.yml            # 🤖 Otomasi CI/CD GitHub Actions (Lint & Test)
├── assets/
│   ├── icons/                        # Aset ikon aplikasi resmi
│   └── models/
│       ├── texcycle_model.tflite     # Model inferensi TFLite di perangkat
│       └── labels.txt                # Label 8 kelas klasifikasi limbah
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── diy_data.dart         # Master data 6 tutorial DIY dwibahasa
│   │   │   └── waste_data.dart       # Master 8 kelas limbah, estimasi harga, SOP B3
│   │   ├── database/
│   │   │   └── database_helper.dart  # Pengelola SQLite lokal (scans table + indexing)
│   │   └── localization/
│   │       └── app_locale.dart       # Kamus dwibahasa (ID/EN) & reactive state notifier
│   ├── models/
│   │   └── scan_record.dart          # Data model entitas riwayat pemindaian
│   ├── services/
│   │   ├── classifier_service.dart   # Mesin inferensi TFLite on-device (224x224)
│   │   └── csv_export_service.dart   # Ekspor & bagikan CSV via share_plus
│   ├── views/
│   │   ├── guide_view.dart           # Panduan tutorial upcycling offline
│   │   ├── history_view.dart         # Riwayat scan + pencarian + filter + ekspor
│   │   ├── home_view.dart            # Dashboard ringkasan & statistik
│   │   ├── result_view.dart          # Layar hasil klasifikasi & SOP B3
│   │   ├── scan_view.dart            # Viewfinder kamera pemindai limbah
│   │   ├── settings_view.dart        # Pengaturan bahasa, reset data, & info app
│   │   └── splash_view.dart          # Layar pembuka & inisialisasi modul
│   └── main.dart                     # Entry point & inisialisasi aplikasi
├── test/
│   ├── unit_test.dart                # Pengujian unit klasifikasi, model, & dwibahasa
│   └── widget_test.dart              # Pengujian widget & navigasi antarmuka
├── DOKUMENTASI_TEXCYCLE.md           # 📖 Dokumentasi teknis lengkap (Bahasa Indonesia)
├── DOKUMENTASI_TEXCYCLE_EN.md        # 📖 Technical documentation (English US)
├── DOKUMENTASI_TEXCYCLE_ID.pdf       # 📄 Dokumen PDF resmi siap cetak (Bahasa Indonesia)
├── DOKUMENTASI_TEXCYCLE_EN.pdf       # 📄 Official PDF documentation ready to print (English)
├── texcycle_training.ipynb           # 🧠 Notebook pelatihan AI (Google Colab GPU)
└── pubspec.yaml                      # Konfigurasi dependensi & versi aplikasi
```

---

## 🚀 Panduan Membuka & Menjalankan Aplikasi

### 1. Membuka di Antigravity IDE
1. Jalankan **Antigravity IDE**.
2. Buka menu **File** > **Open Folder...** (atau tekan `Ctrl + K, Ctrl + O`).
3. Pilih folder direktori repositori ini (`texcycle`).

### 2. Mengambil Dependensi
Buka terminal terintegrasi di Antigravity IDE:
```bash
flutter pub get
```

### 3. Menjalankan Aplikasi

* **Untuk Pengujian Visual UI/UX Cepat (Chrome Web)**:
  ```bash
  flutter run -d chrome
  ```
* **Untuk Pengujian Fungsionalitas Penuh (Kamera, TFLite AI, & SQLite)**:
  Hubungkan smartphone Android dengan mode *USB Debugging* aktif atau jalankan Android Emulator:
  ```bash
  flutter run -d android
  ```

### 4. Menjalankan Suite Pengujian Otomatis
Pastikan seluruh 15 pengujian lolos sebelum melakukan commit:
```bash
flutter test
```

---

## 📚 Dokumentasi Resmi Proyek

Untuk pembahasan arsitektur mendalam, analisis model AI, dasar hukum SOP DLH, dan evaluasi pengujian:
* [Dokumentasi Lengkap (Bahasa Indonesia)](DOKUMENTASI_TEXCYCLE.md) | [Unduh PDF (ID)](DOKUMENTASI_TEXCYCLE_ID.pdf)
* [Full Documentation (English US)](DOKUMENTASI_TEXCYCLE_EN.md) | [Download PDF (EN)](DOKUMENTASI_TEXCYCLE_EN.pdf)

---

## 🏷️ Riwayat Rilis & Semantic Versioning

* **v1.3.0** (*Production Release - Current*): Sistem dwibahasa menyeluruh (UI & Konten Data), penyesuaian 15 unit/widget test, dokumentasi teknis dwibahasa PDF & Markdown, serta inisialisasi CI/CD GitHub Actions.
* **v1.2.0**: Rilis *Advance Lens Edition* dengan Edge AI TFLite on-device dan database riwayat SQLite.
* **v1.0.0**: Rilis prototipe awal klasifikasi limbah tekstil konveksi.
