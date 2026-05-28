import 'package:equatable/equatable.dart';

/// Enum kategori bangun geometri
enum KategoriBangun {
  ruang('Bangun Ruang', 'bangun_ruang'),
  datar('Bangun Datar', 'bangun_datar');

  const KategoriBangun(this.label, this.slug);
  final String label;
  final String slug;
}

/// Enum tingkat kesulitan materi
enum TingkatKesulitan {
  mudah('Mudah', 1),
  sedang('Sedang', 2),
  sulit('Sulit', 3);

  const TingkatKesulitan(this.label, this.level);
  final String label;
  final int level;
}

/// Model bangun geometri (Ruang dan Datar)
class BangunModel extends Equatable {
  const BangunModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.deskripsi,
    required this.rumusLuas,
    required this.rumusVolume,
    required this.imagePath,
    required this.iconPath,
    required this.tingkat,
    required this.sifatSifat,
    required this.contohNyata,
    this.arModelId,
    this.isUnlocked = true,
  });

  final String id;
  final String nama;
  final KategoriBangun kategori;
  final String deskripsi;

  /// Rumus luas permukaan (null untuk bangun datar = rumus luas biasa)
  final String rumusLuas;

  /// Rumus volume (null untuk bangun datar)
  final String? rumusVolume;

  final String imagePath;
  final String iconPath;
  final TingkatKesulitan tingkat;

  /// Daftar sifat/ciri-ciri bangun
  final List<String> sifatSifat;

  /// Contoh benda nyata di kehidupan sehari-hari
  final List<String> contohNyata;

  /// ID model 3D untuk fitur AR (Unity)
  final String? arModelId;

  final bool isUnlocked;

  bool get isBangunRuang => kategori == KategoriBangun.ruang;
  bool get hasARSupport => arModelId != null;

  BangunModel copyWith({
    String? id,
    String? nama,
    KategoriBangun? kategori,
    String? deskripsi,
    String? rumusLuas,
    String? rumusVolume,
    String? imagePath,
    String? iconPath,
    TingkatKesulitan? tingkat,
    List<String>? sifatSifat,
    List<String>? contohNyata,
    String? arModelId,
    bool? isUnlocked,
  }) {
    return BangunModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      deskripsi: deskripsi ?? this.deskripsi,
      rumusLuas: rumusLuas ?? this.rumusLuas,
      rumusVolume: rumusVolume ?? this.rumusVolume,
      imagePath: imagePath ?? this.imagePath,
      iconPath: iconPath ?? this.iconPath,
      tingkat: tingkat ?? this.tingkat,
      sifatSifat: sifatSifat ?? this.sifatSifat,
      contohNyata: contohNyata ?? this.contohNyata,
      arModelId: arModelId ?? this.arModelId,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'kategori': kategori.slug,
        'deskripsi': deskripsi,
        'rumus_luas': rumusLuas,
        'rumus_volume': rumusVolume,
        'image_path': imagePath,
        'icon_path': iconPath,
        'tingkat': tingkat.level,
        'sifat_sifat': sifatSifat,
        'contoh_nyata': contohNyata,
        'ar_model_id': arModelId,
        'is_unlocked': isUnlocked,
      };

  factory BangunModel.fromJson(Map<String, dynamic> json) => BangunModel(
        id: json['id'] as String,
        nama: json['nama'] as String,
        kategori: KategoriBangun.values.firstWhere(
          (k) => k.slug == json['kategori'],
          orElse: () => KategoriBangun.ruang,
        ),
        deskripsi: json['deskripsi'] as String,
        rumusLuas: json['rumus_luas'] as String,
        rumusVolume: json['rumus_volume'] as String?,
        imagePath: json['image_path'] as String,
        iconPath: json['icon_path'] as String,
        tingkat: TingkatKesulitan.values.firstWhere(
          (t) => t.level == json['tingkat'],
          orElse: () => TingkatKesulitan.mudah,
        ),
        sifatSifat: List<String>.from(json['sifat_sifat'] as List),
        contohNyata: List<String>.from(json['contoh_nyata'] as List),
        arModelId: json['ar_model_id'] as String?,
        isUnlocked: json['is_unlocked'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [
        id,
        nama,
        kategori,
        tingkat,
        isUnlocked,
        arModelId,
      ];
}
