import '../../../core/services/supabase_service.dart';
import '../../../models/soal_model.dart';

class KuisService {
  /// Mengambil soal berdasarkan kategori dari Supabase
  Future<List<SoalModel>> getSoalByKategori(String kategori) async {
    late List<dynamic> data;

    if (kategori == 'campuran') {
      // Ambil semua kategori
      data = await supabase
          .from('soal')
          .select()
          .eq('is_active', true)
          .limit(10);
    } else {
      String dbKategori = kategori;
      if (kategori == 'ruang') {
        dbKategori = 'bangun_ruang';
      } else if (kategori == 'datar') {
        dbKategori = 'bangun_datar';
      } else if (kategori == 'tka') {
        dbKategori = 'TKA';
      }

      // Filter berdasarkan kategori spesifik
      data = await supabase
          .from('soal')
          .select()
          .eq('is_active', true)
          .eq('kategori', dbKategori)
          .limit(10);
    }

    return data.map((json) => SoalModel.fromJson(json)).toList();
  }

  /// Membuat sesi kuis baru di Supabase dan mengembalikan ID sesi
  Future<String?> mulaiSesi(
      String userId, String kategori, int totalSoal) async {
    try {
      final data = await supabase
          .from('sesi_kuis')
          .insert({
            'user_id': userId,
            'kategori': kategori,
            'total_soal': totalSoal,
            'status': 'berlangsung',
            'started_at': DateTime.now().toIso8601String(),
          })
          .select('id')
          .single();
      return data['id'] as String;
    } catch (e) {
      return null;
    }
  }

  /// Menyimpan satu jawaban ke Supabase
  Future<void> simpanJawaban({
    required String sesiId,
    required String soalId,
    required int jawabanDipilih,
    required bool isBenar,
    required int poin,
  }) async {
    try {
      await supabase.from('jawaban_kuis').insert({
        'sesi_id': sesiId,
        'soal_id': soalId,
        'jawaban_dipilih': jawabanDipilih,
        'is_benar': isBenar,
        'poin_didapat': isBenar ? poin : 0,
      });
    } catch (e) {
      // Gagal simpan jawaban tidak crash app
    }
  }

  /// Menyelesaikan sesi kuis dan menyimpan pencapaian
  Future<void> selesaikanSesi({
    required String sesiId,
    required String userId,
    required String kategori,
    required int soalBenar,
    required int totalSoal,
    required int totalPoin,
    required int durasiDetik,
  }) async {
    final bintang = hitungBintang(soalBenar, totalSoal);

    try {
      // 1. Update status sesi menjadi 'selesai'
      await supabase.from('sesi_kuis').update({
        'status': 'selesai',
        'soal_benar': soalBenar,
        'total_poin': totalPoin,
        'bintang': bintang,
        'durasi_detik': durasiDetik,
        'finished_at': DateTime.now().toIso8601String(),
      }).eq('id', sesiId);

      // 2. Simpan pencapaian
      await supabase.from('pencapaian').upsert({
        'user_id': userId,
        'kategori': kategori,
        'soal_benar': soalBenar,
        'total_soal': totalSoal,
        'total_poin': totalPoin,
        'bintang': bintang,
        'sesi_id': sesiId,
      });
    } catch (e) {
      // Gagal update tidak crash app
    }
  }

  /// Menghitung jumlah bintang berdasarkan skor
  int hitungBintang(int soalBenar, int totalSoal) {
    if (totalSoal == 0) return 0;
    final persen = soalBenar / totalSoal * 100;
    if (persen >= 80) return 3;
    if (persen >= 60) return 2;
    return 1;
  }
}
