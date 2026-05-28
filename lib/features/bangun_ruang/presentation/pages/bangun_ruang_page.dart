import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Halaman daftar Bangun Ruang
///
/// Menampilkan:
/// - Search bar
/// - Filter tingkat (mudah/sedang/sulit)
/// - Grid list bangun ruang (kubus, balok, tabung, dst.)
class BangunRuangPage extends StatelessWidget {
  const BangunRuangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bangun Ruang'),
      ),
      body: const Center(
        child: Text('🚧 Bangun Ruang - Dalam Pengembangan'),
      ),
    );
  }
}

/// Halaman detail satu Bangun Ruang
class BangunRuangDetailPage extends StatelessWidget {
  const BangunRuangDetailPage({super.key, required this.bangunId});

  final String bangunId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail: $bangunId')),
      body: Center(
        child: Text('Detail Bangun Ruang: $bangunId'),
      ),
    );
  }
}
