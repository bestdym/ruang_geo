import 'package:equatable/equatable.dart';

/// Model data profil pengguna dari tabel `profiles` Supabase
class ProfileModel extends Equatable {
  const ProfileModel({
    required this.id,
    this.username,
    this.fullName,
    this.avatarUrl,
    this.kelas,
    this.sekolah,
    this.totalPoin,
  });

  final String id;
  final String? username;
  final String? fullName;
  final String? avatarUrl;
  final String? kelas;
  final String? sekolah;
  final int? totalPoin;

  /// Profil dianggap lengkap jika 4 field utama sudah terisi
  bool get isProfileComplete =>
      fullName != null &&
      fullName!.isNotEmpty &&
      username != null &&
      username!.isNotEmpty &&
      kelas != null &&
      kelas!.isNotEmpty &&
      sekolah != null &&
      sekolah!.isNotEmpty;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as String,
        username: json['username'] as String?,
        fullName: json['full_name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        kelas: json['kelas'] as String?,
        sekolah: json['sekolah'] as String?,
        totalPoin: json['total_poin'] as int?,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'id': id};
    if (username != null) map['username'] = username;
    if (fullName != null) map['full_name'] = fullName;
    if (avatarUrl != null) map['avatar_url'] = avatarUrl;
    if (kelas != null) map['kelas'] = kelas;
    if (sekolah != null) map['sekolah'] = sekolah;
    if (totalPoin != null) map['total_poin'] = totalPoin;
    return map;
  }

  ProfileModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? avatarUrl,
    String? kelas,
    String? sekolah,
    int? totalPoin,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      kelas: kelas ?? this.kelas,
      sekolah: sekolah ?? this.sekolah,
      totalPoin: totalPoin ?? this.totalPoin,
    );
  }

  @override
  List<Object?> get props => [id, username, fullName, kelas, sekolah];
}
