import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';

import '../../../home/presentation/widgets/home_widgets.dart';

/// Halaman awal Kuis - Pilih Kategori
class KuisPage extends StatelessWidget {
  const KuisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: Builder(
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeHeader(
                  onMenuTap: () => Scaffold.of(context).openDrawer(),
                title: 'Kuis',
                icon: Icons.quiz_rounded,
              ),
              const SizedBox(height: 24),
              // ─── Header Banner ───────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingLG),
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                  border: Border.all(color: AppColors.warning.withAlpha(75), width: 2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Uji Pemahamanmu!',
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingXS),
                          Text(
                            'Pilih kategori kuis dan raih skor tertinggi.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMD),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingMD),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withAlpha(50),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        size: AppConstants.iconLG,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),

            Text(
              'Pilih Kategori',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // ─── Grid Kategori ───────────────────────────────────────────
            // ─── List Kategori ───────────────────────────────────────────
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                _KategoriCard(
                  title: 'Bangun Ruang',
                  icon: Icons.view_in_ar_rounded,
                  color: AppColors.primary,
                  onTap: () => context.push('/kuis/ruang'),
                ),
                _KategoriCard(
                  title: 'Bangun Datar',
                  icon: Icons.category_rounded,
                  color: AppColors.secondary,
                  onTap: () => context.push('/kuis/datar'),
                ),
                _KategoriCard(
                  title: 'Campuran',
                  icon: Icons.shuffle_rounded,
                  color: AppColors.warning,
                  onTap: () => context.push('/kuis/campuran'),
                ),
                _KategoriCard(
                  title: 'TKA',
                  icon: Icons.psychology_rounded,
                  color: AppColors.error,
                  onTap: () => context.push('/kuis/tka'),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
      ),
    );
  }
}

class _KategoriCard extends StatelessWidget {
  const _KategoriCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
