import 'package:equatable/equatable.dart';
import 'soal_model.dart';

/// Enum status kuis
enum StatusKuis {
  belumMulai,
  berjalan,
  jeda,
  selesai,
}

/// Hasil satu jawaban dalam sesi kuis
class JawabanSesi extends Equatable {
  const JawabanSesi({
    required this.soalId,
    required this.indexDipilih,
    required this.isBenar,
    required this.waktuMenjawab,
    required this.poinDidapat,
  });

  final String soalId;
  final int indexDipilih; // -1 = tidak menjawab (lewati)
  final bool isBenar;
  final int waktuMenjawab; // dalam detik
  final int poinDidapat;

  bool get isDilewati => indexDipilih == -1;

  @override
  List<Object?> get props => [soalId, indexDipilih, isBenar, poinDidapat];
}

/// Model hasil kuis lengkap
class HasilKuisModel extends Equatable {
  const HasilKuisModel({
    required this.id,
    required this.kategori,
    required this.totalSoal,
    required this.jawabanSesi,
    required this.waktuSelesai,
    required this.tanggal,
  });

  final String id;
  final String kategori;
  final int totalSoal;
  final List<JawabanSesi> jawabanSesi;
  final int waktuSelesai; // total waktu dalam detik
  final DateTime tanggal;

  int get totalBenar => jawabanSesi.where((j) => j.isBenar).length;
  int get totalSalah =>
      jawabanSesi.where((j) => !j.isBenar && !j.isDilewati).length;
  int get totalDilewati => jawabanSesi.where((j) => j.isDilewati).length;
  int get totalPoin => jawabanSesi.fold(0, (sum, j) => sum + j.poinDidapat);

  double get persentaseBenar =>
      totalSoal == 0 ? 0 : (totalBenar / totalSoal) * 100;

  bool get lulus => persentaseBenar >= 60;

  String get grade {
    if (persentaseBenar >= 90) return 'A';
    if (persentaseBenar >= 80) return 'B';
    if (persentaseBenar >= 70) return 'C';
    if (persentaseBenar >= 60) return 'D';
    return 'E';
  }

  String get pesan {
    if (persentaseBenar >= 90) return 'Luar biasa! Kamu sangat hebat! 🏆';
    if (persentaseBenar >= 70) return 'Bagus sekali! Terus berlatih! 🌟';
    if (persentaseBenar >= 60) return 'Cukup baik, kamu lulus! 👍';
    return 'Jangan menyerah, coba lagi ya! 💪';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kategori': kategori,
        'total_soal': totalSoal,
        'total_benar': totalBenar,
        'total_poin': totalPoin,
        'persentase': persentaseBenar,
        'waktu_selesai': waktuSelesai,
        'tanggal': tanggal.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, kategori, totalPoin, persentaseBenar, tanggal];
}

/// Session state untuk kuis aktif
class KuisSesiModel extends Equatable {
  const KuisSesiModel({
    required this.soalList,
    required this.indexSaatIni,
    required this.jawabanSesi,
    required this.sisaWaktu,
    required this.status,
    required this.skipTersisa,
  });

  final List<SoalModel> soalList;
  final int indexSaatIni;
  final List<JawabanSesi> jawabanSesi;
  final int sisaWaktu;
  final StatusKuis status;
  final int skipTersisa;

  SoalModel? get soalSaatIni =>
      indexSaatIni < soalList.length ? soalList[indexSaatIni] : null;

  bool get isSelesai =>
      status == StatusKuis.selesai ||
      indexSaatIni >= soalList.length;

  bool get bisaSkip => skipTersisa > 0;

  int get progress => soalList.isEmpty ? 0 : indexSaatIni + 1;
  double get progressPercent =>
      soalList.isEmpty ? 0 : (indexSaatIni + 1) / soalList.length;

  KuisSesiModel copyWith({
    List<SoalModel>? soalList,
    int? indexSaatIni,
    List<JawabanSesi>? jawabanSesi,
    int? sisaWaktu,
    StatusKuis? status,
    int? skipTersisa,
  }) {
    return KuisSesiModel(
      soalList: soalList ?? this.soalList,
      indexSaatIni: indexSaatIni ?? this.indexSaatIni,
      jawabanSesi: jawabanSesi ?? this.jawabanSesi,
      sisaWaktu: sisaWaktu ?? this.sisaWaktu,
      status: status ?? this.status,
      skipTersisa: skipTersisa ?? this.skipTersisa,
    );
  }

  @override
  List<Object?> get props =>
      [indexSaatIni, sisaWaktu, status, skipTersisa, jawabanSesi.length];
}
