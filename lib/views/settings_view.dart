import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../services/csv_export_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Map<String, dynamic> _storageInfo = {
    'total_bytes': 0,
    'total_mb': 0.0,
    'photo_count': 0,
    'db_size_kb': '0.0',
  };
  bool _loadingStorage = true;

  @override
  void initState() {
    super.initState();
    _loadStorageInfo();
  }

  Future<void> _loadStorageInfo() async {
    setState(() => _loadingStorage = true);
    final info = await DatabaseHelper.instance.getStorageUsage();
    if (mounted) {
      setState(() {
        _storageInfo = info;
        _loadingStorage = false;
      });
    }
  }

  Future<void> _exportCsv({bool share = false}) async {
    final scans = await DatabaseHelper.instance.getAllScans();
    if (scans.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Belum ada data scan untuk diekspor.')),
        );
      }
      return;
    }

    try {
      final file = await CsvExportService.exportScansToCsv(scans);
      if (share) {
        await CsvExportService.shareCsv(file);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CSV berhasil disimpan di:\n${file.path}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengekspor data: $e')),
        );
      }
    }
  }

  Future<void> _deleteOlderThan6Months() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data > 6 Bulan?'),
        content: const Text('Tindakan ini akan menghapus riwayat scan dan file gambar yang berumur lebih dari 6 bulan untuk menghemat ruang memori HP.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final count = await DatabaseHelper.instance.deleteScansOlderThanMonths(6);
      await _loadStorageInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count catatan riwayat lama berhasil dibersihkan.')),
        );
      }
    }
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Seluruh Data'),
        content: const Text('Perhatian: Semua riwayat scan, foto limbah terkompresi, dan statistik akan dihapus secara permanen dari perangkat ini.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus Permanen', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.clearAll();
      await _loadStorageInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seluruh data riwayat berhasil direset.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalMb = (_storageInfo['total_mb'] as double).toStringAsFixed(2);
    final photoCount = _storageInfo['photo_count'];
    final dbSize = _storageInfo['db_size_kb'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan & Penyimpanan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Kartu Informasi Penggunaan Storage HP (Anomali #16)
          Card(
            color: Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.green.shade200),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sd_storage_outlined, color: Color(0xFF1B5E20), size: 22),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Kapasitas Penyimpanan Perangkat',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_loadingStorage)
                        const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      else
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.refresh, size: 18, color: Color(0xFF1B5E20)),
                          onPressed: _loadStorageInfo,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$totalMb MB Terpakai',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• $photoCount foto limbah terkompresi (JPG 70%)\n• Ukuran database SQLite: $dbSize KB',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1.3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'MANAJEMEN DATA LOKAL',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.file_download_outlined, color: Colors.green),
                  title: const Text('Ekspor Riwayat ke CSV', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Simpan tabel rekapitulasi limbah di memori HP (Format Excel)', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportCsv(share: false),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share_outlined, color: Colors.blue),
                  title: const Text('Bagikan CSV via WhatsApp / Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Kirim laporan manifest limbah ke DLH atau arsip pribadi', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportCsv(share: true),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined, color: Colors.orange),
                  title: const Text('Hapus Riwayat > 6 Bulan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Bersihkan foto & data lama untuk melegakan memori', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _deleteOlderThan6Months,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                  title: const Text('Hapus Semua Riwayat Data', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red)),
                  subtitle: const Text('Reset total database SQLite dan seluruh foto scan', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _clearAllData,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'INFORMASI APLIKASI',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.eco, color: Colors.green, size: 28),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TexCycle v1.2',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Advance Lens Edition • 100% Offline AI',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'TexCycle adalah platform cerdas mandiri pengelolaan limbah tekstil untuk industri konveksi mikro, penjahit, dan UMKM garmen guna memaksimalkan potensi ekonomi sirkular dan memastikan kepatuhan regulasi lingkungan.\n\nMode: 100% On-Device (Edge Computing & Penyimpanan Terenkripsi Lokal)',
                    style: TextStyle(fontSize: 12, height: 1.4, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
