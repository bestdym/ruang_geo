import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

class JawabanCard extends StatelessWidget {
  const JawabanCard({
    super.key,
    required this.abjad,
    required this.teks,
    required this.isRevealed,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  });

  final String abjad;
  final String teks;
  final bool isRevealed;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color getBorderColor() {
      if (!isRevealed) return isSelected ? AppColors.secondary : AppColors.outlineVariant;
      if (isCorrect) return AppColors.success;
      if (isSelected && !isCorrect) return AppColors.error;
      return AppColors.outlineVariant;
    }

    Color getBgColor() {
      if (!isRevealed) return isSelected ? AppColors.secondary.withAlpha(20) : AppColors.surface;
      if (isCorrect) return AppColors.success.withAlpha(20);
      if (isSelected && !isCorrect) return AppColors.error.withAlpha(20);
      return AppColors.surface;
    }

    IconData? getIcon() {
      if (!isRevealed) return null;
      if (isCorrect) return Icons.check_circle_rounded;
      if (isSelected && !isCorrect) return Icons.cancel_rounded;
      return null;
    }

    Color getIconColor() {
      if (isCorrect) return AppColors.success;
      return AppColors.error;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: getBgColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: getBorderColor(), width: isSelected || (isRevealed && isCorrect) ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isRevealed && isCorrect
                    ? AppColors.success
                    : (isSelected && !isRevealed ? AppColors.secondary : AppColors.surfaceVariant),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  abjad,
                  style: AppTypography.titleSmall.copyWith(
                    color: (isRevealed && isCorrect) || (isSelected && !isRevealed)
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                teks,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (getIcon() != null) ...[
              const SizedBox(width: 12),
              Icon(getIcon(), color: getIconColor()),
            ],
          ],
        ),
      ),
    );
  }
}
