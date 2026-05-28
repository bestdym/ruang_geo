import 'package:flutter/material.dart';
import '../../../core/core.dart';

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

/// Halaman AR View dengan Unity widget aktif
class ArViewPage extends StatelessWidget {
  const ArViewPage({super.key, required this.shapeId});

  final String shapeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AR: $shapeId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt_outlined,
                size: 64, color: AppColors.accent),
            const SizedBox(height: 16),
            Text('Unity AR View untuk: $shapeId'),
            const SizedBox(height: 8),
            const Text(
              'Aktifkan flutter_unity_widget untuk AR',
              style: TextStyle(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}
