import '../../../models/models.dart';

abstract class DummyData {
  static const List<BangunModel> bangunRuangList = [
    BangunModel(
      id: 'br_kubus',
      nama: 'Kubus',
      kategori: KategoriBangun.ruang,
      deskripsi:
          'Bangun ruang tiga dimensi yang dibatasi oleh enam bidang sisi yang kongruen berbentuk bujur sangkar.',
      rumusLuas: 'L = 6 × s²',
      rumusVolume: 'V = s³',
      imagePath: 'assets/images/placeholder_kubus.png',
      iconPath: 'assets/icons/ic_kubus.png',
      tingkat: TingkatKesulitan.mudah,
      sifatSifat: [
        'Memiliki 6 sisi berbentuk persegi yang kongruen',
        'Memiliki 12 rusuk yang sama panjang',
        'Memiliki 8 titik sudut',
        'Memiliki 12 diagonal bidang',
        'Memiliki 4 diagonal ruang'
      ],
      contohNyata: ['Dadu', 'Rubik', 'Es Batu'],
      arModelId: 'kubus_ar',
    ),
    BangunModel(
      id: 'br_balok',
      nama: 'Balok',
      kategori: KategoriBangun.ruang,
      deskripsi:
          'Bangun ruang tiga dimensi yang dibentuk oleh tiga pasang persegi atau persegi panjang, dengan paling tidak satu pasang di antaranya berukuran berbeda.',
      rumusLuas: 'L = 2 × (pl + pt + lt)',
      rumusVolume: 'V = p × l × t',
      imagePath: 'assets/images/placeholder_balok.png',
      iconPath: 'assets/icons/ic_balok.png',
      tingkat: TingkatKesulitan.mudah,
      sifatSifat: [
        'Memiliki 6 sisi, dengan sisi yang berhadapan sejajar dan kongruen',
        'Memiliki 12 rusuk, dengan rusuk yang sejajar sama panjang',
        'Memiliki 8 titik sudut'
      ],
      contohNyata: ['Kotak Sepatu', 'Lemari', 'Batu Bata'],
      arModelId: 'balok_ar',
    ),
    BangunModel(
      id: 'br_prisma_segitiga',
      nama: 'Prisma Segitiga',
      kategori: KategoriBangun.ruang,
      deskripsi:
          'Bangun ruang tiga dimensi yang dibatasi oleh alas dan tutup identik berbentuk segitiga dan sisi-sisi tegak berbentuk segi empat.',
      rumusLuas: 'L = (2 × Luas Alas) + (Keliling Alas × t)',
      rumusVolume: 'V = Luas Alas × t',
      imagePath: 'assets/images/placeholder_prisma.png',
      iconPath: 'assets/icons/ic_prisma.png',
      tingkat: TingkatKesulitan.sedang,
      sifatSifat: [
        'Memiliki 5 sisi (2 segitiga, 3 segiempat)',
        'Memiliki 9 rusuk',
        'Memiliki 6 titik sudut'
      ],
      contohNyata: ['Tenda Pramuka', 'Atap Rumah', 'Cokelat Toblerone'],
    ),
    BangunModel(
      id: 'br_limas_segiempat',
      nama: 'Limas Segiempat',
      kategori: KategoriBangun.ruang,
      deskripsi:
          'Bangun ruang tiga dimensi yang dibatasi oleh alas berbentuk segiempat dan sisi-sisi tegak berbentuk segitiga yang bertemu pada satu titik puncak.',
      rumusLuas: 'L = Luas Alas + Jumlah Luas Sisi Tegak',
      rumusVolume: 'V = ⅓ × Luas Alas × t',
      imagePath: 'assets/images/placeholder_limas.png',
      iconPath: 'assets/icons/ic_limas.png',
      tingkat: TingkatKesulitan.sedang,
      sifatSifat: [
        'Memiliki 5 sisi (1 segiempat, 4 segitiga)',
        'Memiliki 8 rusuk',
        'Memiliki 5 titik sudut (1 titik puncak)'
      ],
      contohNyata: ['Piramida Mesir', 'Atap Pendopo'],
    ),
    BangunModel(
      id: 'br_tabung',
      nama: 'Tabung',
      kategori: KategoriBangun.ruang,
      deskripsi:
          'Bangun ruang tiga dimensi yang dibentuk oleh dua buah lingkaran identik yang sejajar dan sebuah persegi panjang yang mengelilingi kedua lingkaran tersebut.',
      rumusLuas: 'L = 2 × π × r × (r + t)',
      rumusVolume: 'V = π × r² × t',
      imagePath: 'assets/images/placeholder_tabung.png',
      iconPath: 'assets/icons/ic_tabung.png',
      tingkat: TingkatKesulitan.sedang,
      sifatSifat: [
        'Memiliki 3 sisi (2 lingkaran, 1 selimut)',
        'Memiliki 2 rusuk lengkung',
        'Tidak memiliki titik sudut'
      ],
      contohNyata: ['Kaleng Susu', 'Drum', 'Pipa'],
      arModelId: 'tabung_ar',
    ),
    BangunModel(
      id: 'br_kerucut',
      nama: 'Kerucut',
      kategori: KategoriBangun.ruang,
      deskripsi:
          'Bangun ruang yang dibatasi oleh sebuah sisi alas berbentuk lingkaran dan sebuah sisi lengkung (selimut) yang mengerucut ke satu titik puncak.',
      rumusLuas: 'L = π × r × (r + s)',
      rumusVolume: 'V = ⅓ × π × r² × t',
      imagePath: 'assets/images/placeholder_kerucut.png',
      iconPath: 'assets/icons/ic_kerucut.png',
      tingkat: TingkatKesulitan.sulit,
      sifatSifat: [
        'Memiliki 2 sisi (1 lingkaran, 1 selimut)',
        'Memiliki 1 rusuk lengkung',
        'Memiliki 1 titik puncak'
      ],
      contohNyata: ['Topi Ulang Tahun', 'Cone Es Krim', 'Nasi Tumpeng'],
      arModelId: 'kerucut_ar',
    ),
    BangunModel(
      id: 'br_bola',
      nama: 'Bola',
      kategori: KategoriBangun.ruang,
      deskripsi:
          'Bangun ruang sisi lengkung yang dibatasi oleh satu bidang lengkung. Bola didapatkan dari bangun setengah lingkaran yang diputar satu putaran penuh.',
      rumusLuas: 'L = 4 × π × r²',
      rumusVolume: 'V = ⁴/₃ × π × r³',
      imagePath: 'assets/images/placeholder_bola.png',
      iconPath: 'assets/icons/ic_bola.png',
      tingkat: TingkatKesulitan.mudah,
      sifatSifat: [
        'Hanya memiliki 1 sisi lengkung yang tertutup',
        'Tidak memiliki rusuk',
        'Tidak memiliki titik sudut',
        'Jarak pusat ke permukaan selalu sama (jari-jari)'
      ],
      contohNyata: ['Bola Sepak', 'Kelereng', 'Bumi (Hampir bulat)'],
      arModelId: 'bola_ar',
    ),
  ];

  static const List<BangunModel> bangunDatarList = [
    BangunModel(
      id: 'bd_persegi',
      nama: 'Persegi',
      kategori: KategoriBangun.datar,
      deskripsi:
          'Bangun datar dua dimensi yang dibentuk oleh empat buah rusuk (a) yang sama panjang dan memiliki empat buah sudut yang kesemuanya adalah sudut siku-siku.',
      rumusLuas: 'L = s × s',
      rumusVolume: 'K = 4 × s', // Gunakan rumusVolume untuk menyimpan keliling khusus bangun datar
      imagePath: '',
      iconPath: '',
      tingkat: TingkatKesulitan.mudah,
      sifatSifat: [
        'Memiliki 4 sisi yang sama panjang',
        'Memiliki 4 sudut siku-siku (90 derajat)',
        'Memiliki 2 diagonal yang saling berpotongan tegak lurus dan sama panjang'
      ],
      contohNyata: ['Ubin lantai', 'Papan catur', 'Roti tawar'],
    ),
    BangunModel(
      id: 'bd_persegi_panjang',
      nama: 'Persegi Panjang',
      kategori: KategoriBangun.datar,
      deskripsi:
          'Bangun datar dua dimensi yang dibentuk oleh dua pasang rusuk yang masing-masing sama panjang dan sejajar dengan pasangannya, dan memiliki empat buah sudut siku-siku.',
      rumusLuas: 'L = p × l',
      rumusVolume: 'K = 2 × (p + l)',
      imagePath: '',
      iconPath: '',
      tingkat: TingkatKesulitan.mudah,
      sifatSifat: [
        'Memiliki 4 sisi (2 pasang sisi sejajar dan sama panjang)',
        'Memiliki 4 sudut siku-siku',
        'Memiliki 2 diagonal yang sama panjang'
      ],
      contohNyata: ['Papan tulis', 'Buku', 'Lapangan sepak bola'],
    ),
    BangunModel(
      id: 'bd_segitiga',
      nama: 'Segitiga',
      kategori: KategoriBangun.datar,
      deskripsi:
          'Bangun datar yang dibatasi oleh tiga buah sisi dan mempunyai tiga buah titik sudut. Total sudut dalam segitiga selalu 180 derajat.',
      rumusLuas: 'L = ½ × a × t',
      rumusVolume: 'K = a + b + c',
      imagePath: '',
      iconPath: '',
      tingkat: TingkatKesulitan.sedang,
      sifatSifat: [
        'Memiliki 3 sisi (a, b, c)',
        'Memiliki 3 titik sudut (A, B, C)',
        'Jumlah ketiga sudutnya selalu 180°'
      ],
      contohNyata: ['Penggaris segitiga', 'Rambu lalu lintas', 'Potongan pizza'],
    ),
    BangunModel(
      id: 'bd_jajargenjang',
      nama: 'Jajar Genjang',
      kategori: KategoriBangun.datar,
      deskripsi:
          'Bangun datar dua dimensi yang dibentuk oleh dua pasang rusuk yang masing-masing sama panjang dan sejajar dengan pasangannya, dan memiliki dua pasang sudut yang masing-masing sama besar dengan sudut di hadapannya.',
      rumusLuas: 'L = a × t',
      rumusVolume: 'K = 2 × (a + b)',
      imagePath: '',
      iconPath: '',
      tingkat: TingkatKesulitan.sedang,
      sifatSifat: [
        'Sisi-sisi yang berhadapan sejajar dan sama panjang',
        'Sudut-sudut yang berhadapan sama besar',
        'Jumlah sudut-sudut yang berdekatan adalah 180°'
      ],
      contohNyata: ['Penghapus', 'Motif batik', 'Bayangan benda'],
    ),
    BangunModel(
      id: 'bd_trapesium',
      nama: 'Trapesium',
      kategori: KategoriBangun.datar,
      deskripsi:
          'Bangun datar dua dimensi yang dibentuk oleh empat buah rusuk yang dua di antaranya saling sejajar namun tidak sama panjang.',
      rumusLuas: 'L = ½ × (a + b) × t',
      rumusVolume: 'K = a + b + c + d',
      imagePath: '',
      iconPath: '',
      tingkat: TingkatKesulitan.sedang,
      sifatSifat: [
        'Memiliki tepat sepasang sisi yang sejajar',
        'Jumlah sudut yang berdekatan di antara dua sisi sejajar adalah 180°',
        'Trapesium sama kaki memiliki sepasang sisi yang sama panjang'
      ],
      contohNyata: ['Atap rumah', 'Tas jinjing', 'Perahu'],
    ),
    BangunModel(
      id: 'bd_layang',
      nama: 'Layang-layang',
      kategori: KategoriBangun.datar,
      deskripsi:
          'Bangun datar dua dimensi yang dibentuk oleh dua pasang sisi yang masing-masing pasangannya sama panjang dan saling membentuk sudut.',
      rumusLuas: 'L = ½ × d1 × d2',
      rumusVolume: 'K = 2 × (a + b)',
      imagePath: '',
      iconPath: '',
      tingkat: TingkatKesulitan.sulit,
      sifatSifat: [
        'Memiliki dua pasang sisi yang sama panjang',
        'Kedua diagonalnya berpotongan saling tegak lurus',
        'Salah satu diagonalnya membagi dua diagonal yang lain sama panjang'
      ],
      contohNyata: ['Layang-layang mainan', 'Motif dinding', 'Permata'],
    ),
    BangunModel(
      id: 'bd_belah_ketupat',
      nama: 'Belah Ketupat',
      kategori: KategoriBangun.datar,
      deskripsi:
          'Bangun datar dua dimensi yang memiliki empat sisi sama panjang dengan dua pasang sudut yang berhadapan sama besar. Diagonal-diagonalnya saling tegak lurus dan membagi satu sama lain menjadi dua bagian sama panjang.',
      rumusLuas: 'L = ½ × d1 × d2',
      rumusVolume: 'K = 4 × s',
      imagePath: '',
      iconPath: '',
      tingkat: TingkatKesulitan.sedang,
      sifatSifat: [
        'Memiliki 4 sisi yang sama panjang',
        'Sudut-sudut yang berhadapan sama besar',
        'Kedua diagonalnya saling tegak lurus',
        'Diagonal-diagonalnya saling membagi dua sama panjang',
      ],
      contohNyata: ['Berlian / Intan', 'Motif kartu layang', 'Ubin hias'],
    ),
    BangunModel(
      id: 'bd_lingkaran',
      nama: 'Lingkaran',
      kategori: KategoriBangun.datar,
      deskripsi:
          'Himpunan semua titik pada bidang yang memiliki jarak yang sama dari suatu titik pusat tertentu.',
      rumusLuas: 'L = π × r²',
      rumusVolume: 'K = 2 × π × r',
      imagePath: '',
      iconPath: '',
      tingkat: TingkatKesulitan.mudah,
      sifatSifat: [
        'Hanya memiliki satu sisi lengkung yang tertutup',
        'Tidak memiliki titik sudut',
        'Jarak dari titik pusat ke tepi selalu konstan (jari-jari)'
      ],
      contohNyata: ['Roda', 'Uang koin', 'Jam dinding'],
    ),
  ];

  static const List<SoalModel> soalKuisList = [
    SoalModel(
      id: 'q1',
      pertanyaan: 'Berapakah jumlah titik sudut pada kubus?',
      tipe: TipeSoal.pilihanGanda,
      pilihan: ['4', '6', '8', '12'],
      jawabanBenar: 2,
      kategori: 'ruang',
      penjelasan: 'Kubus memiliki 8 titik sudut, 12 rusuk, dan 6 sisi berbentuk persegi.',
      bangunId: 'br_kubus',
      poin: 10,
    ),
    SoalModel(
      id: 'q2',
      pertanyaan: 'Rumus luas persegi panjang adalah...',
      tipe: TipeSoal.pilihanGanda,
      pilihan: ['p + l', '2 × (p + l)', 'p × l', 'p × l × t'],
      jawabanBenar: 2,
      kategori: 'datar',
      penjelasan: 'Luas persegi panjang dihitung dengan mengalikan panjang dan lebarnya.',
      bangunId: 'bd_persegi_panjang',
      poin: 10,
    ),
    SoalModel(
      id: 'q3',
      pertanyaan: 'Bangun ruang yang tidak memiliki titik sudut adalah...',
      tipe: TipeSoal.pilihanGanda,
      pilihan: ['Tabung', 'Kerucut', 'Bola', 'Prisma'],
      jawabanBenar: 2,
      kategori: 'ruang',
      penjelasan: 'Bola hanya memiliki satu sisi lengkung dan tidak memiliki titik sudut maupun rusuk.',
      bangunId: 'br_bola',
      poin: 10,
    ),
    SoalModel(
      id: 'q4',
      pertanyaan: 'Total sudut dalam sebuah segitiga adalah...',
      tipe: TipeSoal.pilihanGanda,
      pilihan: ['90°', '180°', '270°', '360°'],
      jawabanBenar: 1,
      kategori: 'datar',
      penjelasan: 'Jumlah ketiga sudut dalam sembarang segitiga selalu 180°.',
      bangunId: 'bd_segitiga',
      poin: 10,
    ),
    SoalModel(
      id: 'q5',
      pertanyaan: 'Jika sebuah kubus memiliki panjang rusuk 5 cm, berapakah volumenya?',
      tipe: TipeSoal.pilihanGanda,
      pilihan: ['25 cm³', '125 cm³', '150 cm³', '600 cm³'],
      jawabanBenar: 1,
      kategori: 'ruang',
      penjelasan: 'Volume kubus = s × s × s = 5 × 5 × 5 = 125 cm³.',
      bangunId: 'br_kubus',
      poin: 10,
      rumusHint: 'V = s³',
    ),
    SoalModel(
      id: 'q6',
      pertanyaan: 'Bangun datar yang memiliki dua pasang sisi sejajar dan sama panjang, namun sudutnya tidak siku-siku adalah...',
      tipe: TipeSoal.pilihanGanda,
      pilihan: ['Persegi Panjang', 'Belah Ketupat', 'Trapesium', 'Jajar Genjang'],
      jawabanBenar: 3,
      kategori: 'datar',
      penjelasan: 'Jajar genjang memiliki dua pasang sisi sejajar dan sama panjang, dengan sudut yang berhadapan sama besar (bukan 90°).',
      bangunId: 'bd_jajargenjang',
      poin: 10,
    ),
    SoalModel(
      id: 'q7',
      pertanyaan: 'Berapakah jumlah rusuk yang dimiliki tabung?',
      tipe: TipeSoal.pilihanGanda,
      pilihan: ['0', '1', '2', '3'],
      jawabanBenar: 2,
      kategori: 'ruang',
      penjelasan: 'Tabung memiliki 2 rusuk lengkung (berupa lingkaran di alas dan tutup).',
      bangunId: 'br_tabung',
      poin: 10,
    ),
    SoalModel(
      id: 'q8',
      pertanyaan: 'Rumus luas lingkaran adalah...',
      tipe: TipeSoal.pilihanGanda,
      pilihan: ['2 × π × r', 'π × r²', '½ × a × t', 'π × d'],
      jawabanBenar: 1,
      kategori: 'datar',
      penjelasan: 'Luas lingkaran dihitung menggunakan rumus π × r² (pi dikali jari-jari kuadrat).',
      bangunId: 'bd_lingkaran',
      poin: 10,
    ),
    SoalModel(
      id: 'q9',
      pertanyaan: 'Bangun ruang manakah yang memiliki 5 sisi (1 segiempat, 4 segitiga)?',
      tipe: TipeSoal.pilihanGanda,
      pilihan: ['Prisma Segitiga', 'Limas Segiempat', 'Kerucut', 'Balok'],
      jawabanBenar: 1,
      kategori: 'ruang',
      penjelasan: 'Limas segiempat memiliki alas berbentuk segiempat (1 sisi) dan sisi tegak berbentuk segitiga (4 sisi).',
      bangunId: 'br_limas_segiempat',
      poin: 10,
    ),
    SoalModel(
      id: 'q10',
      pertanyaan: 'Sebuah persegi memiliki keliling 40 cm. Berapakah panjang sisinya?',
      tipe: TipeSoal.pilihanGanda,
      pilihan: ['5 cm', '10 cm', '20 cm', '400 cm'],
      jawabanBenar: 1,
      kategori: 'datar',
      penjelasan: 'Keliling persegi = 4 × s. Jika keliling 40, maka s = 40 ÷ 4 = 10 cm.',
      bangunId: 'bd_persegi',
      poin: 10,
      rumusHint: 'K = 4 × s',
    ),
  ];
}

