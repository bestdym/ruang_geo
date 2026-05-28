import 'package:flutter/material.dart';
import 'package:ruang_geo/core/theme/theme.dart';

/// Komponen Chip untuk Filter Kategori
/// 
/// Contoh:
/// ```dart
/// InfoChip(
///   label: 'Prisma',
///   isActive: true,
///   onTap: () {},
/// )
/// ```
class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isActive ? Colors.white : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
