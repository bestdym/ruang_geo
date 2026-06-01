import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';

/// Halaman Hasil Kuis
class KuisHasilPage extends StatelessWidget {
  const KuisHasilPage({
    super.key,
    required this.kategori,
    required this.score,
    required this.total,
    required this.poin,
  });

  final String kategori;
  final int score;
  final int total;
  final int poin;

  @override
  Widget build(BuildContext context) {
    // Hitung persentase dan bintang
    final double percentage = total == 0 ? 0 : score / total;
    int stars = 0;
    if (percentage == 1.0) {
      stars = 3;
    } else if (percentage >= 0.6) {
      stars = 2;
    } else if (percentage >= 0.3) {
      stars = 1;
    }

    // Pesan berdasarkan hasil
    String title;
    String subtitle;
    if (stars == 3) {
      title = 'Luar Biasa!';
      subtitle = 'Kamu menjawab semua soal dengan benar.';
    } else if (stars == 2) {
      title = 'Kerja Bagus!';
      subtitle = 'Sedikit lagi untuk mencapai nilai sempurna.';
    } else if (stars == 1) {
      title = 'Tetap Semangat!';
      subtitle = 'Coba lagi, kamu pasti bisa lebih baik.';
    } else {
      title = 'Waduh...';
      subtitle = 'Jangan menyerah, mari pelajari lagi materinya.';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarCustom(
        title: 'Hasil Kuis',
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ─── Bintang ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Star(isActive: stars >= 1, size: 60),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _Star(isActive: stars >= 2, size: 80),
                  ),
                  _Star(isActive: stars >= 3, size: 60),
                ],
              ),
              const SizedBox(height: 24),

              // ─── Teks Hasil ───────────────────────────────────────────
              Text(
                title,
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // ─── Skor Card ────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(20),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'SKOR KAMU',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textHint,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$score',
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        Text(
                          ' / $total',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.textHint,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars_rounded, color: AppColors.warning),
                          const SizedBox(width: 8),
                          Text(
                            '+$poin Poin',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // ─── Tombol Aksi ──────────────────────────────────────────
              ElevatedButton(
                onPressed: () {
                  // Ulangi
                  context.pushReplacement('/kuis/$kategori');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text('Ulangi Kuis'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  // Kembali ke Home
                  context.go('/home');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text('Kembali ke Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({required this.isActive, required this.size});

  final bool isActive;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star_rounded,
      size: size,
      color: isActive ? AppColors.warning : AppColors.outlineVariant,
    );
  }
}
