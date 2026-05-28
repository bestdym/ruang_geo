import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

/// Halaman menu kuis - pilih kategori
class KuisPage extends StatelessWidget {
  const KuisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Kuis Geometri')),
      body: const Center(
        child: Text('🚧 Kuis - Dalam Pengembangan'),
      ),
    );
  }
}

/// Halaman bermain kuis dengan timer
class KuisPlayPage extends StatelessWidget {
  const KuisPlayPage({super.key, required this.kategori});

  final String kategori;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kuis: $kategori')),
      body: Center(child: Text('Kuis bermain: $kategori')),
    );
  }
}

/// Halaman hasil kuis
class KuisHasilPage extends StatelessWidget {
  const KuisHasilPage({super.key, required this.kategori});

  final String kategori;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Kuis')),
      body: const Center(child: Text('Hasil kuis ditampilkan di sini')),
    );
  }
}
