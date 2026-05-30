/// Helper untuk mendapatkan path file .glb dari ID bangun.
///
/// Semua file .glb disimpan di `assets/models/bangun_ruang/`
/// Nama file sesuai konvensi: `{nama_bangun}.glb`
abstract class ModelPathHelper {
  /// Mapping dari bangun ID → path .glb
  static const Map<String, String> _bangunRuangPaths = {
    'br_kubus': 'assets/models/bangun_ruang/kubus.glb',
    'br_balok': 'assets/models/bangun_ruang/balok.glb',
    'br_prisma_segitiga': 'assets/models/bangun_ruang/prisma_segitiga.glb',
    'br_limas_segiempat': 'assets/models/bangun_ruang/limas_segiempat.glb',
    'br_tabung': 'assets/models/bangun_ruang/tabung.glb',
    'br_kerucut': 'assets/models/bangun_ruang/kerucut.glb',
    'br_bola': 'assets/models/bangun_ruang/bola.glb',
  };

  static const Map<String, String> _bangunDatarPaths = {
    'bd_persegi': 'assets/models/bangun_datar/persegi.glb',
    'bd_persegi_panjang': 'assets/models/bangun_datar/persegi_panjang.glb',
    'bd_segitiga': 'assets/models/bangun_datar/segitiga.glb',
    'bd_jajargenjang': 'assets/models/bangun_datar/jajargenjang.glb',
    'bd_trapesium': 'assets/models/bangun_datar/trapesium.glb',
    'bd_layang': 'assets/models/bangun_datar/layang.glb',
    'bd_lingkaran': 'assets/models/bangun_datar/lingkaran.glb',
  };

  /// Mendapatkan path .glb berdasarkan ID bangun.
  /// Mengembalikan null jika ID tidak ditemukan.
  static String? getModelPath(String bangunId) {
    return _bangunRuangPaths[bangunId] ?? _bangunDatarPaths[bangunId];
  }

  /// Apakah ID bangun adalah bangun ruang (3D)?
  static bool isBangunRuang(String bangunId) =>
      bangunId.startsWith('br_');

  /// Apakah ID bangun adalah bangun datar (2D)?
  static bool isBangunDatar(String bangunId) =>
      bangunId.startsWith('bd_');
}
