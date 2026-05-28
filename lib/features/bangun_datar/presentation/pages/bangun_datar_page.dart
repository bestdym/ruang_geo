import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Halaman daftar Bangun Datar
class BangunDatarPage extends StatelessWidget {
  const BangunDatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Bangun Datar')),
      body: const Center(
        child: Text('🚧 Bangun Datar - Dalam Pengembangan'),
      ),
    );
  }
}

/// Halaman detail satu Bangun Datar
class BangunDatarDetailPage extends StatelessWidget {
  const BangunDatarDetailPage({super.key, required this.bangunId});

  final String bangunId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail: $bangunId')),
      body: Center(child: Text('Detail Bangun Datar: $bangunId')),
    );
  }
}
