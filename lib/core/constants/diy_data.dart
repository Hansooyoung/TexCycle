import 'package:flutter/material.dart';
import 'package:texcycle/core/localization/app_locale.dart';

class TutorialItem {
  final String id;
  final String titleId;
  final String titleEn;
  final String category;
  final String durationId;
  final String durationEn;
  final String difficultyId;
  final String difficultyEn;
  final List<String> materialsId;
  final List<String> materialsEn;
  final List<String> stepsId;
  final List<String> stepsEn;
  final IconData icon;

  const TutorialItem({
    required this.id,
    required this.titleId,
    required this.titleEn,
    required this.category,
    required this.durationId,
    required this.durationEn,
    required this.difficultyId,
    required this.difficultyEn,
    required this.materialsId,
    required this.materialsEn,
    required this.stepsId,
    required this.stepsEn,
    required this.icon,
  });

  String get title => AppLocale.isEn ? titleEn : titleId;
  String get duration => AppLocale.isEn ? durationEn : durationId;
  String get difficulty => AppLocale.isEn ? difficultyEn : difficultyId;
  List<String> get materials => AppLocale.isEn ? materialsEn : materialsId;
  List<String> get steps => AppLocale.isEn ? stepsEn : stepsId;
}

class DIYData {
  static const List<TutorialItem> tutorials = [
    TutorialItem(
      id: 'diy_tote_bag',
      titleId: 'Membuat Tote Bag Belanja Ramah Lingkungan',
      titleEn: 'Eco-Friendly Grocery Tote Bag',
      category: 'kain_besar',
      durationId: '30 Menit',
      durationEn: '30 Mins',
      difficultyId: 'Mudah',
      difficultyEn: 'Easy',
      icon: Icons.shopping_bag_outlined,
      materialsId: [
        'Potongan kain perca besar ukuran minimal 35 x 40 cm (2 lembar)',
        'Kain tali tas ukuran 8 x 60 cm (2 helai)',
        'Benang jahit & mesin jahit / jarum tangan',
        'Gunting kain dan peniti / jarum pentul',
      ],
      materialsEn: [
        'Large scrap fabric sheets, min 35 x 40 cm (2 pieces)',
        'Fabric strap strips 8 x 60 cm (2 pieces)',
        'Sewing thread & sewing machine / hand needle',
        'Fabric scissors and pins',
      ],
      stepsId: [
        '1. Ratakan potongan 2 lembar kain badan tas, posisikan sisi bermotif saling berhadapan.',
        '2. Jahit bagian samping kanan, kiri, dan bagian bawah dengan jarak kampuh 1 cm.',
        '3. Lipat tepi atas tas selebar 2 cm ke arah dalam lalu jahit tindas keliling.',
        '4. Lipat tali tas memanjang, jahit sisinya, lalu pasang di tepi atas depan dan belakang.',
        '5. Balik tas ke sisi luar dan rapikan sudut-sudutnya. Tote bag siap dipakai!',
      ],
      stepsEn: [
        '1. Align the 2 bag panels with right sides facing each other.',
        '2. Stitch the left, right, and bottom edges with a 1 cm seam allowance.',
        '3. Fold the top opening 2 cm inward and topstitch all around.',
        '4. Fold strap strips lengthwise, stitch edges, and attach firmly to front and back hems.',
        '5. Turn the bag inside-out and push corners neat. Your eco tote bag is ready!',
      ],
    ),
    TutorialItem(
      id: 'diy_pouch',
      titleId: 'Membuat Dompet Koin & Pouch Kosmetik',
      titleEn: 'Zippered Coin & Cosmetic Pouch',
      category: 'kain_sedang',
      durationId: '20 Menit',
      durationEn: '20 Mins',
      difficultyId: 'Sangat Mudah',
      difficultyEn: 'Very Easy',
      icon: Icons.wallet_outlined,
      materialsId: [
        'Kain perca ukuran 15 x 20 cm (2 lembar luar, 2 lembar furing/dalam)',
        'Resleting ukuran 15 cm',
        'Benang jahit & gunting',
      ],
      materialsEn: [
        'Medium fabric scraps 15 x 20 cm (2 outer pieces, 2 lining pieces)',
        '15 cm zipper',
        'Sewing thread & fabric scissors',
      ],
      stepsId: [
        '1. Jepit resleting di antara kain luar dan kain furing, jahit di sepanjang resleting.',
        '2. Lakukan hal yang sama untuk sisi seberang resleting.',
        '3. Buka resleting separuh jalan (penting agar dompet bisa dibalik nantinya).',
        '4. Satukan kain luar dengan kain luar, dan kain furing dengan furing, jahit sekelilingnya dan sisakan lubang 5 cm pada furing.',
        '5. Balik dompet melalui lubang furing, jahit tutup lubangnya, lalu rapikan!',
      ],
      stepsEn: [
        '1. Sandwich zipper between outer fabric and lining, stitch along zipper teeth.',
        '2. Repeat identical step for the opposite side of the zipper.',
        '3. Unzip halfway (vital to invert pouch later).',
        '4. Match outer-to-outer and lining-to-lining, stitch perimeter leaving a 5 cm opening in lining.',
        '5. Pull pouch right-side out through opening, edge-stitch hole closed, and press neat!',
      ],
    ),
    TutorialItem(
      id: 'diy_masker',
      titleId: 'Membuat Masker Kain 3-Lapis Reusable',
      titleEn: 'Reusable 3-Layer Protective Fabric Mask',
      category: 'kain_sedang',
      durationId: '25 Menit',
      durationEn: '25 Mins',
      difficultyId: 'Sedang',
      difficultyEn: 'Moderate',
      icon: Icons.masks_outlined,
      materialsId: [
        'Kain perca katun (lembut & breathable) ukuran 18 x 20 cm (2 lembar)',
        'Kain spunbond / furing filter (1 lembar)',
        'Tali elastis masker 20 cm (2 buah)',
      ],
      materialsEn: [
        'Breathable cotton scraps 18 x 20 cm (2 pieces)',
        'Spunbond non-woven filter insert (1 piece)',
        'Elastic ear loops 20 cm (2 pieces)',
      ],
      stepsId: [
        '1. Tumpuk kain katun bagian luar, kain filter di tengah, dan kain katun bagian dalam.',
        '2. Jahit sisi atas dan bawah dengan kampuh 0.8 cm.',
        '3. Buat 3 lipatan ploi searah di kedua sisi kanan-kiri dan semat jarum pentul.',
        '4. Jahit lipatan ploi sekaligus memasang tali elastis di kedua ujungnya.',
        '5. Setrika masker agar rapi dan steril sebelum digunakan.',
      ],
      stepsEn: [
        '1. Stack outer cotton shell, center filter layer, and inner cotton lining.',
        '2. Stitch top and bottom seams with a 0.8 cm allowance.',
        '3. Create 3 downward pleats on both side edges and pin in place.',
        '4. Topstitch pleats while securing elastic loops at all corners.',
        '5. Press with warm iron for a sterile, crisp finish before wearing.',
      ],
    ),
    TutorialItem(
      id: 'diy_bros',
      titleId: 'Membuat Bros Bunga & Ikat Rambut (Scrunchie)',
      titleEn: 'Floral Brooch & Hair Scrunchie',
      category: 'kain_kecil',
      durationId: '15 Menit',
      durationEn: '15 Mins',
      difficultyId: 'Sangat Mudah',
      difficultyEn: 'Very Easy',
      icon: Icons.local_florist_outlined,
      materialsId: [
        'Potongan kain perca kecil (5 lingkaran diameter 7 cm)',
        'Peniti bros atau kancing bekas sebagai putik bunga',
        'Lem tembak atau benang jahit',
        'Karet elastis (jika membuat scrunchie)',
      ],
      materialsEn: [
        'Small fabric discs (5 circles, ~7 cm diameter)',
        'Safety brooch pin or vintage button for center rosette',
        'Hot glue gun or hand-stitching needle',
        'Elastic band (if making hair scrunchie)',
      ],
      stepsId: [
        '1. Lipat setiap lingkaran kain menjadi setengah lingkaran, lalu lipat lagi menjadi seperempat lingkaran (bentuk kelopak).',
        '2. Jelujur bagian dasar kelopak dengan benang, tarik hingga mengkerut.',
        '3. Sambungkan kelima kelopak hingga membentuk lingkaran bunga mekar.',
        '4. Pasang kancing hias di bagian tengah sebagai putik bunga dengan lem tembak.',
        '5. Tempelkan peniti bros di bagian belakang kain.',
      ],
      stepsEn: [
        '1. Fold each fabric disc into a semicircle, then into a quadrant petal.',
        '2. Run a basting stitch along petal bases and gather tightly.',
        '3. Join all 5 gathered petals into a blooming rosette.',
        '4. Affix accent button to flower center using hot glue.',
        '5. Securely mount brooch pin to back backing felt.',
      ],
    ),
    TutorialItem(
      id: 'diy_benang',
      titleId: 'Kreasi Rumbai Etnik & Ornamen Gantungan Kunci',
      titleEn: 'Ethnic Tassel Keychain Charm',
      category: 'benang',
      durationId: '15 Menit',
      durationEn: '15 Mins',
      difficultyId: 'Mudah',
      difficultyEn: 'Easy',
      icon: Icons.stream,
      materialsId: [
        'Kumpulan sisa benang jahit / obras beraneka warna',
        'Karton bekas ukuran 5 x 8 cm sebagai cetakan lilitan',
        'Ring gantungan kunci',
      ],
      materialsEn: [
        'Assorted colorful sewing/overlock thread scraps',
        'Recycled cardboard 5 x 8 cm winding gauge',
        'Split keychain metal ring',
      ],
      stepsId: [
        '1. Lilitkan sisa benang pada karton sebanyak 40-50 lilitan.',
        '2. Masukkan seutas benang di bagian atas lilitan lalu ikat simpul mati.',
        '3. Potong benang di ujung bawah karton.',
        '4. Lilitkan benang pengikat di leher rumbai (sekitar 1 cm dari puncak).',
        '5. Gunting dan ratakan ujung rumbai, lalu pasang ring gantungan kunci.',
      ],
      stepsEn: [
        '1. Wind scrap yarn tightly around card 40–50 rotations.',
        '2. Slip a tie cord under top loops and knot firmly.',
        '3. Cut loops straight across the opposite bottom edge.',
        '4. Wrap binding thread around tassel neck ~1 cm from top crown.',
        '5. Trim fringe level and thread onto split metal keyring.',
      ],
    ),
    TutorialItem(
      id: 'diy_kemasan',
      titleId: 'Wadah Pensil Meja dari Silinder Karton & Perca',
      titleEn: 'Desktop Stationery Holder from Spools & Fabric',
      category: 'kemasan',
      durationId: '15 Menit',
      durationEn: '15 Mins',
      difficultyId: 'Sangat Mudah',
      difficultyEn: 'Very Easy',
      icon: Icons.inventory_2_outlined,
      materialsId: [
        'Silinder karton bekas gulungan kain / kelos benang besar',
        'Kain perca bermotif untuk pelapis luar',
        'Karton tebal untuk alas lingkaran bawah',
        'Lem tembak / lem serbaguna',
      ],
      materialsEn: [
        'Cardboard fabric tube core / large empty thread cone',
        'Patterned scrap fabric for outer wrap',
        'Heavy cardboard base disc',
        'All-purpose craft adhesive or hot glue',
      ],
      stepsId: [
        '1. Potong silinder karton setinggi 10-12 cm sesuai kebutuhan wadah.',
        '2. Buat alas melingkar dari karton tebal dan rekatkan pada salah satu ujung silinder.',
        '3. Oleskan lem pada permukaan luar silinder karton secara merata.',
        '4. Balutkan kain perca dengan rapi dan selipkan sisa tepi kain ke bagian dalam atas dan bawah.',
        '5. Tambahkan hiasan pita atau renda sisa konveksi untuk mempercantik tampilan.',
      ],
      stepsEn: [
        '1. Trim cardboard tube to 10–12 cm desired desk height.',
        '2. Trace and glue cardboard bottom disc to seal cylinder base.',
        '3. Apply craft adhesive evenly around outer cardboard wall.',
        '4. Smooth fabric wrap neatly, tucking excess edges cleanly into top rim.',
        '5. Embellish with trim lace or contrast ribbon scraps for an artisanal finish.',
      ],
    ),
  ];

  static List<TutorialItem> getTutorialsForCategory(String categoryId) {
    return tutorials.where((t) => t.category == categoryId).toList();
  }
}
