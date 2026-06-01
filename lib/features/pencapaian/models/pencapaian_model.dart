import 'package:equatable/equatable.dart';

/// Model satu record pencapaian dari tabel `pencapaian`
class PencapaianModel extends Equatable {
  const PencapaianModel({
    required this.id,
    required this.kategori,
    required this.soalBenar,
    required this.totalSoal,
    required this.totalPoin,
    required this.bintang,
    required this.createdAt,
  });

  final String id;
  final String kategori;
  final int soalBenar;
  final int totalSoal;
  final int totalPoin;
  final int bintang;
  final DateTime createdAt;

  /// Skor dalam persen (0.0 - 100.0)
  double get skor => totalSoal == 0 ? 0 : (soalBenar / totalSoal) * 100;

  /// Label kategori yang rapi untuk ditampilkan
  String get kategoriLabel {
    switch (kategori) {
      case 'ruang':
        return 'Bangun Ruang';
      case 'datar':
        return 'Bangun Datar';
      case 'tka':
        return 'TKA';
      default:
        return 'Campuran';
    }
  }

  factory PencapaianModel.fromJson(Map<String, dynamic> json) => PencapaianModel(
        id: json['id'] as String,
        kategori: json['kategori'] as String? ?? 'campuran',
        soalBenar: json['soal_benar'] as int? ?? 0,
        totalSoal: json['total_soal'] as int? ?? 10,
        totalPoin: json['total_poin'] as int? ?? 0,
        bintang: json['bintang'] as int? ?? 0,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  @override
  List<Object?> get props => [id, kategori, soalBenar, totalPoin, createdAt];
}

/// Model statistik agregat user
class StatistikModel extends Equatable {
  const StatistikModel({
    required this.totalKuis,
    required this.rataSkor,
    required this.totalPoin,
    required this.kuisTerbaik,
  });

  final int totalKuis;
  final double rataSkor;
  final int totalPoin;

  /// Skor terbaik per kategori {'ruang': 90.0, 'datar': 80.0, 'campuran': 70.0}
  final Map<String, double> kuisTerbaik;

  @override
  List<Object?> get props => [totalKuis, rataSkor, totalPoin];
}
