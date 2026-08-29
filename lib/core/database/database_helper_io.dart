import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/scan_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('texcycle.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          try {
            await db.execute('ALTER TABLE scans ADD COLUMN is_uncertain INTEGER DEFAULT 0');
          } catch (_) {}
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        jenis_id TEXT NOT NULL,
        label_nama TEXT NOT NULL,
        kategori_b3 INTEGER NOT NULL,
        confidence REAL NOT NULL,
        is_uncertain INTEGER DEFAULT 0,
        catatan TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('CREATE INDEX idx_scans_created_at ON scans(created_at)');
    await db.execute('CREATE INDEX idx_scans_b3 ON scans(kategori_b3)');
  }

  Future<int> insertScan(ScanRecord scan) async {
    final db = await instance.database;
    return await db.insert('scans', scan.toMap());
  }

  Future<List<ScanRecord>> getAllScans({
    String? filterStatus,
    String? searchQuery,
  }) async {
    final db = await instance.database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (filterStatus == 'non_b3') {
      whereClause += 'kategori_b3 = 0';
    } else if (filterStatus == 'b3') {
      whereClause += 'kategori_b3 = 1';
    } else if (filterStatus == 'uncertain') {
      whereClause += 'is_uncertain = 1';
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += '(label_nama LIKE ? OR catatan LIKE ?)';
      whereArgs.add('%${searchQuery.trim()}%');
      whereArgs.add('%${searchQuery.trim()}%');
    }

    final result = await db.query(
      'scans',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'created_at DESC',
    );

    return result.map((json) => ScanRecord.fromMap(json)).toList();
  }

  Future<Map<String, dynamic>> getStats30Days() async {
    final db = await instance.database;
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30)).toIso8601String();
    final sevenDaysAgo = now.subtract(const Duration(days: 7)).toIso8601String();

    final recentResult = await db.query(
      'scans',
      where: 'created_at >= ?',
      whereArgs: [thirtyDaysAgo],
    );

    int total = recentResult.length;
    int b3 = 0;
    int nonB3 = 0;
    int b3Last7Days = 0;
    int uncertainCount = 0;

    for (var row in recentResult) {
      int isB3 = row['kategori_b3'] as int;
      int isUncertain = (row['is_uncertain'] as int?) ?? 0;
      String createdAt = row['created_at'] as String;
      if (isB3 == 1) {
        b3++;
        if (createdAt.compareTo(sevenDaysAgo) >= 0) {
          b3Last7Days++;
        }
      } else {
        nonB3++;
      }
      if (isUncertain == 1) {
        uncertainCount++;
      }
    }

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
    final db = await instance.database;
    final dbPath = await getDatabasesPath();
    final dbFile = File(join(dbPath, 'texcycle.db'));
    int dbBytes = 0;
    if (await dbFile.exists()) {
      dbBytes = await dbFile.length();
    }

    final allScans = await db.query('scans', columns: ['image_path']);
    int imagesBytes = 0;
    int photoCount = 0;

    for (var row in allScans) {
      final path = row['image_path'] as String;
      try {
        final f = File(path);
        if (await f.exists()) {
          imagesBytes += await f.length();
          photoCount++;
        }
      } catch (_) {}
    }

    int totalBytes = dbBytes + imagesBytes;
    double totalMb = totalBytes / (1024 * 1024);

    return {
      'total_bytes': totalBytes,
      'total_mb': totalMb,
      'photo_count': photoCount,
      'db_size_kb': (dbBytes / 1024).toStringAsFixed(1),
    };
  }

  Future<int> deleteScan(int id, {String? imagePath}) async {
    final db = await instance.database;
    if (imagePath != null) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}
    }
    return await db.delete('scans', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteScansOlderThanMonths(int months) async {
    final db = await instance.database;
    final cutoffDate = DateTime.now().subtract(Duration(days: months * 30)).toIso8601String();

    final oldRows = await db.query(
      'scans',
      columns: ['image_path'],
      where: 'created_at < ?',
      whereArgs: [cutoffDate],
    );

    for (var row in oldRows) {
      final path = row['image_path'] as String;
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }

    return await db.delete('scans', where: 'created_at < ?', whereArgs: [cutoffDate]);
  }

  Future<int> clearAll() async {
    final db = await instance.database;
    final allRows = await db.query('scans', columns: ['image_path']);
    for (var row in allRows) {
      final path = row['image_path'] as String;
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
    return await db.delete('scans');
  }
}
