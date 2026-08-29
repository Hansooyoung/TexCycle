import 'package:universal_io/io.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/scan_record.dart';

class CsvExportService {
  static Future<File> exportScansToCsv(List<ScanRecord> scans) async {
    List<List<dynamic>> rows = [
      [
        'ID',
        'Tanggal & Waktu',
        'ID Jenis Limbah',
        'Nama Jenis Limbah',
        'Kategori Status',
        'Akurasi AI (Confidence)',
        'Catatan / Bobot',
        'Path Foto Lokal',
      ]
    ];

    for (var scan in scans) {
      rows.add([
        scan.id ?? 0,
        scan.createdAt,
        scan.jenisId,
        scan.labelNama,
        scan.isB3 ? 'BERBAHAYA (B3)' : 'AMAN (Non-B3)',
        '${(scan.confidence * 100).toStringAsFixed(1)}%',
        scan.catatan ?? '-',
        scan.imagePath,
      ]);
    }

    String csvData = csv.encode(rows);

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${directory.path}/TexCycle_Laporan_$timestamp.csv');

    return await file.writeAsString(csvData);
  }

  static Future<void> shareCsv(File csvFile) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(csvFile.path)],
        text: 'Laporan Riwayat Pengelolaan Limbah Tekstil - TexCycle (Offline Edition)',
        subject: 'Laporan Limbah Tekstil TexCycle',
      ),
    );
  }
}
