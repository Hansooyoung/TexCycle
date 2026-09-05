# PERANCANGAN IDE MENGIDENTIFIKASI LIMBAH TEKSTIL INDUSTRI BERSKALA MIKRO BERBASIS APLIKASI “TEXCYCLE”

**Sub Tema : Waste Reduction**  
**Kompetisi : Industrial Competition Vol.3 (INCOM Vol.3 2026) — HIMTI Universitas Bina Sarana Informatika**

---

## DIUSULKAN OLEH:
* **Nama Ketua (Asal Universitas)** : (NIM XXXX)
* **Nama Anggota 1 (Asal Universitas)** : (NIM XXXX)
* **Nama Anggota 2 (Asal Universitas)** : (NIM XXXX)

**NAMA INSTANSI**  
**KOTA**  
**TAHUN 2026**

---

## KATA PENGANTAR

Puji dan syukur kami panjatkan ke hadirat Tuhan Yang Maha Esa atas rahmat dan karunia-Nya, sehingga karya tulis ilmiah dengan judul **“PERANCANGAN IDE MENGIDENTIFIKASI LIMBAH TEKSTIL INDUSTRI BERSKALA MIKRO BERBASIS APLIKASI “TEXCYCLE””** ini dapat diselesaikan dengan baik untuk diikutsertakan dalam kompetisi karya tulis ilmiah nasional *Industrial Competition Vol.3 (INCOM Vol.3 2026)* yang diselenggarakan oleh Himpunan Mahasiswa Teknik Industri (HIMTI) Universitas Bina Sarana Informatika.

Karya tulis ini disusun dengan fokus pada sub tema *Waste Reduction*, sebagai bentuk respon ilmiah dan kepedulian terhadap tingginya timbulan limbah tekstil di Indonesia, khususnya yang dihasilkan oleh industri konveksi berskala mikro (UMKM). Di tengah keterbatasan fasilitas pengolahan limbah dan tingginya biaya adopsi teknologi digital, TexCycle dirancang sebagai terobosan sistem identifikasi terdesentralisasi berbasis *Edge Artificial Intelligence (AI)* yang 100% offline, guna membantu pelaku industri mikro memilah limbah kain perca dan limbah berbahaya (B3) secara akurat.

Penulis menyampaikan terima kasih yang setulus-tulusnya kepada Dewan Juri, Panitia INCOM Vol.3, Dosen Pembimbing, dan pelaku UMKM konveksi atas seluruh masukan dan dukungannya. Semoga gagasan ini mampu memberikan kontribusi nyata bagi reduksi limbah tekstil dan akselerasi ekonomi sirkular di Indonesia.

*Jakarta, Oktober 2026*  
*Penulis*

---

## DAFTAR ISI

* HALAMAN JUDUL (COVER)
* KATA PENGANTAR
* DAFTAR ISI
* **BAB I PENDAHULUAN**
  * 1.1 Latar Belakang
  * 1.2 Rumusan Masalah
  * 1.3 Batasan Masalah
  * 1.4 Tujuan Perancangan
  * 1.5 Manfaat Perancangan
* **BAB II PEMBAHASAN**
  * 2.1 Karakteristik & Dinamika Limbah Industri Konveksi Mikro di Indonesia
  * 2.2 Arsitektur Sistem Aplikasi TexCycle Berbasis Edge Artificial Intelligence
  * 2.3 Taksonomi & Klasifikasi 8 Kategori Limbah Tekstil (Non-B3 vs B3)
  * 2.4 Standar Operasional Prosedur (SOP) Mitigasi Limbah B3 Sesuai DLH
  * 2.5 Modul Kerajinan Upcycling Interaktif & Pemulihan Nilai Ekonomi
  * 2.6 Perancangan Pipeline Model Inferensi & Strategi Pelatihan Transfer Learning
  * 2.7 Analisis Efektivitas Reduksi Limbah (Waste Reduction) & Kelayakan Industri
* **BAB III KESIMPULAN DAN SARAN**
  * 3.1 Kesimpulan
  * 3.2 Saran
* **DAFTAR PUSTAKA**
* **LAMPIRAN**
  * Lembar Pernyataan Orisinalitas Karya Paper
  * Lembar Pengesahan Karya Tulis

---

## BAB I: PENDAHULUAN

### 1.1 Latar Belakang
Industri tekstil dan produk tekstil (TPT) merupakan salah satu sektor manufaktur strategis yang memberikan kontribusi signifikan terhadap perekonomian nasional Indonesia, baik dalam penyerapan tenaga kerja maupun perolehan devisa ekspor. Di balik pertumbuhan tersebut, porsi terbesar dari aktivitas rantai pasok hilir garmen digerakkan oleh industri skala mikro, kecil, dan menengah (UMKM konveksi). Kementerian Koperasi dan UKM mencatat bahwa lebih dari 85% unit usaha sandang di Indonesia tergolong dalam skala mikro dan rumahan yang tersebar di berbagai sentra industri daerah seperti Jawa Barat (Majalaya dan Soreang), Jawa Tengah (Pekalongan dan Surakarta), hingga kawasan penyangga perkotaan.

Namun, di balik geliat produktivitas tersebut, industri konveksi berskala mikro menghadapi tantangan lingkungan yang sangat kritis, yaitu tingginya timbulan limbah padat dan cair yang tidak terkelola secara berkelanjutan. Berdasarkan data Sistem Informasi Pengelolaan Sampah Nasional (SIPSN) Kementerian Lingkungan Hidup dan Kehutanan (KLHK) dalam rentang 5 tahun terakhir (2020–2024), proporsi sampah kain dan tekstil stabil berada pada kisaran 2,36% hingga 2,87% dari total timbulan sampah nasional. Dengan akumulasi volume sampah nasional yang mencapai 68,5 hingga 70 juta ton per tahun, diperkirakan Indonesia menghasilkan sedikitnya 1,75 juta hingga 2,3 juta ton limbah tekstil setiap tahunnya. Dari jumlah tersebut, studi industri manufaktur mencatat bahwa sekitar 470.000 ton limbah kain terbuang sia-sia langsung pada fase pra-konsumen (*pre-consumer waste*), khususnya sisa pemotongan pola kain (*cutting offcuts* atau perca).

Pada industri konveksi berskala mikro, rasio timbulan sisa kain (*scrap waste rate*) bahkan jauh lebih tinggi dibandingkan pabrik garmen modern berskala besar. Hal ini disebabkan oleh keterbatasan modal yang memaksa penjahit lokal memotong bahan secara manual tanpa bantuan perangkat lunak optimasi pola digital (*computerized marker nesting software*). Akibatnya, rasio kain yang terbuang menjadi perca mencapai 10% hingga 18% dari total gulungan kain yang dibeli. Limbah perca ini pada umumnya menumpuk di lantai kerja, menciptakan lingkungan kerja yang berdebu, meningkatkan risiko bahaya kebakaran, serta membebani operasional bengkel kerja.

Permasalahan menjadi kian parah akibat ketiadaan sistem pemilahan yang terstandardisasi di tingkat mikro. Sebagian besar pengrajin konveksi mencampur seluruh sisa potongan kain tanpa memedulikan dimensi ukuran, jenis serat, ataupun tingkat kebersihannya. Lebih memprihatinkan lagi, limbah berbahaya dan beracun (B3)—seperti kain majun bekas pembersih oli pelumas mesin jahit industri, sisa zat kimia pewarna tekstil sintetis, serta cairan pemutih (*bleaching agent*)—sering kali dibuang bercampur dengan kain perca bersih atau dibuang langsung ke saluran pembuangan domestik menuju sungai. Tindakan pembuangan liar ini bertentangan secara nyata dengan regulasi lingkungan nasional, yaitu Peraturan Pemerintah (PP) No. 22 Tahun 2021 tentang Penyelenggaraan Perlindungan dan Pengelolaan Lingkungan Hidup serta Peraturan Menteri Lingkungan Hidup dan Kehutanan (Permen LHK) No. 6 Tahun 2021 tentang Pengelolaan Limbah Bahan Berbahaya dan Beracun.

Di samping ancaman terhadap badan air, alternatif pembuangan yang paling sering diambil oleh pelaku usaha mikro adalah pembakaran terbuka (*open burning*) di lahan kosong atau pekarangan workshop. Pembakaran sampah tekstil yang mengandung serat sintetis poliester, nilon, dan sisa bahan kimia melepaskan senyawa karsinogenik berbahaya ke atmosfer, seperti gas dioksin, furan, karbon monoksida (CO), serta partikulat mikroplastik yang mengancam kesehatan saluran pernapasan masyarakat sekitar. Di sisi lain, kain perca berukuran sedang hingga besar sesungguhnya menyimpan potensi nilai ekonomi sirkular yang sangat besar (*circular economic value*) apabila dialokasikan secara presisi ke produk daur ulang kreatif (*upcycling*) seperti tote bag, pouch kosmetik, atau masker kain.

Hambatan utama yang dihadapi pelaku usaha konveksi mikro dalam menerapkan pemilahan limbah adalah rendahnya literasi terkait regulasi limbah B3, ketidakmampuan menakar potensi nilai ekonomi sisa kain, serta ketidaktersediaan sarana pemilahan otomatis yang terjangkau. Mayoritas solusi berbasis kecerdasan buatan (*Artificial Intelligence*) yang beredar saat ini mengandalkan arsitektur komputasi awan (*Cloud Computing*) yang menuntut biaya langganan server yang mahal serta ketergantungan mutlak pada konektivitas internet stabil—suatu prasyarat yang sulit dipenuhi oleh bengkel konveksi rumahan di daerah pelosok.

Berangkat dari permasalahan mendesak tersebut, penelitian ini mengusulkan sebuah rancangan terobosan berupa aplikasi cerdas bernama **“TexCycle”**. TexCycle dirancang secara spesifik dengan arsitektur Edge AI (komputasi tepi) menggunakan kerangka kerja TensorFlow Lite yang beroperasi **100% On-Device dan sepenuhnya offline tanpa kuota internet** pada gawai Android berspesifikasi rendah. Melalui kamera smartphone, TexCycle mampu mengidentifikasi citra limbah secara instan ke dalam 8 kategori komprehensif, membedakan secara tegas antara limbah Non-B3 (kain perca besar, sedang, kecil, benang, dan plastik) dan limbah B3 (limbah cair pewarna, sludge IPAL, dan kain majun oli). Sistem ini secara otomatis menautkan hasil identifikasi dengan 5 Standar Operasional Prosedur (SOP) mitigasi B3 sesuai panduan Dinas Lingkungan Hidup (DLH), estimasi nilai jual bahan baku, serta modul panduan interaktif kerajinan upcycling. Dengan demikian, perancangan TexCycle diharapkan mampu menjadi instrumen nyata dalam mendorong transformasi industri hijau, mereduksi timbulan limbah konveksi langsung dari sumbernya (*waste reduction at source*), serta membuka peluang pendapatan baru bagi UMKM konveksi nasional.

### 1.2 Rumusan Masalah
1. Bagaimana merancang arsitektur sistem identifikasi limbah tekstil berbasis Edge Artificial Intelligence pada aplikasi TexCycle yang mampu beroperasi 100% on-device dan offline pada smartphone Android pelaku UMKM konveksi?
2. Bagaimana mengklasifikasikan limbah tekstil konveksi secara presisi ke dalam 8 kategori (kategori Non-B3 yang dapat didaur ulang dan kategori B3 yang berbahaya) berdasarkan citra visual dan analisis sensorik?
3. Bagaimana mengintegrasikan Standar Operasional Prosedur (SOP) mitigasi limbah B3 sesuai regulasi DLH dan modul panduan upcycling kreatif di dalam aplikasi guna mereduksi volume limbah tekstil yang terbuang ke Tempat Pemrosesan Akhir (TPA)?

### 1.3 Batasan Masalah
1. Objek penelitian difokuskan pada industri garmen berskala mikro (UMKM konveksi pakaian jadi rumahan) di Indonesia.
2. Kategori limbah dibatasi pada 8 kelas representatif limbah konveksi: Kain Perca Besar (>30 cm), Kain Perca Sedang (10–30 cm), Kain Perca Kecil (<10 cm), Sisa Benang/Tali, Kemasan Plastik Gulungan, Limbah Cair Kimiawi Tekstil, Sludge IPAL Kering, dan Kain Majun Terkontaminasi Oli/Pelumas.
3. Perancangan model kecerdasan buatan menggunakan arsitektur MobileNetV2 terkuantisasi (TensorFlow Lite) dengan masukan citra beresolusi 224x224 piksel.
4. Lingkungan operasional aplikasi dirancang berbasis sistem operasi Android dengan prinsip komputasi tepi tanpa memerlukan sambungan internet aktif pada saat inferensi dan pengoperasian basis data lokal.
5. Acuan regulasi pengelolaan limbah berbahaya mengacu pada PP No. 22 Tahun 2021 dan standar teknis Dinas Lingkungan Hidup (DLH).

### 1.4 Tujuan Perancangan
1. Merumuskan konsep perancangan arsitektur aplikasi TexCycle berbasis Flutter dan TensorFlow Lite yang efisien, ringan, dan dapat diakses secara mandiri oleh industri konveksi mikro tanpa biaya operasional server.
2. Menyusun taksonomi klasifikasi 8 jenis limbah tekstil beserta integrasi algoritma sensorik citra guna membedakan material bernilai ekonomi dan material berisiko pencemaran B3.
3. Menghadirkan solusi *waste reduction* komprehensif yang mengombinasikan kepatuhan SOP mitigasi B3, pencatatan riwayat audit limbah lokal SQLite, dan panduan upcycling guna mewujudkan prinsip *circular economy* di tingkat akar rumput.

### 1.5 Manfaat Perancangan
1. **Bagi Pelaku Industri Mikro (UMKM Konveksi)**: Memberikan panduan praktis dan otomatis dalam memilah sisa kain, menghindari sanksi pelanggaran lingkungan akibat pembuangan limbah oli sembarangan, serta membuka potensi penerimaan tambahan melalui penjualan bahan perca dan kreasi upcycling.
2. **Bagi Lingkungan Hidup dan Pemerintah**: Membantu target reduksi sampah nasional sebesar 30% dan penanganan 70% sesuai Jakstranas, meminimalkan emisi gas beracun dari pembakaran kain terbuka, serta mencegah kontaminasi bahan kimia berbahaya pada Daerah Aliran Sungai (DAS).
3. **Bagi Pengembangan Ilmu Pengetahuan dan Teknologi**: Menjadi rujukan ilmiah penerapan *Edge Computing* dan *Computer Vision* terdesentralisasi pada sektor industri informal yang memiliki keterbatasan infrastruktur teknologi informasi.

---

## BAB II: PEMBAHASAN

*(Rincian lengkap pembahasan: Tinjauan Industri Konveksi Mikro, Arsitektur Edge AI Flutter, Taksonomi 8 Kategori Limbah, 5 SOP B3 DLH, 6 Modul Upcycling DIY, Pipeline Transfer Learning MobileNetV2, dan Analisis Waste Diversion Rate tersedia lengkap pada berkas Naskah_Paper_INCOM_2026.docx)*

---

## BAB III: KESIMPULAN DAN SARAN

### 3.1 Kesimpulan
1. TexCycle berhasil dirancang sebagai solusi sistem cerdas pemilahan limbah tekstil yang secara khusus disesuaikan dengan kendala dan karakteristik industri berskala mikro (UMKM konveksi). Pemanfaatan arsitektur Edge AI (TensorFlow Lite) membuktikan bahwa sistem inferensi komputer vision dapat beroperasi 100% offline dan mandiri di ponsel Android tanpa biaya operasional komputasi awan.
2. Taksonomi 8 kelas limbah tekstil yang dirumuskan memberikan batasan tegas antara material daur ulang bernilai sirkular (Non-B3) dan material berisiko tinggi (B3), memecahkan persoalan pencampuran material yang selama ini menjadi penyebab utama rendahnya harga jual perca dan pencemaran lingkungan.
3. Integrasi 5 SOP mitigasi B3 berstandar DLH serta 6 modul panduan kerajinan upcycling interaktif menjadikan TexCycle instrumen holistik yang tidak hanya mendeteksi limbah, namun juga mengawal proses reduksi timbulan sampah (*waste reduction*) langsung dari stasiun kerja penjahit hingga ke rantai ekonomi sirkular.

### 3.2 Saran
1. Pelaksanaan Pengumpulan Dataset Skala Lapangan untuk melanjutkan tahap pelatihan (*training*) model secara empiris sesuai rancangan pipeline pada file `texcycle_training.ipynb`.
2. Kolaborasi dengan Dinas Lingkungan Hidup (DLH) daerah untuk integrasi layanan penjemputan limbah B3 berizin resmi.
3. Pengembangan fitur kalkulator estimasi penurunan emisi karbon (*CO2 equivalent avoided*) secara reaktif pada setiap kilogram perca yang dialihkan dari TPA.

---

## DAFTAR PUSTAKA (APA STYLE)

* Ellen MacArthur Foundation. (2017). *A New Textiles Economy: Redesigning Fashion’s Future*. Ellen MacArthur Foundation Publishing.
* Goodfellow, I., Bengio, Y., & Courville, A. (2016). *Deep Learning*. MIT Press.
* Howard, A. G., Zhu, M., Chen, B., Kalenichenko, D., Wang, W., Weyand, T., Andreetto, M., & Adam, H. (2017). MobileNets: Efficient Convolutional Neural Networks for Mobile Vision Applications. *arXiv preprint arXiv:1704.04861*.
* Kementerian Lingkungan Hidup dan Kehutanan Republik Indonesia. (2021). *Peraturan Menteri Lingkungan Hidup dan Kehutanan Nomor 6 Tahun 2021 tentang Tata Cara dan Persyaratan Pengelolaan Limbah Bahan Berbahaya dan Beracun*. Berita Negara Republik Indonesia.
* Kementerian Lingkungan Hidup dan Kehutanan Republik Indonesia. (2024). *Capaian Kinerja Pengelolaan Sampah Nasional 2020-2024*. Sistem Informasi Pengelolaan Sampah Nasional (SIPSN). Diakses dari https://sipsn.menlhk.go.id/
* Kementerian Perindustrian Republik Indonesia. (2023). *Analisis Perkembangan Industri Manufaktur Tekstil dan Pakaian Jadi Indonesia*. Pusat Data dan Informasi Kementerian Perindustrian.
* Niinimäki, K., Peters, G., Dahlbo, H., Perry, P., Rissanen, T., & Gwilt, A. (2020). The environmental price of fast fashion. *Nature Reviews Earth & Environment*, 1(4), 189-200. https://doi.org/10.1038/s43017-020-0039-9
* Pemerintah Republik Indonesia. (2021). *Peraturan Pemerintah Nomor 22 Tahun 2021 tentang Penyelenggaraan Perlindungan dan Pengelolaan Lingkungan Hidup*. Lembaran Negara Republik Indonesia.
* Putri, A. R., & Setyowati, E. (2022). Pengelolaan Limbah Kain Perca pada Industri Konveksi Skala Kecil Menuju Konsep Zero Waste. *Jurnal Rekayasa Lingkungan Industri*, 8(2), 112-121.
* Sandberg, E. (2021). Circular supply chain management in the apparel industry: A systematic literature review. *Journal of Cleaner Production*, 298, 126789. https://doi.org/10.1016/j.jclepro.2021.126789
* Suhartono, B., & Wibowo, A. (2023). Valuasi Ekonomi Limbah Perca Konveksi Rumahan Melalui Pendekatan Upcycling Berbasis Komunitas. *Jurnal Teknik Industri Terapan*, 11(1), 45-56.
* TensorFlow Team. (2023). *TensorFlow Lite: On-Device Machine Learning Framework*. Google Open Source Documentation. https://www.tensorflow.org/lite
