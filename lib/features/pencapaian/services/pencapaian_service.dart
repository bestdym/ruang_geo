import '../../../core/services/supabase_service.dart';
import '../models/pencapaian_model.dart';

class PencapaianService {
  /// Mengambil semua pencapaian user dari Supabase, terbaru di atas
  Future<List<PencapaianModel>> getPencapaianUser(String userId) async {
    try {
      final data = await supabase
          .from('pencapaian')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (data as List)
          .map((json) => PencapaianModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Menghitung statistik agregat dari daftar pencapaian
  StatistikModel getStatistikUser(List<PencapaianModel> daftarPencapaian) {
    if (daftarPencapaian.isEmpty) {
      return const StatistikModel(
        totalKuis: 0,
        rataSkor: 0,
        totalPoin: 0,
        kuisTerbaik: {},
      );
    }

    final totalKuis = daftarPencapaian.length;
    final totalPoin = daftarPencapaian.fold<int>(
      0,
      (sum, p) => sum + p.totalPoin,
    );
    final rataSkor = daftarPencapaian.fold<double>(
          0,
          (sum, p) => sum + p.skor,
        ) /
        totalKuis;

    // Skor terbaik per kategori
    final Map<String, double> kuisTerbaik = {};
    for (final p in daftarPencapaian) {
      final existing = kuisTerbaik[p.kategori] ?? 0.0;
      if (p.skor > existing) {
        kuisTerbaik[p.kategori] = p.skor;
      }
    }

    return StatistikModel(
      totalKuis: totalKuis,
      rataSkor: rataSkor,
      totalPoin: totalPoin,
      kuisTerbaik: kuisTerbaik,
    );
  }
}
