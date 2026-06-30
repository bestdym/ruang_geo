import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

class PernyataanCard extends StatelessWidget {
  const PernyataanCard({
    super.key,
    required this.teks,
    required this.isRevealed,
    required this.userJawaban,
    required this.isCorrect,
    required this.onBenar,
    required this.onSalah,
  });

  final String teks;
  final bool isRevealed;
  final bool? userJawaban; // true = Benar, false = Salah, null = blm jawab
  final bool isCorrect;
  final VoidCallback onBenar;
  final VoidCallback onSalah;

  @override
  Widget build(BuildContext context) {
    Color getBorderColor() {
      if (!isRevealed) return userJawaban != null ? AppColors.secondary : AppColors.outlineVariant;
      if (userJawaban == isCorrect) return AppColors.success;
      return AppColors.error;
    }
    
    Color getBgColor() {
      if (!isRevealed) return userJawaban != null ? AppColors.secondary.withAlpha(10) : AppColors.surface;
      if (userJawaban == isCorrect) return AppColors.success.withAlpha(20);
      return AppColors.error.withAlpha(20);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: getBgColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: getBorderColor(), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            teks,
            style: AppTypography.bodyLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PernyataanButton(
                  label: 'Benar',
                  isSelected: userJawaban == true,
                  isRevealed: isRevealed,
                  isCorrect: isCorrect == true,
                  onTap: onBenar,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PernyataanButton(
                  label: 'Salah',
                  isSelected: userJawaban == false,
                  isRevealed: isRevealed,
                  isCorrect: isCorrect == false,
                  onTap: onSalah,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _PernyataanButton extends StatelessWidget {
  const _PernyataanButton({
    required this.label,
    required this.isSelected,
    required this.isRevealed,
    required this.isCorrect,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isRevealed;
  final bool isCorrect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.surfaceVariant;
    Color textColor = AppColors.textSecondary;
    
    if (!isRevealed) {
      if (isSelected) {
        color = AppColors.primary;
        textColor = Colors.white;
      }
    } else {
      if (isSelected && isCorrect) {
        color = AppColors.success;
        textColor = Colors.white;
      } else if (isSelected && !isCorrect) {
        color = AppColors.error;
        textColor = Colors.white;
      } else if (!isSelected && isCorrect) {
        color = AppColors.success.withAlpha(50);
        textColor = AppColors.success;
      }
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.labelLarge.copyWith(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
