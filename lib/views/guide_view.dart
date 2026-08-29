import 'package:flutter/material.dart';
import 'package:texcycle/core/constants/diy_data.dart';

class GuideView extends StatefulWidget {
  const GuideView({super.key});

  @override
  State<GuideView> createState() => _GuideViewState();
}

class _GuideViewState extends State<GuideView> {
  String _selectedCat = 'semua';

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCat == 'semua'
        ? DIYData.tutorials
        : DIYData.tutorials.where((t) => t.category == _selectedCat).toList();

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
          'Panduan Upcycling & Daur Ulang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          // Filter Kategori Bahan
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabChip('semua', 'Semua Tutorial'),
                  const SizedBox(width: 8),
                  _buildTabChip('kain_besar', 'Kain Besar'),
                  const SizedBox(width: 8),
                  _buildTabChip('kain_sedang', 'Kain Sedang'),
                  const SizedBox(width: 8),
                  _buildTabChip('kain_kecil', 'Kain Kecil'),
                  const SizedBox(width: 8),
                  _buildTabChip('benang', 'Sisa Benang'),
                ],
              ),
            ),
          ),

          // Daftar Tutorial
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 1,
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade50,
                      child: Icon(item.icon, color: const Color(0xFF1B5E20)),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(Icons.schedule, size: 12, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(item.duration, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                        const SizedBox(width: 10),
                        Icon(Icons.star_outline, size: 12, color: Colors.amber.shade800),
                        const SizedBox(width: 4),
                        Text(item.difficulty, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
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
                                Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF1B5E20)),
                                SizedBox(width: 6),
                                Text('Alat & Bahan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ...item.materials.map(
                              (m) => Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Expanded(child: Text(m, style: const TextStyle(fontSize: 12))),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Icon(Icons.format_list_numbered, size: 16, color: Color(0xFF1B5E20)),
                                SizedBox(width: 6),
                                Text('Langkah Pembuatan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ...item.steps.map(
                              (s) => Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(s, style: const TextStyle(fontSize: 12, height: 1.35)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String cat, String label) {
    final isSelected = _selectedCat == cat;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.black87)),
      selected: isSelected,
      selectedColor: const Color(0xFF2E7D32),
      onSelected: (_) => setState(() => _selectedCat = cat),
    );
  }
}
