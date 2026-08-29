import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../core/constants/waste_data.dart';
import '../core/constants/diy_data.dart';
import '../core/database/database_helper.dart';
import '../core/localization/app_locale.dart';
import '../models/scan_record.dart';
import '../services/classifier_service.dart';
import 'guide_view.dart';
import 'scan_view.dart';

class ResultView extends StatefulWidget {
  final File imageFile;
  final ClassificationResult classification;

  const ResultView({
    super.key,
    required this.imageFile,
    required this.classification,
  });

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;
  bool _isSaved = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveToDatabase() async {
    if (_isSaved) return;

    setState(() => _isSaving = true);
    File? savedImageFile;

    try {
      // 1. Kompresi gambar: resize lebar 640px, JPG quality 70% (Anomali #4 & Spesifikasi 8.2)
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final targetPath = '${appDir.path}/$fileName';

      final rawBytes = await widget.imageFile.readAsBytes();
      final decoded = img.decodeImage(rawBytes);

      if (decoded != null) {
        final resized = img.copyResize(decoded, width: 640);
        final compressedBytes = img.encodeJpg(resized, quality: 70);
        savedImageFile = File(targetPath);
        await savedImageFile.writeAsBytes(compressedBytes);
      } else {
        // Fallback jika decoding gagal
        savedImageFile = await widget.imageFile.copy(targetPath);
      }

      // 2. Insert ke SQLite dengan Transaction Rollback (Anomali #7)
      final nowStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final record = ScanRecord(
        imagePath: savedImageFile.path,
        jenisId: widget.classification.jenisId,
        labelNama: widget.classification.labelNama,
        kategoriB3: widget.classification.isB3 ? 1 : 0,
        confidence: widget.classification.confidence,
        isUncertain: widget.classification.isUncertain ? 1 : 0,
        catatan: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        createdAt: nowStr,
      );

      await DatabaseHelper.instance.insertScan(record);

      if (mounted) {
        setState(() {
          _isSaving = false;
          _isSaved = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF2E7D32),
            content: Text('Riwayat identifikasi dan foto berhasil disimpan.'),
          ),
        );
      }
    } catch (e) {
      // ROLLBACK: Jika insert DB gagal, hapus file gambar yang sempat tersimpan agar tidak jadi orphan
      if (savedImageFile != null && await savedImageFile.exists()) {
        try {
          await savedImageFile.delete();
        } catch (_) {}
      }

      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = WasteData.getCategory(widget.classification.jenisId);
    final isB3 = widget.classification.isB3;
    final isUncertain = widget.classification.isUncertain;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: isB3 ? const Color(0xFFC62828) : const Color(0xFF1B5E20),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppText.resultTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto Limbah & Status Badge
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  kIsWeb
                      ? Container(
                          height: 200,
                          width: double.infinity,
                          color: const Color(0xFFE8F5E9),
                          child: const Center(
                            child: Icon(Icons.recycling, size: 72, color: Color(0xFF2E7D32)),
                          ),
                        )
                      : Image.file(
                          widget.imageFile,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          cacheWidth: 800,
                        ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.analytics_outlined, color: Colors.greenAccent, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${AppLocale.isEn ? 'Confidence' : 'Akurasi'}: ${(widget.classification.confidence * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isUncertain)
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              AppLocale.isEn ? 'Verify' : 'Perlu Verifikasi',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isB3 ? Colors.red.shade800 : Colors.green.shade800,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: Text(
                            isB3
                                ? (AppLocale.isEn ? 'Hazardous (B3)' : 'Kategori B3')
                                : (AppLocale.isEn ? 'Eco-Friendly (Non-B3)' : 'Kategori Non-B3'),
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Banner jika akurasi 50% - 70% (Anomali #5)
            if (isUncertain) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade900, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.classification.pesanValidasi,
                        style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Card Nama Jenis & Deskripsi
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: category.color.withValues(alpha: 0.15),
                          child: Icon(category.icon, color: category.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.nama,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Ukuran/Bentuk: ${category.ukuran}',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      category.deskripsi,
                      style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Rekomendasi Upcycling (Non-B3) atau SOP DLH (B3)
            if (!isB3) ...[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Color(0xFF1B5E20), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Rekomendasi & Potensi Nilai Ekonomi',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B5E20)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...category.rekomendasi.map(
                        (rekom) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            rekom,
                            style: const TextStyle(fontSize: 13, height: 1.35),
                          ),
                        ),
                      ),
                      if (category.estimasiHarga.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.monetization_on_outlined, color: Colors.green, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Estimasi Nilai Jual: ${category.estimasiHarga}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Integrasi Rekomendasi Kreasi Proyek DIY Langsung (Seamless)
              const SizedBox(height: 14),
              Builder(
                builder: (context) {
                  final matchingTutorials = DIYData.getTutorialsForCategory(widget.classification.jenisId);
                  if (matchingTutorials.isEmpty) return const SizedBox.shrink();

                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: Colors.teal.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.palette_outlined, color: Colors.teal.shade800, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Ide Kreasi & Proyek Daur Ulang DIY',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.teal.shade900),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Limbah ini dapat langsung disulap menjadi produk bernilai tambah tinggi dengan panduan berikut:',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.3),
                          ),
                          const SizedBox(height: 12),
                          ...matchingTutorials.map((tutorial) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.teal.shade100),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal.shade100,
                                  child: Icon(tutorial.icon, color: Colors.teal.shade900, size: 20),
                                ),
                                title: Text(
                                  tutorial.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                subtitle: Row(
                                  children: [
                                    Icon(Icons.timer_outlined, size: 12, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(tutorial.duration, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                                    const SizedBox(width: 10),
                                    Icon(Icons.stars_outlined, size: 12, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(tutorial.difficulty, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(),
                                        const Row(
                                          children: [
                                            Icon(Icons.inventory_2_outlined, size: 15, color: Colors.teal),
                                            SizedBox(width: 6),
                                            Text('Alat & Bahan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        ...tutorial.materials.map((m) => Padding(
                                          padding: const EdgeInsets.only(bottom: 2.0),
                                          child: Text('• $m', style: const TextStyle(fontSize: 11)),
                                        )),
                                        const SizedBox(height: 8),
                                        const Row(
                                          children: [
                                            Icon(Icons.format_list_numbered, size: 15, color: Colors.teal),
                                            SizedBox(width: 6),
                                            Text('Langkah Pembuatan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        ...tutorial.steps.map((s) => Padding(
                                          padding: const EdgeInsets.only(bottom: 3.0),
                                          child: Text(s, style: const TextStyle(fontSize: 11, height: 1.35)),
                                        )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              Card(
                color: const Color(0xFFFFF8F8),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.red.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.red.shade800, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '5 Prosedur Standar DLH (Kategori B3)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red.shade900),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...category.prosedurB3.map(
                        (sop) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            sop,
                            style: const TextStyle(fontSize: 13, height: 1.35, color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.phone_in_talk, color: Colors.red, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Kontak Darurat / Layanan DLH: Hubungi kantor DLH Kabupaten/Kota terdekat untuk konsultasi manifest limbah.',
                                style: TextStyle(fontSize: 11, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),

            // Input Catatan / Estimasi Bobot
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.edit_note, size: 20, color: Colors.black87),
                        SizedBox(width: 6),
                        Text(
                          'Catatan Tambahan (Opsional):',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Sisa kain katun combed, berat ±2.5 kg',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Aksi
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSaved ? Colors.grey : const Color(0xFF1B5E20),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: (_isSaving || _isSaved) ? null : _saveToDatabase,
              icon: _isSaving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Icon(_isSaved ? Icons.check : Icons.save),
              label: Text(
                _isSaved
                    ? (AppLocale.isEn ? 'Saved to History' : 'Sudah Tersimpan di Riwayat')
                    : AppText.btnSaveRecord,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),

            if (!isB3) ...[
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1B5E20),
                  side: const BorderSide(color: Color(0xFF1B5E20)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GuideView()),
                  );
                },
                icon: const Icon(Icons.menu_book),
                label: Text(
                  AppLocale.isEn ? 'Open DIY Upcycling Guides' : 'Buka Tutorial Upcycling DIY',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],

            TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanView()),
                );
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocale.isEn ? 'Scan Another Fabric' : 'Scan Limbah Lain'),
            ),
          ],
        ),
      ),
    );
  }
}
