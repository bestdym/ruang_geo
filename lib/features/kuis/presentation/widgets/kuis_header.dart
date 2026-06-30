import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

class KuisHeader extends StatelessWidget {
  const KuisHeader({
    super.key,
    required this.kategori,
    required this.timeLeft,
  });

  final String kategori;
  final int timeLeft;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              kategori.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: timeLeft <= 10 ? AppColors.error : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '00:${timeLeft.toString().padLeft(2, '0')}',
                style: AppTypography.labelMedium.copyWith(
                  color: timeLeft <= 10 ? AppColors.error : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
