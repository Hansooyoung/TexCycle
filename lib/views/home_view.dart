import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/database/database_helper.dart';
import '../core/localization/app_locale.dart';
import 'scan_view.dart';
import 'history_view.dart';
import 'guide_view.dart';
import 'settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map<String, dynamic> _stats = {
    'total': 0,
    'non_b3': 0,
    'b3': 0,
    'percent_non_b3': 0.0,
    'percent_b3': 0.0,
    'b3_last_7_days': 0,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    final stats = await DatabaseHelper.instance.getStats30Days();
    if (mounted) {
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = AppLocale.isEn ? 'en_US' : 'id_ID';
    final today = DateFormat('dd MMM yyyy', localeCode).format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.recycling, color: Colors.greenAccent, size: 28),
            const SizedBox(width: 8),
            const Text(
              'TexCycle',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white70, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    today,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Kartu Sapaan
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.appTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppText.splashSubtitle,
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kartu Statistik 30 Hari Terakhir
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.insert_chart_outlined, size: 18, color: Color(0xFF1B5E20)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          AppText.stat30Days,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.black87,
                                            letterSpacing: 0.3,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.green.shade200),
                                  ),
                                  child: Text(
                                    AppText.offlineStatus,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(AppText.totalScans, style: const TextStyle(fontSize: 11, color: Colors.blueGrey), overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${_stats['total']}x',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(AppText.nonB3Safe, style: const TextStyle(fontSize: 11, color: Colors.green), overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${_stats['non_b3']} (${(_stats['percent_non_b3'] as double).toStringAsFixed(0)}%)',
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(AppText.b3Hazardous, style: const TextStyle(fontSize: 11, color: Colors.red), overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${_stats['b3']} (${(_stats['percent_b3'] as double).toStringAsFixed(0)}%)',
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red.shade900),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Progress bar perbandingan
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: (_stats['total'] as int == 0)
                                  ? Container(height: 10, color: Colors.grey.shade200)
                                  : Row(
                                      children: [
                                        if ((_stats['non_b3'] as int) > 0)
                                          Expanded(
                                            flex: _stats['non_b3'] as int,
                                            child: Container(height: 10, color: Colors.green),
                                          ),
                                        if ((_stats['b3'] as int) > 0)
                                          Expanded(
                                            flex: _stats['b3'] as int,
                                            child: Container(height: 10, color: Colors.red),
                                          ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Banner Peringatan jika terdeteksi B3 / Sludge minggu ini
                    if ((_stats['b3_last_7_days'] as int) > 0) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFEEBA)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppText.b3WarningTitle,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF856404)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    AppText.b3WarningMsg,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF856404)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // TOMBOL SCAN UTAMA (HERO CTA)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        await Navigator.push(
                           context,
                          MaterialPageRoute(builder: (context) => const ScanView()),
                        );
                        _loadStats();
                      },
                      child: Column(
                        children: [
                          const Icon(Icons.camera_alt_outlined, size: 32, color: Colors.white),
                          const SizedBox(height: 6),
                          Text(
                            AppText.btnScanNow,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppText.distanceGuide,
                            style: const TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Menu Navigasi Cepat
                    Row(
                      children: [
                        Expanded(
                          child: _buildMenuCard(
                            icon: Icons.list_alt,
                            color: Colors.teal,
                            title: AppText.navHistory,
                            subtitle: AppText.quickHistorySubtitle,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const HistoryView()),
                              );
                              _loadStats();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildMenuCard(
                            icon: Icons.lightbulb_outline,
                            color: Colors.amber.shade800,
                            title: AppText.navGuide,
                            subtitle: AppText.quickGuideSubtitle,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const GuideView()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildMenuCard(
                            icon: Icons.settings_outlined,
                            color: Colors.blueGrey,
                            title: AppText.navSettings,
                            subtitle: AppText.quickSettingsSubtitle,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SettingsView()),
                              );
                              _loadStats();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
