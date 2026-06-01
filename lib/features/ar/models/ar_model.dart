import 'package:equatable/equatable.dart';

/// Model data dari tabel `ar_models` di Supabase
class ARModelModel extends Equatable {
  const ARModelModel({
    required this.id,
    required this.nama,
    required this.qrCode,
    required this.kategori,
    this.modelUrl,
    this.bangunId,
    this.deskripsi,
  });

  final String id;
  final String nama;

  /// QR code unik yang tercetak pada marker fisik
  final String qrCode;

  /// URL file .glb/.gltf di Supabase Storage (untuk ModelViewer)
  final String? modelUrl;

  /// Relasi ke tabel bangun (opsional)
  final String? bangunId;

  /// Kategori: 'ruang' | 'datar'
  final String kategori;

  final String? deskripsi;

  factory ARModelModel.fromJson(Map<String, dynamic> json) => ARModelModel(
        id: json['id'] as String,
        nama: json['nama'] as String,
        qrCode: json['qr_code'] as String,
        modelUrl: json['model_url'] as String?,
        bangunId: json['bangun_id'] as String?,
        kategori: json['kategori'] as String? ?? 'ruang',
        deskripsi: json['deskripsi'] as String?,
      );

  @override
  List<Object?> get props => [id, qrCode, nama];
}
