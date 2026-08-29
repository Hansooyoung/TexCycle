class ScanRecord {
  final int? id;
  final String imagePath;
  final String jenisId;
  final String labelNama;
  final int kategoriB3; // 0 = Non-B3, 1 = B3
  final double confidence; // Nilai 0.0 - 1.0
  final int isUncertain; // 0 = Normal/Yakin (>70%), 1 = Perlu Verifikasi (50%-70%)
  final String? catatan;
  final String createdAt;

  ScanRecord({
    this.id,
    required this.imagePath,
    required this.jenisId,
    required this.labelNama,
    required this.kategoriB3,
    required this.confidence,
    this.isUncertain = 0,
    this.catatan,
    required this.createdAt,
  });

  bool get isB3 => kategoriB3 == 1;
  bool get needsVerification => isUncertain == 1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_path': imagePath,
      'jenis_id': jenisId,
      'label_nama': labelNama,
      'kategori_b3': kategoriB3,
      'confidence': confidence,
      'is_uncertain': isUncertain,
      'catatan': catatan,
      'created_at': createdAt,
    };
  }

  factory ScanRecord.fromMap(Map<String, dynamic> map) {
    return ScanRecord(
      id: map['id'] as int?,
      imagePath: map['image_path'] as String,
      jenisId: map['jenis_id'] as String,
      labelNama: map['label_nama'] as String,
      kategoriB3: map['kategori_b3'] as int,
      confidence: (map['confidence'] as num).toDouble(),
      isUncertain: (map['is_uncertain'] as int?) ?? 0,
      catatan: map['catatan'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
}
