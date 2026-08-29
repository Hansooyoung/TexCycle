enum ConfidenceTier { high, uncertain, reject }

class ClassificationResult {
  final String jenisId;
  final String labelNama;
  final bool isB3;
  final double confidence;
  final ConfidenceTier tier;
  final bool isConfident; // True jika confidence >= 0.50
  final bool isUncertain; // True jika 0.50 <= confidence < 0.70
  final bool isReject; // True jika confidence < 0.50
  final String pesanValidasi;

  ClassificationResult({
    required this.jenisId,
    required this.labelNama,
    required this.isB3,
    required this.confidence,
    required this.tier,
    required this.isConfident,
    required this.isUncertain,
    required this.isReject,
    this.pesanValidasi = '',
  });
}
