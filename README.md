# ♻️ TexCycle - Mobile Application (Offline Edition)

Aplikasi mobile berbasis Flutter untuk identifikasi dan pengelolaan limbah tekstil industri berskala mikro (UMKM konveksi) menggunakan AI On-Device (Edge Computing) secara **100% Offline**.

---

## 📁 Struktur Direktori Project

```text
C:\Users\Dani\development\flutter\texcycle\
│
├── APK/
│   └── TexCycle_v1.0_Offline.apk    # 📦 File installer APK siap pasang di HP Android (74.9 MB)
│
├── assets/
│   └── models/
│       ├── texcycle_model.tflite     # Model inferensi TFLite di perangkat
│       └── labels.txt                # Label 8 kelas limbah tekstil
│
├── lib/                              # Arsitektur Bersih (Clean & Modular Architecture)
│   ├── core/
│   │   ├── constants/
│   │   │   └── waste_data.dart       # Master 8 kelas limbah, rekomendasi upcycling, SOP B3 DLH
│   │   └── database/
│   │       └── database_helper.dart  # Pengelola SQLite lokal (scans table + indexing)
│   ├── models/
│   │   └── scan_record.dart          # Data model entitas riwayat scan
│   ├── services/
│   │   ├── classifier_service.dart   # Mesin inferensi TFLite on-device (224x224, threshold >= 60%)
│   │   └── csv_export_service.dart   # Ekspor & bagikan CSV via WhatsApp/Email
│   ├── views/
│   │   ├── home_view.dart            # Dashboard beranda + statistik 30 hari + banner peringatan
│   │   ├── scan_view.dart            # Viewfinder kamera + grid framing jarak 30-40 cm
│   │   ├── result_view.dart          # Hasil identifikasi Non-B3/B3 + SOP DLH + simpan ke DB
│   │   ├── history_view.dart         # Riwayat scan + pencarian + filter status + ekspor CSV
│   │   ├── guide_view.dart           # 5 Tutorial DIY upcycling offline
│   │   └── settings_view.dart        # Manajemen data, reset, dan info aplikasi
│   └── main.dart                     # Entry point & inisialisasi SQLite/Intl
│
├── texcycle_training.ipynb           # 🧠 Jupyter Notebook lengkap untuk training GPU di Google Colab
├── android/                          # Konfigurasi native Android (Permissions, Gradle, NDK)
└── pubspec.yaml                      # Dependensi Flutter (sqflite, tflite_flutter, share_plus, dll)
```

---

## 🚀 Cara Menjalankan & Mengembangkan

### 1. Membuka di VS Code
Buka terminal dan ketik:
```bash
code C:\Users\Dani\development\flutter\texcycle
```

### 2. Menjalankan di HP / Emulator Android
Pastikan HP Android terhubung dengan USB Debugging aktif:
```bash
cd C:\Users\Dani\development\flutter\texcycle
flutter run
```

### 3. Memasang APK Langsung ke HP
File installer siap pakai sudah tersedia di:
📍 **`C:\Users\Dani\development\flutter\texcycle\APK\TexCycle_v1.0_Offline.apk`**
Tinggal salin ke HP Anda via WhatsApp atau kabel data, lalu pasang (*Install*).

---

## 🧠 Pelatihan Model AI dengan Data Riwayat Asli (Google Colab)

1. Buka [Google Colab](https://colab.research.google.com/).
2. Unggah file `texcycle_training.ipynb`.
3. Pilih **Runtime > Change runtime type > T4 GPU**.
4. Klik **Runtime > Run all**.
5. Colab akan otomatis menghasilkan:
   - `texcycle_model.tflite` (Model terlatih terbaru)
   - `evaluasi_training.png` & `confusion_matrix.png` (Gambar hasil evaluasi untuk Bab IV Paper).
6. Timpa file `texcycle_model.tflite` baru ke folder `assets/models/`.
