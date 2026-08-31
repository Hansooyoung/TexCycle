import 'package:flutter/material.dart';
import 'package:texcycle/core/localization/app_locale.dart';

class WasteCategory {
  final String id;
  final String namaId;
  final String namaEn;
  final String ukuranId;
  final String ukuranEn;
  final bool isB3;
  final String deskripsiId;
  final String deskripsiEn;
  final List<String> rekomendasiId;
  final List<String> rekomendasiEn;
  final String estimasiHargaId;
  final String estimasiHargaEn;
  final List<String> prosedurB3Id;
  final List<String> prosedurB3En;
  final IconData icon;
  final Color color;

  const WasteCategory({
    required this.id,
    required this.namaId,
    required this.namaEn,
    required this.ukuranId,
    required this.ukuranEn,
    required this.isB3,
    required this.deskripsiId,
    required this.deskripsiEn,
    required this.rekomendasiId,
    required this.rekomendasiEn,
    this.estimasiHargaId = '',
    this.estimasiHargaEn = '',
    this.prosedurB3Id = const [],
    this.prosedurB3En = const [],
    required this.icon,
    required this.color,
  });

  // Dynamic getters according to active AppLocale
  String get nama => AppLocale.isEn ? namaEn : namaId;
  String get ukuran => AppLocale.isEn ? ukuranEn : ukuranId;
  String get deskripsi => AppLocale.isEn ? deskripsiEn : deskripsiId;
  List<String> get rekomendasi => AppLocale.isEn ? rekomendasiEn : rekomendasiId;
  String get estimasiHarga => AppLocale.isEn ? estimasiHargaEn : estimasiHargaId;
  List<String> get prosedurB3 => AppLocale.isEn ? prosedurB3En : prosedurB3Id;
}

class WasteData {
  static const Map<String, WasteCategory> categories = {
    'kain_besar': WasteCategory(
      id: 'kain_besar',
      namaId: 'Kain Perca - Ukuran Besar',
      namaEn: 'Large Fabric Scraps',
      ukuranId: '> 30 cm',
      ukuranEn: '> 30 cm',
      isB3: false,
      deskripsiId: 'Potongan kain sisa pola potong dengan ukuran lebar atau panjang di atas 30 cm.',
      deskripsiEn: 'Fabric pattern offcuts measuring greater than 30 cm in width or length.',
      rekomendasiId: [
        'Pemanfaatan Upcycling: Sangat cocok untuk produk fungsional seperti Tote Bag, Sarung Bantal, atau Apron.',
        'Penjualan Bahan Baku: Dapat dijual ke pengepul tekstil dengan estimasi harga Rp 8.000 - Rp 15.000 / kg.',
        'Penyaluran Komunitas: Setorkan ke Bank Sampah atau mitra industri kerajinan terdekat.',
      ],
      rekomendasiEn: [
        'Upcycling Potential: Ideal for high-utility goods such as Tote Bags, Cushion Covers, or Cooking Aprons.',
        'Scrap Material Trading: Can be sold directly to textile aggregators at \$0.55 - \$1.00 / kg.',
        'Community Donation: Distribute to local circular economy hubs or craft artisans.',
      ],
      estimasiHargaId: 'Rp 8.000 - Rp 15.000 / kg',
      estimasiHargaEn: 'Rp 8,000 - 15,000 / kg',
      icon: Icons.check_box_outline_blank,
      color: Colors.teal,
    ),
    'kain_sedang': WasteCategory(
      id: 'kain_sedang',
      namaId: 'Kain Perca - Ukuran Sedang',
      namaEn: 'Medium Fabric Scraps',
      ukuranId: '10 - 30 cm',
      ukuranEn: '10 - 30 cm',
      isB3: false,
      deskripsiId: 'Potongan kain sisa konveksi dengan ukuran sedang berkisar antara 10 cm hingga 30 cm.',
      deskripsiEn: 'Medium-sized garment offcuts ranging between 10 cm and 30 cm.',
      rekomendasiId: [
        'Pemanfaatan Upcycling: Cocok untuk produk aksesoris seperti Dompet Koin, Pouch Kosmetik, Masker Kain, atau Cempal Dapur.',
        'Penjualan Bahan Baku: Dapat dipasarkan ke pengrajin dengan estimasi harga Rp 5.000 - Rp 10.000 / kg.',
        'Aplikasi Estetika: Cocok sebagai material pembuatan selimut tambal (patchwork quilt) bernilai ekonomi.',
      ],
      rekomendasiEn: [
        'Upcycling Potential: Best for small lifestyle accessories like Coin Purses, Cosmetic Pouches, or Fabric Face Masks.',
        'Scrap Material Trading: Marketable to boutique crafters at \$0.35 - \$0.70 / kg.',
        'Patchwork Utility: Excellent raw material for aesthetic patchwork quilts and placemats.',
      ],
      estimasiHargaId: 'Rp 5.000 - Rp 10.000 / kg',
      estimasiHargaEn: 'Rp 5,000 - 10,000 / kg',
      icon: Icons.crop_square,
      color: Colors.green,
    ),
    'kain_kecil': WasteCategory(
      id: 'kain_kecil',
      namaId: 'Kain Perca - Ukuran Kecil',
      namaEn: 'Small Fabric Scraps',
      ukuranId: '< 10 cm',
      ukuranEn: '< 10 cm',
      isB3: false,
      deskripsiId: 'Sisa potongan kain perca kecil berukuran di bawah 10 cm hasil sisa trimming konveksi.',
      deskripsiEn: 'Fine textile trimming scraps measuring under 10 cm from final pattern cutting.',
      rekomendasiId: [
        'Pemanfaatan Upcycling: Cocok untuk aksesoris mini seperti Bros Hijab, Gantungan Kunci, Karet Rambut (Scrunchie).',
        'Material Pengisi: Dapat dicacah halus sebagai bahan pengisi alternatif bantal duduk atau boneka.',
        'Penyaluran Industri: Kumpulkan dalam karung untuk pasokan industri peredam suara atau serat daur ulang.',
      ],
      rekomendasiEn: [
        'Upcycling Potential: Perfect for micro-accessories such as Brooches, Keychains, and Hair Scrunchies.',
        'Cushion Padding: Can be shredded into eco-filling for throw pillows or soft toys.',
        'Industrial Supply: Aggregate for soundproofing insulation or fiber re-spinning mills.',
      ],
      estimasiHargaId: 'Rp 3.000 - Rp 6.000 / kg',
      estimasiHargaEn: 'Rp 3,000 - 6,000 / kg',
      icon: Icons.border_clear,
      color: Colors.lightGreen,
    ),
    'benang': WasteCategory(
      id: 'benang',
      namaId: 'Sisa Benang Jahit & Kelos',
      namaEn: 'Yarn & Thread Remnants',
      ukuranId: 'Campuran',
      ukuranEn: 'Mixed Spools',
      isB3: false,
      deskripsiId: 'Kumpulan sisa benang jahit bordir, obras, atau kelos gulungan yang tidak terpakai.',
      deskripsiEn: 'Assorted remnants of sewing, embroidery, and overlock threads and empty cones.',
      rekomendasiId: [
        'Pemanfaatan Kerajinan: Berpotensi untuk ornamen rumbai tas, aksesoris macrame mini, atau hiasan etnik.',
        'Daur Ulang Serat: Kumpulkan bersama limbah serat tekstil untuk pasokan industri pemintalan benang daur ulang.',
      ],
      rekomendasiEn: [
        'Craft Applications: Ideal for decorative tassel charms, mini-macrame, or ethnic garment embellishments.',
        'Fiber Reclamation: Batch with pure cotton/poly fibers for mechanical yarn recycling.',
      ],
      estimasiHargaId: 'Rp 2.000 - Rp 5.000 / kg',
      estimasiHargaEn: 'Rp 2,000 - 5,000 / kg',
      icon: Icons.gesture,
      color: Colors.amber,
    ),
    'kemasan': WasteCategory(
      id: 'kemasan',
      namaId: 'Kemasan Plastik & Karton Bahan',
      namaEn: 'Packaging Plastic & Paper Spools',
      ukuranId: 'Bervariasi',
      ukuranEn: 'Various Sizes',
      isB3: false,
      deskripsiId: 'Plastik pembungkus roll kain tekstil, tali rafia, atau silinder karton gulungan.',
      deskripsiEn: 'Plastic fabric bolt wrapping, banding straps, and heavy cardboard core tubes.',
      rekomendasiId: [
        'Pemisahan Kategori: Pisahkan silinder karton dan plastik pembungkus ke dalam wadah penyimpanan kering.',
        'Penyaluran Daur Ulang: Jual ke Bank Sampah atau pengepul material kertas/plastik daur ulang.',
        'Pemanfaatan Internal: Silinder karton tebal dapat difungsikan kembali sebagai wadah alat jahit atau gulungan pita.',
      ],
      rekomendasiEn: [
        'Source Segregation: Separate cardboard tubes and clean polythene wrap into dry bins.',
        'Recycling Channels: Sell directly to municipal paper/plastic reclaimers.',
        'Internal Utility: Heavy paper spools make excellent studio organizers and ribbon dispensers.',
      ],
      estimasiHargaId: 'Rp 2.000 - Rp 4.000 / kg',
      estimasiHargaEn: 'Rp 2,000 - 4,000 / kg',
      icon: Icons.inventory_2_outlined,
      color: Colors.orange,
    ),
    'limbah_cair': WasteCategory(
      id: 'limbah_cair',
      namaId: 'Limbah Cair Pewarna / Zat Kimia',
      namaEn: 'Liquid Dye & Chemical Effluent',
      ukuranId: 'Cair',
      ukuranEn: 'Liquid',
      isB3: true,
      deskripsiId: 'Air sisa proses pencucian, pewarnaan tekstil, sablon, atau bahan kimia finishing.',
      deskripsiEn: 'Wastewater containing synthetic dyes, screen printing binders, or finishing chemicals.',
      rekomendasiId: [],
      rekomendasiEn: [],
      prosedurB3Id: [
        '1. DILARANG KERAS membuang langsung ke selokan, saluran air umum, atau meresapkan ke tanah.',
        '2. Alirkan ke unit Instalasi Pengolahan Air Limbah (IPAL) skala mikro setempat.',
        '3. Endapkan terlebih dahulu dengan koagulan/flokulan sebelum air baku netral dialirkan.',
        '4. Hubungi petugas Dinas Lingkungan Hidup (DLH) setempat untuk monitoring baku mutu air.',
        '5. Catat volume pembuangan cairan harian pada buku log kepatuhan lingkungan.',
      ],
      prosedurB3En: [
        '1. STRICTLY FORBIDDEN to discharge into municipal gutters, waterways, or soil absorption.',
        '2. Route directly into an approved micro-scale Effluent Treatment Plant (ETP).',
        '3. Neutralize and flocculate chemical colorants before testing effluent pH compliance.',
        '4. Coordinate with local Environmental Agency (DLH) inspectors for quality validation.',
        '5. Maintain a daily chemical discharge log for environmental regulatory compliance.',
      ],
      icon: Icons.water_drop,
      color: Colors.purple,
    ),
    'sludge': WasteCategory(
      id: 'sludge',
      namaId: 'Sludge IPAL (Lumpur Endapan Tekstil)',
      namaEn: 'ETP Chemical Sludge',
      ukuranId: 'Padatan basah',
      ukuranEn: 'Wet Sludge Cake',
      isB3: true,
      deskripsiId: 'Lumpur hasil endapan kimiawi dari sistem pengolahan limbah cair pewarnaan tekstil.',
      deskripsiEn: 'Chemical precipitate sediment recovered from textile effluent clarifiers.',
      rekomendasiId: [],
      rekomendasiEn: [],
      prosedurB3Id: [
        '1. WAJIB DISIMPAN di drum/wadah khusus tahan bocor bertanda simbol Limbah B3.',
        '2. JANGAN campur dengan sampah organik atau kain perca non-B3.',
        '3. Simpan di TPS Limbah B3 beratap dengan lantai kedap air dan ventilasi cukup.',
        '4. Kerjasamakan pengangkutan dengan transporter/pengolah limbah B3 resmi berizin KLHK.',
        '5. Laporkan manifest limbah secara berkala ke DLH Kabupaten/Kota setempat.',
      ],
      prosedurB3En: [
        '1. MUST BE STORED in heavy-duty, leak-proof hazardous waste drums marked with B3 placards.',
        '2. NEVER mix with municipal solid waste or non-hazardous fabric scraps.',
        '3. Secure inside a covered, bunded storage facility with impermeable flooring.',
        '4. Engage licensed ministry-certified (KLHK) hazardous waste disposal contractors.',
        '5. Log hazardous waste manifest chain-of-custody reports with local environmental authorities.',
      ],
      icon: Icons.warning_amber_rounded,
      color: Colors.red,
    ),
    'majun': WasteCategory(
      id: 'majun',
      namaId: 'Majun Kotor (Kain Terkontaminasi Oli/Kimia)',
      namaEn: 'Contaminated Oily Rags (Majun)',
      ukuranId: 'Campuran',
      ukuranEn: 'Mixed Rags',
      isB3: true,
      deskripsiId: 'Kain perca atau majun yang telah dipakai membersihkan mesin jahit, oli pelumas, atau zat solvent kimia.',
      deskripsiEn: 'Textile rags contaminated with machine lubricants, motor oils, or organic solvents.',
      rekomendasiId: [],
      rekomendasiEn: [],
      prosedurB3Id: [
        '1. JANGAN jadikan bahan kerajinan atau dicampur ke kain perca bersih.',
        '2. Simpan dalam wadah tertutup kedap udara untuk mencegah penguapan gas solvent.',
        '3. Jauhkan dari sumber api atau percikan listrik karena berpotensi mudah terbakar.',
        '4. Kumpulkan bersama limbah padat terkontaminasi B3 lainnya.',
        '5. Serahkan penanganan ke pihak pengolah limbah B3 berizin resmi.',
      ],
      prosedurB3En: [
        '1. NEVER repurpose into DIY crafts or store alongside clean fabric offcuts.',
        '2. Contain inside airtight steel bins to prevent volatile solvent vapor accumulation.',
        '3. Keep strictly isolated from ignition sources, heat, and open electrical contacts.',
        '4. Aggregate with other class B3 contaminated solid workshop waste.',
        '5. Dispatch exclusively to accredited hazardous waste management facilities.',
      ],
      icon: Icons.cleaning_services,
      color: Colors.deepOrange,
    ),
  };

  static WasteCategory getCategory(String id) {
    return categories[id] ??
        const WasteCategory(
          id: 'unknown',
          namaId: 'Limbah Tekstil Lainnya',
          namaEn: 'Other Textile Waste',
          ukuranId: '-',
          ukuranEn: '-',
          isB3: false,
          deskripsiId: 'Jenis limbah tekstil umum.',
          deskripsiEn: 'General textile workshop waste.',
          rekomendasiId: ['Pisahkan limbah menurut jenis bahan dan simpan dalam kondisi kering.'],
          rekomendasiEn: ['Sort waste by fabric composition and store in a clean, dry location.'],
          icon: Icons.help_outline,
          color: Colors.grey,
        );
  }
}
