import 'dart:math' as math;

/// Utility untuk kalkulasi geometri
abstract class GeometryUtils {
  // ─── Bangun Ruang ─────────────────────────────────────────────────────────────

  /// Volume Kubus: V = s³
  static double volumeKubus(double sisi) => math.pow(sisi, 3).toDouble();

  /// Luas Permukaan Kubus: L = 6s²
  static double luasKubus(double sisi) => 6 * math.pow(sisi, 2).toDouble();

  /// Volume Balok: V = p × l × t
  static double volumeBalok(double p, double l, double t) => p * l * t;

  /// Luas Permukaan Balok: L = 2(pl + pt + lt)
  static double luasBalok(double p, double l, double t) =>
      2 * (p * l + p * t + l * t);

  /// Volume Tabung: V = πr²t
  static double volumeTabung(double r, double t) => math.pi * r * r * t;

  /// Luas Permukaan Tabung: L = 2πr(r + t)
  static double luasTabung(double r, double t) => 2 * math.pi * r * (r + t);

  /// Volume Kerucut: V = ⅓πr²t
  static double volumeKerucut(double r, double t) =>
      (1 / 3) * math.pi * r * r * t;

  /// Panjang garis pelukis Kerucut: s = √(r² + t²)
  static double garisPeluKisKerucut(double r, double t) =>
      math.sqrt(r * r + t * t);

  /// Luas Permukaan Kerucut: L = πr(r + s)
  static double luasKerucut(double r, double t) {
    final s = garisPeluKisKerucut(r, t);
    return math.pi * r * (r + s);
  }

  /// Volume Bola: V = ⁴⁄₃πr³
  static double volumeBola(double r) =>
      (4 / 3) * math.pi * math.pow(r, 3).toDouble();

  /// Luas Permukaan Bola: L = 4πr²
  static double luasBola(double r) => 4 * math.pi * r * r;

  /// Volume Prisma Segitiga: V = ½ × a × t_alas × tinggi_prisma
  static double volumePrismaSegitiga(
          double alas, double tinggiAlas, double tinggiPrisma) =>
      0.5 * alas * tinggiAlas * tinggiPrisma;

  /// Volume Limas Segiempat: V = ⅓ × p × l × t
  static double volumeLimas(double p, double l, double t) =>
      (1 / 3) * p * l * t;

  // ─── Bangun Datar ─────────────────────────────────────────────────────────────

  /// Luas Persegi: A = s²
  static double luasPersegi(double sisi) => math.pow(sisi, 2).toDouble();

  /// Keliling Persegi: K = 4s
  static double kelilingPersegi(double sisi) => 4 * sisi;

  /// Luas Persegi Panjang: A = p × l
  static double luasPersegiPanjang(double p, double l) => p * l;

  /// Keliling Persegi Panjang: K = 2(p + l)
  static double kelilingPersegiPanjang(double p, double l) => 2 * (p + l);

  /// Luas Segitiga: A = ½ × a × t
  static double luasSegitiga(double alas, double tinggi) =>
      0.5 * alas * tinggi;

  /// Keliling Segitiga: K = a + b + c
  static double kelilingSegitiga(double a, double b, double c) => a + b + c;

  /// Luas Lingkaran: A = πr²
  static double luasLingkaran(double r) => math.pi * r * r;

  /// Keliling Lingkaran: K = 2πr
  static double kelilingLingkaran(double r) => 2 * math.pi * r;

  /// Luas Trapesium: A = ½ × (a + b) × t
  static double luasTrapesium(double a, double b, double t) =>
      0.5 * (a + b) * t;

  /// Luas Jajargenjang: A = a × t
  static double luasJajargenjang(double alas, double tinggi) => alas * tinggi;

  /// Luas Belah Ketupat: A = ½ × d1 × d2
  static double luasBelahKetupat(double d1, double d2) => 0.5 * d1 * d2;

  /// Luas Layang-layang: A = ½ × d1 × d2
  static double luasLayangLayang(double d1, double d2) => 0.5 * d1 * d2;

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  /// Format angka desimal dengan presisi yang bersih
  static String formatAngka(double value, {int desimal = 2}) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(desimal);
  }

  /// Konversi derajat ke radian
  static double degToRad(double deg) => deg * math.pi / 180;

  /// Konversi radian ke derajat
  static double radToDeg(double rad) => rad * 180 / math.pi;
}
