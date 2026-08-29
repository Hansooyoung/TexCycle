import 'dart:async';
import '../../models/scan_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init() {
    _seedInitialData();
  }

  final List<ScanRecord> _webStorage = [];
  int _nextId = 1;

  void _seedInitialData() {
    if (_webStorage.isNotEmpty) return;
    _webStorage.addAll([
      ScanRecord(
        id: _nextId++,
        imagePath: 'assets/models/demo_kain.jpg',
        jenisId: 'kain_sedang',
        labelNama: 'Kain Perca - Ukuran Sedang',
        kategoriB3: 0,
        confidence: 0.94,
        isUncertain: 0,
        catatan: 'Katun combed sisa cutting kaos, ±3.5 kg',
        createdAt: '2026-08-28 10:15:00',
      ),
      ScanRecord(
        id: _nextId++,
        imagePath: 'assets/models/demo_sludge.jpg',
        jenisId: 'sludge',
        labelNama: 'Sludge IPAL (Lumpur Endapan Tekstil)',
        kategoriB3: 1,
        confidence: 0.96,
        isUncertain: 0,
        catatan: 'Endapan IPAL bak koagulasi',
        createdAt: '2026-08-27 15:40:00',
      ),
      ScanRecord(
        id: _nextId++,
        imagePath: 'assets/models/demo_benang.jpg',
        jenisId: 'benang',
        labelNama: 'Sisa Benang Jahit & Kelos',
        kategoriB3: 0,
        confidence: 0.91,
        isUncertain: 0,
        catatan: 'Sisa benang obras poliester',
        createdAt: '2026-08-26 11:20:00',
      ),
    ]);
  }

  Future<dynamic> get database async => null;

  Future<int> insertScan(ScanRecord scan) async {
    final newId = _nextId++;
    final recordWithId = ScanRecord(
      id: newId,
      imagePath: scan.imagePath,
      jenisId: scan.jenisId,
      labelNama: scan.labelNama,
      kategoriB3: scan.kategoriB3,
      confidence: scan.confidence,
      isUncertain: scan.isUncertain,
      catatan: scan.catatan,
      createdAt: scan.createdAt,
    );
    _webStorage.insert(0, recordWithId);
    return newId;
  }

  Future<List<ScanRecord>> getAllScans({
    String? filterStatus,
    String? searchQuery,
  }) async {
    var list = List<ScanRecord>.from(_webStorage);

    if (filterStatus == 'non_b3') {
      list = list.where((s) => s.kategoriB3 == 0).toList();
    } else if (filterStatus == 'b3') {
      list = list.where((s) => s.kategoriB3 == 1).toList();
    } else if (filterStatus == 'uncertain') {
      list = list.where((s) => s.isUncertain == 1).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      list = list.where((s) => s.labelNama.toLowerCase().contains(q) || (s.catatan?.toLowerCase().contains(q) ?? false)).toList();
    }

    return list;
  }

  Future<Map<String, dynamic>> getStats30Days() async {
    int total = _webStorage.length;
    int b3 = _webStorage.where((s) => s.kategoriB3 == 1).length;
    int nonB3 = total - b3;
    int b3Last7Days = b3;
    int uncertainCount = _webStorage.where((s) => s.isUncertain == 1).length;

    double percentNonB3 = total > 0 ? (nonB3 / total) * 100 : 0.0;
    double percentB3 = total > 0 ? (b3 / total) * 100 : 0.0;

    return {
      'total': total,
      'non_b3': nonB3,
      'b3': b3,
      'percent_non_b3': percentNonB3,
      'percent_b3': percentB3,
      'b3_last_7_days': b3Last7Days,
      'uncertain_count': uncertainCount,
    };
  }

  Future<Map<String, dynamic>> getStorageUsage() async {
    final totalBytes = _webStorage.length * 52000 + 40960;
    final totalMb = totalBytes / (1024 * 1024);

    return {
      'total_bytes': totalBytes,
      'total_mb': totalMb,
      'photo_count': _webStorage.length,
      'db_size_kb': '40.0',
    };
  }

  Future<int> deleteScan(int id, {String? imagePath}) async {
    _webStorage.removeWhere((s) => s.id == id);
    return 1;
  }

  Future<int> deleteScansOlderThanMonths(int months) async {
    final beforeCount = _webStorage.length;
    _webStorage.clear();
    _seedInitialData();
    return beforeCount - _webStorage.length;
  }

  Future<int> clearAll() async {
    final count = _webStorage.length;
    _webStorage.clear();
    return count;
  }
}
