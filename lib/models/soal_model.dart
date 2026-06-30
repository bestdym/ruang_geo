import 'package:equatable/equatable.dart';

/// Enum tipe soal kuis
enum TipeSoal {
  pilihanGanda('Pilihan Ganda'),
  benarSalah('Benar atau Salah'),
  pernyataanBS('Pernyataan Benar/Salah');

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
    this.jawabanBenarMulti,
    required this.kategori,
    required this.poin,
    this.penjelasan,
    this.penjelasanGambarUrl,
    this.bangunId,
    this.imagePath,
    this.gambarUrl,
    this.rumusHint,
  });

  final String id;
  final String pertanyaan;
  final TipeSoal tipe;

  /// Daftar opsi jawaban (index 0 = A, 1 = B, dst.)
  final List<String> pilihan;

  /// Index jawaban benar dalam [pilihan]
  final int jawabanBenar;

  /// Index-index jawaban benar (multi & pernyataanBS)
  final List<int>? jawabanBenarMulti;

  /// Penjelasan setelah jawaban diungkap (opsional)
  final String? penjelasan;

  /// URL gambar penjelasan dari Supabase Storage (opsional)
  final String? penjelasanGambarUrl;

  /// Kategori soal (ruang / datar / campuran)
  final String kategori;

  /// Referensi bangun (opsional)
  final String? bangunId;
  final int poin;

  /// Path gambar soal lokal (opsional)
  final String? imagePath;

  /// URL gambar dari Supabase Storage (opsional)
  final String? gambarUrl;

  /// Hint rumus (opsional)
  final String? rumusHint;

  String get jawabanBenarTeks =>
      pilihan.isNotEmpty && jawabanBenar >= 0 && jawabanBenar < pilihan.length
          ? pilihan[jawabanBenar]
          : '';

  bool isJawaban(int index) {
    if (jawabanBenarMulti != null) {
      return jawabanBenarMulti!.contains(index);
    }
    return index == jawabanBenar;
  }

  SoalModel copyWith({
    String? id,
    String? pertanyaan,
    TipeSoal? tipe,
    List<String>? pilihan,
    int? jawabanBenar,
    List<int>? jawabanBenarMulti,
    String? penjelasan,
    String? penjelasanGambarUrl,
    String? kategori,
    String? bangunId,
    int? poin,
    String? imagePath,
    String? gambarUrl,
    String? rumusHint,
  }) {
    return SoalModel(
      id: id ?? this.id,
      pertanyaan: pertanyaan ?? this.pertanyaan,
      tipe: tipe ?? this.tipe,
      pilihan: pilihan ?? this.pilihan,
      jawabanBenar: jawabanBenar ?? this.jawabanBenar,
      jawabanBenarMulti: jawabanBenarMulti ?? this.jawabanBenarMulti,
      penjelasan: penjelasan ?? this.penjelasan,
      penjelasanGambarUrl: penjelasanGambarUrl ?? this.penjelasanGambarUrl,
      kategori: kategori ?? this.kategori,
      bangunId: bangunId ?? this.bangunId,
      poin: poin ?? this.poin,
      imagePath: imagePath ?? this.imagePath,
      gambarUrl: gambarUrl ?? this.gambarUrl,
      rumusHint: rumusHint ?? this.rumusHint,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pertanyaan': pertanyaan,
        'tipe': tipe.name,
        'pilihan': pilihan,
        'jawaban_benar': jawabanBenar,
        'jawaban_benar_multi': jawabanBenarMulti,
        'penjelasan': penjelasan,
        'penjelasan_gambar_url': penjelasanGambarUrl,
        'kategori': kategori,
        'bangun_id': bangunId,
        'poin': poin,
        'image_path': imagePath,
        'gambar_url': gambarUrl,
        'rumus_hint': rumusHint,
      };

  /// Factory dari Supabase JSON
  factory SoalModel.fromJson(Map<String, dynamic> json) => SoalModel(
        id: json['id'] as String,
        pertanyaan: json['pertanyaan'] as String,
        tipe: TipeSoal.values.firstWhere(
          (t) => t.name == (json['tipe'] as String? ?? 'pilihanGanda'),
          orElse: () => TipeSoal.pilihanGanda,
        ),
        pilihan: List<String>.from(json['pilihan'] as List),
        jawabanBenar: json['jawaban_benar'] as int? ?? -1,
        jawabanBenarMulti: json['jawaban_benar_multi'] != null
            ? List<int>.from(json['jawaban_benar_multi'] as List)
            : null,
        penjelasan: json['penjelasan'] as String?,
        penjelasanGambarUrl: json['penjelasan_gambar_url'] as String?,
        kategori: json['kategori'] as String? ?? 'campuran',
        bangunId: json['bangun_id'] as String?,
        poin: json['poin'] as int? ?? 10,
        imagePath: json['image_path'] as String?,
        gambarUrl: json['gambar_url'] as String?,
        rumusHint: json['rumus_hint'] as String?,
      );

  @override
  List<Object?> get props => [id, pertanyaan, tipe, kategori, poin];
}
