import 'package:flutter/material.dart';
import 'package:ruang_geo/core/theme/theme.dart';

/// Komponen Card Bangun Ruang/Datar
/// 
/// Contoh:
/// ```dart
/// ShapeCard(
///   title: 'Kubus',
///   icon: Icons.view_in_ar,
///   color: AppColors.primary,
///   onTap: () {},
/// )
/// ```
class ShapeCard extends StatelessWidget {
  const ShapeCard({
    super.key,
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
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(icon, size: 48, color: color),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.star_border_rounded, color: AppColors.textHint, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
