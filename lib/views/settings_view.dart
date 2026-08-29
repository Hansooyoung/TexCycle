import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../core/localization/app_locale.dart';
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
    try {
      final info = await DatabaseHelper.instance.getStorageUsage();
      if (mounted) {
        setState(() {
          _storageInfo = info;
        });
      }
    } catch (_) {
      // Fallback aman jika database belum siap
    } finally {
      if (mounted) {
        setState(() {
          _loadingStorage = false;
        });
      }
    }
  }

  Future<void> _exportCsv({bool share = false}) async {
    final scans = await DatabaseHelper.instance.getAllScans();
    if (scans.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocale.isEn ? 'No scan records to export.' : 'Belum ada data scan untuk diekspor.')),
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
            SnackBar(content: Text('${AppLocale.isEn ? 'CSV saved to:' : 'CSV berhasil disimpan di:'}\n${file.path}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocale.isEn ? 'Export failed:' : 'Gagal mengekspor data:'} $e')),
        );
      }
    }
  }

  Future<void> _deleteOlderThan6Months() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocale.isEn ? 'Delete Records > 6 Months?' : 'Hapus Data > 6 Bulan?'),
        content: Text(AppLocale.isEn
            ? 'This removes older scan records and photos to free up phone storage.'
            : 'Tindakan ini akan menghapus riwayat scan dan file gambar berumur lebih dari 6 bulan untuk melegakan memori.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppText.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppText.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final count = await DatabaseHelper.instance.deleteScansOlderThanMonths(6);
      await _loadStorageInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocale.isEn ? '$count old records cleaned.' : '$count catatan riwayat lama dibersihkan.')),
        );
      }
    }
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppText.deleteAllRecordsBtn),
        content: Text(AppLocale.isEn
            ? 'Caution: All scan history, photos, and metrics will be permanently deleted.'
            : 'Perhatian: Semua riwayat scan, foto limbah, dan statistik akan dihapus permanen dari perangkat ini.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppText.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppText.delete, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.clearAll();
      await _loadStorageInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocale.isEn ? 'All history records cleared.' : 'Seluruh data riwayat berhasil direset.')),
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
        title: Text(
          AppText.settingsTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Pilihan Bahasa (Language Selection Card)
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.translate_rounded, color: Color(0xFF1B5E20), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppText.langPrefTitle,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          AppText.langPrefSubtitle,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'id',
                        label: Text('ID', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      ButtonSegment(
                        value: 'en',
                        label: Text('EN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                    selected: {AppLocale.currentLocale},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        AppLocale.setLocale(newSelection.first);
                      });
                    },
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Kartu Informasi Penggunaan Storage HP
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
                      Expanded(
                        child: Text(
                          AppText.storageTitle,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
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
                    AppLocale.isEn ? '$totalMb MB Used' : '$totalMb MB Terpakai',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocale.isEn
                        ? '• $photoCount compressed waste photos (JPG 70%)\n• SQLite Database: $dbSize KB'
                        : '• $photoCount foto limbah terkompresi (JPG 70%)\n• Ukuran database SQLite: $dbSize KB',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1.3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            AppLocale.isEn ? 'LOCAL DATA MANAGEMENT' : 'MANAJEMEN DATA LOKAL',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.file_download_outlined, color: Colors.green),
                  title: Text(AppText.exportCsv, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(AppLocale.isEn ? 'Save inventory logs to phone storage (Excel format)' : 'Simpan tabel rekapitulasi limbah di memori HP (Format Excel)', style: const TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportCsv(share: false),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share_outlined, color: Colors.blue),
                  title: Text(AppText.shareCsv, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(AppLocale.isEn ? 'Send report via WhatsApp or Email' : 'Kirim laporan manifest limbah ke DLH atau arsip', style: const TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportCsv(share: true),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined, color: Colors.orange),
                  title: Text(AppText.deleteOldRecordsBtn, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(AppLocale.isEn ? 'Clear older records to save storage space' : 'Bersihkan foto & data lama untuk melegakan memori', style: const TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _deleteOlderThan6Months,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                  title: Text(AppText.deleteAllRecordsBtn, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red)),
                  subtitle: Text(AppLocale.isEn ? 'Reset local SQLite database and all photos' : 'Reset total database SQLite dan seluruh foto scan', style: const TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _clearAllData,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(
            AppLocale.isEn ? 'SYSTEM & PRIVACY' : 'INFORMASI & PRIVASI SISTEM',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.eco, color: Colors.green, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppText.appTitle,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              AppText.appVersionLabel,
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppText.privacyDesc,
                    style: const TextStyle(fontSize: 11, height: 1.35, color: Colors.black87),
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
