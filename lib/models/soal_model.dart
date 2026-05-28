import 'package:equatable/equatable.dart';

/// Enum tipe soal kuis
enum TipeSoal {
  pilihanGanda('Pilihan Ganda'),
  benarSalah('Benar atau Salah'),
  isiLengkap('Isi Lengkap');

  const TipeSoal(this.label);
  final String label;
}

/// Model satu soal kuis
class SoalModel extends Equatable {
  const SoalModel({
    required this.id,
    required this.pertanyaan,
    required this.tipe,
    required this.pilihan,
    required this.jawabanBenar,
    required this.penjelasan,
    required this.bangunId,
    required this.poin,
    this.imagePath,
    this.rumusHint,
  });

  final String id;
  final String pertanyaan;
  final TipeSoal tipe;

  /// Daftar opsi jawaban (index 0 = A, 1 = B, dst.)
  final List<String> pilihan;

  /// Index jawaban benar dalam [pilihan]
  final int jawabanBenar;

  /// Penjelasan setelah jawaban diungkap
  final String penjelasan;

  final String bangunId;
  final int poin;

  /// Path gambar soal (opsional)
  final String? imagePath;

  /// Hint rumus (opsional)
  final String? rumusHint;

  String get jawabanBenarTeks =>
      pilihan.isNotEmpty && jawabanBenar < pilihan.length
          ? pilihan[jawabanBenar]
          : '';

  bool isJawaban(int index) => index == jawabanBenar;

  SoalModel copyWith({
    String? id,
    String? pertanyaan,
    TipeSoal? tipe,
    List<String>? pilihan,
    int? jawabanBenar,
    String? penjelasan,
    String? bangunId,
    int? poin,
    String? imagePath,
    String? rumusHint,
  }) {
    return SoalModel(
      id: id ?? this.id,
      pertanyaan: pertanyaan ?? this.pertanyaan,
      tipe: tipe ?? this.tipe,
      pilihan: pilihan ?? this.pilihan,
      jawabanBenar: jawabanBenar ?? this.jawabanBenar,
      penjelasan: penjelasan ?? this.penjelasan,
      bangunId: bangunId ?? this.bangunId,
      poin: poin ?? this.poin,
      imagePath: imagePath ?? this.imagePath,
      rumusHint: rumusHint ?? this.rumusHint,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pertanyaan': pertanyaan,
        'tipe': tipe.name,
        'pilihan': pilihan,
        'jawaban_benar': jawabanBenar,
        'penjelasan': penjelasan,
        'bangun_id': bangunId,
        'poin': poin,
        'image_path': imagePath,
        'rumus_hint': rumusHint,
      };

  factory SoalModel.fromJson(Map<String, dynamic> json) => SoalModel(
        id: json['id'] as String,
        pertanyaan: json['pertanyaan'] as String,
        tipe: TipeSoal.values.firstWhere(
          (t) => t.name == json['tipe'],
          orElse: () => TipeSoal.pilihanGanda,
        ),
        pilihan: List<String>.from(json['pilihan'] as List),
        jawabanBenar: json['jawaban_benar'] as int,
        penjelasan: json['penjelasan'] as String,
        bangunId: json['bangun_id'] as String,
        poin: json['poin'] as int? ?? 10,
        imagePath: json['image_path'] as String?,
        rumusHint: json['rumus_hint'] as String?,
      );

  @override
  List<Object?> get props => [id, pertanyaan, tipe, bangunId, poin];
}
