import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

/// Halaman menu AR - pilih bangun untuk dilihat di AR
///
/// Nanti akan menggunakan flutter_unity_widget untuk menampilkan
/// scene Unity di dalam Flutter.
class ArPage extends StatelessWidget {
  const ArPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Augmented Reality')),
      body: const Center(
        child: Text('🚧 AR Mode - Dalam Pengembangan'),
      ),
    );
  }
}


