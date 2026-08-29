import 'package:flutter/material.dart';

class WasteCategory {
  final String id;
  final String nama;
  final String ukuran;
  final bool isB3;
  final String deskripsi;
  final List<String> rekomendasi;
  final String estimasiHarga;
  final List<String> prosedurB3;
  final IconData icon;
  final Color color;

  const WasteCategory({
    required this.id,
    required this.nama,
    required this.ukuran,
    required this.isB3,
    required this.deskripsi,
    required this.rekomendasi,
    this.estimasiHarga = '',
    this.prosedurB3 = const [],
    required this.icon,
    required this.color,
  });
}

class WasteData {
  static const Map<String, WasteCategory> categories = {
    'kain_besar': WasteCategory(
      id: 'kain_besar',
      nama: 'Kain Perca - Ukuran Besar',
      ukuran: '> 30 cm',
      isB3: false,
      deskripsi: 'Potongan kain sisa pola potong dengan ukuran lebar atau panjang di atas 30 cm.',
      rekomendasi: [
        'Pemanfaatan Upcycling: Sangat cocok untuk produk fungsional seperti Tote Bag, Sarung Bantal, atau Apron.',
        'Penjualan Bahan Baku: Dapat dijual ke pengepul tekstil dengan estimasi harga Rp 8.000 - Rp 15.000 / kg.',
        'Penyaluran Komunitas: Setorkan ke Bank Sampah atau mitra industri kerajinan terdekat.',
      ],
      estimasiHarga: 'Rp 8.000 - Rp 15.000 / kg',
      icon: Icons.check_box_outline_blank,
      color: Colors.teal,
    ),
    'kain_sedang': WasteCategory(
      id: 'kain_sedang',
      nama: 'Kain Perca - Ukuran Sedang',
      ukuran: '10 - 30 cm',
      isB3: false,
      deskripsi: 'Potongan kain sisa konveksi dengan ukuran sedang berkisar antara 10 cm hingga 30 cm.',
      rekomendasi: [
        'Pemanfaatan Upcycling: Cocok untuk produk aksesoris seperti Dompet Koin, Pouch Kosmetik, Masker Kain, atau Cempal Dapur.',
        'Penjualan Bahan Baku: Dapat dipasarkan ke pengrajin dengan estimasi harga Rp 5.000 - Rp 10.000 / kg.',
        'Aplikasi Estetika: Cocok sebagai material pembuatan selimut tambal (patchwork quilt) bernilai ekonomi.',
      ],
      estimasiHarga: 'Rp 5.000 - Rp 10.000 / kg',
      icon: Icons.crop_square,
      color: Colors.green,
    ),
    'kain_kecil': WasteCategory(
      id: 'kain_kecil',
      nama: 'Kain Perca - Ukuran Kecil',
      ukuran: '< 10 cm',
      isB3: false,
      deskripsi: 'Sisa potongan kain perca kecil berukuran di bawah 10 cm hasil sisa trimming konveksi.',
      rekomendasi: [
        'Pemanfaatan Upcycling: Cocok untuk aksesoris mini seperti Bros Hijab, Gantungan Kunci, Karet Rambut (Scrunchie).',
        'Material Pengisi: Dapat dicacah halus sebagai bahan pengisi alternatif bantal duduk atau boneka.',
        'Penyaluran Industri: Kumpulkan dalam karung untuk pasokan industri peredam suara atau serat daur ulang.',
      ],
      estimasiHarga: 'Rp 3.000 - Rp 6.000 / kg',
      icon: Icons.border_clear,
      color: Colors.lightGreen,
    ),
    'benang': WasteCategory(
      id: 'benang',
      nama: 'Sisa Benang Jahit & Kelos',
      ukuran: 'Campuran',
      isB3: false,
      deskripsi: 'Kumpulan sisa benang jahit bordir, obras, atau kelos gulungan yang tidak terpakai.',
      rekomendasi: [
        'Pemanfaatan Kerajinan: Berpotensi untuk ornamen rumbai tas, aksesoris macrame mini, atau hiasan etnik.',
        'Daur Ulang Serat: Kumpulkan bersama limbah serat tekstil untuk pasokan industri pemintalan benang daur ulang.',
      ],
      estimasiHarga: 'Rp 2.000 - Rp 5.000 / kg',
      icon: Icons.gesture,
      color: Colors.amber,
    ),
    'kemasan': WasteCategory(
      id: 'kemasan',
      nama: 'Kemasan Plastik & Karton Bahan',
      ukuran: 'Bervariasi',
      isB3: false,
      deskripsi: 'Plastik pembungkus roll kain tekstil, tali rafia, atau silinder karton gulungan.',
      rekomendasi: [
        'Pemisahan Kategori: Pisahkan silinder karton dan plastik pembungkus ke dalam wadah penyimpanan kering.',
        'Penyaluran Daur Ulang: Jual ke Bank Sampah atau pengepul material kertas/plastik daur ulang.',
        'Pemanfaatan Internal: Silinder karton tebal dapat difungsikan kembali sebagai wadah alat jahit atau gulungan pita.',
      ],
      estimasiHarga: 'Rp 2.000 - Rp 4.000 / kg',
      icon: Icons.inventory_2_outlined,
      color: Colors.orange,
    ),
    'limbah_cair': WasteCategory(
      id: 'limbah_cair',
      nama: 'Limbah Cair Pewarna / Zat Kimia',
      ukuran: 'Cair',
      isB3: true,
      deskripsi: 'Air sisa proses pencucian, pewarnaan tekstil, sablon, atau bahan kimia finishing.',
      rekomendasi: [],
      prosedurB3: [
        '1. DILARANG KERAS membuang langsung ke selokan, saluran air umum, atau meresapkan ke tanah.',
        '2. Alirkan ke unit Instalasi Pengolahan Air Limbah (IPAL) skala mikro setempat.',
        '3. Endapkan terlebih dahulu dengan koagulan/flokulan sebelum air baku netral dialirkan.',
        '4. Hubungi petugas Dinas Lingkungan Hidup (DLH) setempat untuk monitoring baku mutu air.',
        '5. Catat volume pembuangan cairan harian pada buku log kepatuhan lingkungan.',
      ],
      icon: Icons.water_drop,
      color: Colors.purple,
    ),
    'sludge': WasteCategory(
      id: 'sludge',
      nama: 'Sludge IPAL (Lumpur Endapan Tekstil)',
      ukuran: 'Padatan basah',
      isB3: true,
      deskripsi: 'Lumpur hasil endapan kimiawi dari sistem pengolahan limbah cair pewarnaan tekstil.',
      rekomendasi: [],
      prosedurB3: [
        '1. WAJIB DISIMPAN di drum/wadah khusus tahan bocor bertanda simbol Limbah B3.',
        '2. JANGAN campur dengan sampah organik atau kain perca non-B3.',
        '3. Simpan di TPS Limbah B3 beratap dengan lantai kedap air dan ventilasi cukup.',
        '4. Kerjasamakan pengangkutan dengan transporter/pengolah limbah B3 resmi berizin KLHK.',
        '5. Laporkan manifest limbah secara berkala ke DLH Kabupaten/Kota setempat.',
      ],
      icon: Icons.warning_amber_rounded,
      color: Colors.red,
    ),
    'majun': WasteCategory(
      id: 'majun',
      nama: 'Majun Kotor (Kain Terkontaminasi Oli/Kimia)',
      ukuran: 'Campuran',
      isB3: true,
      deskripsi: 'Kain perca atau majun yang telah dipakai membersihkan mesin jahit, oli pelumas, atau zat solvent kimia.',
      rekomendasi: [],
      prosedurB3: [
        '1. JANGAN jadikan bahan kerajinan atau dicampur ke kain perca bersih.',
        '2. Simpan dalam wadah tertutup kedap udara untuk mencegah penguapan gas solvent.',
        '3. Jauhkan dari sumber api atau percikan listrik karena berpotensi mudah terbakar.',
        '4. Kumpulkan bersama limbah padat terkontaminasi B3 lainnya.',
        '5. Serahkan penanganan ke pihak pengolah limbah B3 berizin resmi.',
      ],
      icon: Icons.cleaning_services,
      color: Colors.deepOrange,
    ),
  };

  static WasteCategory getCategory(String id) {
    return categories[id] ??
        const WasteCategory(
          id: 'unknown',
          nama: 'Limbah Tekstil Lainnya',
          ukuran: '-',
          isB3: false,
          deskripsi: 'Jenis limbah tekstil umum.',
          rekomendasi: ['Pisahkan limbah menurut jenis bahan dan simpan dalam kondisi kering.'],
          icon: Icons.help_outline,
          color: Colors.grey,
        );
  }
}
