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
}
