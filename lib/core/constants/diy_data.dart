import 'package:flutter/material.dart';

class TutorialItem {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String difficulty;
  final List<String> materials;
  final List<String> steps;
  final IconData icon;

  const TutorialItem({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.materials,
    required this.steps,
    required this.icon,
  });
}

class DIYData {
  static const List<TutorialItem> tutorials = [
    TutorialItem(
      id: 'diy_tote_bag',
      title: 'Membuat Tote Bag Belanja Ramah Lingkungan',
      category: 'kain_besar',
      duration: '30 Menit',
      difficulty: 'Mudah',
      icon: Icons.shopping_bag_outlined,
      materials: [
        'Potongan kain perca besar ukuran minimal 35 x 40 cm (2 lembar)',
        'Kain tali tas ukuran 8 x 60 cm (2 helai)',
        'Benang jahit & mesin jahit / jarum tangan',
        'Gunting kain dan peniti / jarum pentul',
      ],
      steps: [
        '1. Ratakan potongan 2 lembar kain badan tas, posisikan sisi bermotif saling berhadapan.',
        '2. Jahit bagian samping kanan, kiri, dan bagian bawah dengan jarak kampuh 1 cm.',
        '3. Lipat tepi atas tas selebar 2 cm ke arah dalam lalu jahit tindas keliling.',
        '4. Lipat tali tas memanjang, jahit sisinya, lalu pasang di tepi atas depan dan belakang.',
        '5. Balik tas ke sisi luar dan rapikan sudut-sudutnya. Tote bag siap dipakai!',
      ],
    ),
    TutorialItem(
      id: 'diy_pouch',
      title: 'Membuat Dompet Koin & Pouch Kosmetik',
      category: 'kain_sedang',
      duration: '20 Menit',
      difficulty: 'Sangat Mudah',
      icon: Icons.wallet_outlined,
      materials: [
        'Kain perca ukuran 15 x 20 cm (2 lembar luar, 2 lembar furing/dalam)',
        'Resleting ukuran 15 cm',
        'Benang jahit & gunting',
      ],
      steps: [
        '1. Jepit resleting di antara kain luar dan kain furing, jahit di sepanjang resleting.',
        '2. Lakukan hal yang sama untuk sisi seberang resleting.',
        '3. Buka resleting separuh jalan (penting agar dompet bisa dibalik nantinya).',
        '4. Satukan kain luar dengan kain luar, dan kain furing dengan furing, jahit sekelilingnya dan sisakan lubang 5 cm pada furing.',
        '5. Balik dompet melalui lubang furing, jahit tutup lubangnya, lalu rapikan!',
      ],
    ),
    TutorialItem(
      id: 'diy_masker',
      title: 'Membuat Masker Kain 3-Lapis Reusable',
      category: 'kain_sedang',
      duration: '25 Menit',
      difficulty: 'Sedang',
      icon: Icons.masks_outlined,
      materials: [
        'Kain perca katun (lembut & breathable) ukuran 18 x 20 cm (2 lembar)',
        'Kain spunbond / furing filter (1 lembar)',
        'Tali elastis masker 20 cm (2 buah)',
      ],
      steps: [
        '1. Tumpuk kain katun bagian luar, kain filter di tengah, dan kain katun bagian dalam.',
        '2. Jahit sisi atas dan bawah dengan kampuh 0.8 cm.',
        '3. Buat 3 lipatan ploi searah di kedua sisi kanan-kiri dan semat jarum pentul.',
        '4. Jahit lipatan ploi sekaligus memasang tali elastis di kedua ujungnya.',
        '5. Setrika masker agar rapi dan steril sebelum digunakan.',
      ],
    ),
    TutorialItem(
      id: 'diy_bros',
      title: 'Membuat Bros Bunga & Ikat Rambut (Scrunchie)',
      category: 'kain_kecil',
      duration: '15 Menit',
      difficulty: 'Sangat Mudah',
      icon: Icons.local_florist_outlined,
      materials: [
        'Potongan kain perca kecil (5 lingkaran diameter 7 cm)',
        'Peniti bros atau kancing bekas sebagai putik bunga',
        'Lem tembak atau benang jahit',
        'Karet elastis (jika membuat scrunchie)',
      ],
      steps: [
        '1. Lipat setiap lingkaran kain menjadi setengah lingkaran, lalu lipat lagi menjadi seperempat lingkaran (bentuk kelopak).',
        '2. Jelujur bagian dasar kelopak dengan benang, tarik hingga mengkerut.',
        '3. Sambungkan kelima kelopak hingga membentuk lingkaran bunga mekar.',
        '4. Pasang kancing hias di bagian tengah sebagai putik bunga dengan lem tembak.',
        '5. Tempelkan peniti bros di bagian belakang kain.',
      ],
    ),
    TutorialItem(
      id: 'diy_benang',
      title: 'Kreasi Rumbai Etnik & Ornamen Gantungan Kunci',
      category: 'benang',
      duration: '15 Menit',
      difficulty: 'Mudah',
      icon: Icons.stream,
      materials: [
        'Kumpulan sisa benang jahit / obras beraneka warna',
        'Karton bekas ukuran 5 x 8 cm sebagai cetakan lilitan',
        'Ring gantungan kunci',
      ],
      steps: [
        '1. Lilitkan sisa benang pada karton sebanyak 40-50 lilitan.',
        '2. Masukkan seutas benang di bagian atas lilitan lalu ikat simpul mati.',
        '3. Potong benang di ujung bawah karton.',
        '4. Lilitkan benang pengikat di leher rumbai (sekitar 1 cm dari puncak).',
        '5. Gunting dan ratakan ujung rumbai, lalu pasang ring gantungan kunci.',
      ],
    ),
    TutorialItem(
      id: 'diy_kemasan',
      title: 'Wadah Pensil Meja dari Silinder Karton & Perca',
      category: 'kemasan',
      duration: '15 Menit',
      difficulty: 'Sangat Mudah',
      icon: Icons.inventory_2_outlined,
      materials: [
        'Silinder karton bekas gulungan kain / kelos benang besar',
        'Kain perca bermotif untuk pelapis luar',
        'Karton tebal untuk alas lingkaran bawah',
        'Lem tembak / lem serbaguna',
      ],
      steps: [
        '1. Potong silinder karton setinggi 10-12 cm sesuai kebutuhan wadah.',
        '2. Buat alas melingkar dari karton tebal dan rekatkan pada salah satu ujung silinder.',
        '3. Oleskan lem pada permukaan luar silinder karton secara merata.',
        '4. Balutkan kain perca dengan rapi dan selipkan sisa tepi kain ke bagian dalam atas dan bawah.',
        '5. Tambahkan hiasan pita atau renda sisa konveksi untuk mempercantik tampilan.',
      ],
    ),
  ];

  static List<TutorialItem> getTutorialsForCategory(String categoryId) {
    return tutorials.where((t) => t.category == categoryId).toList();
  }
}
