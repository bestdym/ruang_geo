import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

/// Data model untuk setiap menu di home screen
class _MenuData {
  const _MenuData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.route,
    this.badge,
    this.badgeColor,
    this.heroTag,
  });

  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;
  final String route;
  final String? badge;
  final Color? badgeColor;
  final String? heroTag;
}

/// Widget header Home Screen
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onMenuTap,
    required this.onProfileTap,
  });

  final VoidCallback onMenuTap;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ─── Hamburger ────────────────────────────────────────────────────
        _HeaderIconButton(
          icon: Icons.menu_rounded,
          onTap: onMenuTap,
          semanticLabel: 'Buka menu',
        ),

        // ─── Logo teks tengah ─────────────────────────────────────────────
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.view_in_ar_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        // ─── Profil ────────────────────────────────────────────────────────
        _HeaderIconButton(
          icon: Icons.person_rounded,
          onTap: onProfileTap,
          semanticLabel: 'Buka profil',
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget hero banner teks di home
class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(80),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Dekorasi lingkaran dalam banner
          Positioned(
            right: -10,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(20),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),

          // Konten
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '✨ Selamat Datang!',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Belajar Geometri\nLebih Seru!',
                style: AppTypography.heroTitle.copyWith(
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.appTagline,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withAlpha(210),
                ),
              ),
              const SizedBox(height: 16),

              // Stats row
              Row(
                children: [
                  _StatChip(icon: Icons.category_rounded, label: '20+ Materi'),
                  const SizedBox(width: 8),
                  _StatChip(icon: Icons.quiz_rounded, label: '100+ Soal'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
