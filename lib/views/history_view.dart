import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import '../core/constants/waste_data.dart';
import '../core/database/database_helper.dart';
import '../core/localization/app_locale.dart';
import '../models/scan_record.dart';
import '../services/csv_export_service.dart';
import 'scan_view.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<ScanRecord> _scans = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // 'all', 'non_b3', 'b3', 'uncertain'
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadScans();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadScans() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllScans(
      filterStatus: _selectedFilter,
      searchQuery: _searchController.text,
    );
    if (mounted) {
      setState(() {
        _scans = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleExportCsv() async {
    if (_scans.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data riwayat untuk diekspor.')),
      );
      return;
    }

    try {
      final file = await CsvExportService.exportScansToCsv(_scans);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ekspor Laporan Selesai'),
            content: Text('Laporan riwayat telah disimpan di:\n${file.path}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
                onPressed: () {
                  Navigator.pop(context);
                  CsvExportService.shareCsv(file);
                },
                icon: const Icon(Icons.share, color: Colors.white, size: 16),
                label: const Text('Bagikan via WA / Email', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengekspor CSV: $e')),
        );
      }
    }
  }

  Future<void> _deleteScan(ScanRecord scan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan Scan?'),
        content: Text('Yakin ingin menghapus riwayat "${scan.labelNama}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && scan.id != null) {
      await DatabaseHelper.instance.deleteScan(scan.id!, imagePath: scan.imagePath);
      _loadScans();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan scan dihapus.')),
        );
      }
    }
  }

  void _showDetailModal(ScanRecord scan) {
    final file = File(scan.imagePath);
    final category = WasteData.getCategory(scan.jenisId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle Bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    // Foto Riwayat
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: (!kIsWeb && file.existsSync())
                          ? Image.file(file, height: 220, width: double.infinity, fit: BoxFit.cover)
                          : Container(
                              height: 180,
                              color: Colors.green.shade50,
                              child: const Center(child: Icon(Icons.recycling, size: 56, color: Color(0xFF1B5E20))),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Header & Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scan.labelNama,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${scan.createdAt}  •  Akurasi: ${(scan.confidence * 100).toStringAsFixed(1)}%',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: scan.isB3 ? Colors.red.shade800 : Colors.green.shade800,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            scan.isB3 ? 'Kategori B3' : 'Kategori Non-B3',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    if (scan.needsVerification) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.amber, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Hasil ini ditandai Perlu Verifikasi karena tingkat akurasi saat scan berada di rentang 50%-70%.',
                                style: TextStyle(fontSize: 11, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Divider(height: 24),

                    // Catatan Pengguna
                    if (scan.catatan != null && scan.catatan!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.note_alt_outlined, color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Catatan Pengguna:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  const SizedBox(height: 2),
                                  Text(scan.catatan!, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Rekomendasi Lengkap
                    if (!scan.isB3) ...[
                      const Text(
                        'Rekomendasi Pemanfaatan Upcycling:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1B5E20)),
                      ),
                      const SizedBox(height: 8),
                      ...category.rekomendasi.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(r, style: const TextStyle(fontSize: 13, height: 1.35)),
                        ),
                      ),
                      if (category.estimasiHarga.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Estimasi Harga Jual: ${category.estimasiHarga}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green),
                        ),
                      ],
                    ] else ...[
                      const Text(
                        '5 Prosedur Standar DLH (Kategori B3):',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      ...category.prosedurB3.map(
                        (sop) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(sop, style: const TextStyle(fontSize: 13, height: 1.35)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Tombol Hapus Riwayat Ini
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteScan(scan);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Hapus Catatan Scan Ini'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          AppText.historyTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
            tooltip: AppText.exportCsv,
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _handleExportCsv,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Pencarian
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _loadScans(),
                  decoration: InputDecoration(
                    hintText: AppText.searchHint,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _loadScans();
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', '${AppText.filterAll} (${_scans.length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip('non_b3', AppText.filterNonB3),
                      const SizedBox(width: 8),
                      _buildFilterChip('b3', AppText.filterB3),
                      const SizedBox(width: 8),
                      _buildFilterChip('uncertain', AppText.filterVerify),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Daftar Riwayat
          Expanded(
            child: _isLoading
                ? _buildShimmerLoading()
                : _scans.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 56, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                'Belum Ada Riwayat Identifikasi',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800, fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Potret sisa potongan kain atau limbah tekstil untuk mendapatkan taksiran nilai jual dan panduan daur ulang.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.35),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1B5E20),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ScanView()),
                                  ).then((_) => _loadScans());
                                },
                                icon: const Icon(Icons.camera_alt_outlined, size: 16),
                                label: const Text('Mulai Identifikasi'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _scans.length,
                        itemBuilder: (context, index) {
                          final scan = _scans[index];
                          final file = File(scan.imagePath);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 1,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _showDetailModal(scan),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Thumbnail Foto
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: 65,
                                        height: 65,
                                        child: (!kIsWeb && file.existsSync())
                                            ? Image.file(file, fit: BoxFit.cover, cacheWidth: 150)
                                            : Container(
                                                color: Colors.green.shade50,
                                                child: const Icon(Icons.recycling, color: Color(0xFF1B5E20), size: 28),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Detail Informasi
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  scan.labelNama,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (scan.needsVerification)
                                                    Container(
                                                      margin: const EdgeInsets.only(right: 4),
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: Colors.amber.shade100,
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Text(
                                                        'Verifikasi',
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.amber.shade900,
                                                        ),
                                                      ),
                                                    ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: scan.isB3 ? Colors.red.shade50 : Colors.green.shade50,
                                                      borderRadius: BorderRadius.circular(6),
                                                      border: Border.all(
                                                        color: scan.isB3 ? Colors.red.shade200 : Colors.green.shade200,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      scan.isB3 ? 'B3' : 'Non-B3',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: scan.isB3 ? Colors.red.shade800 : Colors.green.shade800,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${scan.createdAt}  •  Akurasi: ${(scan.confidence * 100).toStringAsFixed(1)}%',
                                            style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                                          ),
                                          if (scan.catatan != null && scan.catatan!.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              scan.catatan!,
                                              style: const TextStyle(fontSize: 11, color: Colors.black87),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),

                                    IconButton(
                                      icon: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                                      onPressed: () => _showDetailModal(scan),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E20),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _handleExportCsv,
          icon: const Icon(Icons.file_download_outlined),
          label: const Text('Ekspor Laporan ke CSV (Excel)', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filter, String label) {
    final isSelected = _selectedFilter == filter;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.black87)),
      selected: isSelected,
      selectedColor: const Color(0xFF2E7D32),
      onSelected: (_) {
        setState(() => _selectedFilter = filter);
        _loadScans();
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 140,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
