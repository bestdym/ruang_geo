import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Halaman utama Ruang-Geo
///
/// Menampilkan:
/// - Hero section dengan greeting
/// - Quick access cards (Bangun Ruang, Bangun Datar, AR, Kuis)
/// - Materi terbaru / rekomendasi
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO: Implementasi hero section
                    // TODO: Implementasi quick access grid
                    // TODO: Implementasi recent section
                    Center(
                      child: Text(
                        '🚧 Home Page - Dalam Pengembangan',
                        style: AppTypography.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
