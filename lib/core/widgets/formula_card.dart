import 'package:flutter/material.dart';
import 'package:ruang_geo/core/theme/theme.dart';

/// Komponen Card Rumus
/// 
/// Contoh:
/// ```dart
/// FormulaCard(
///   title: 'Volume',
///   formula: 'V = s × s × s',
///   bgColor: AppColors.primaryContainer,
///   textColor: AppColors.primary,
/// )
/// ```
class FormulaCard extends StatelessWidget {
  const FormulaCard({
    super.key,
    required this.title,
    required this.formula,
    required this.bgColor,
    required this.textColor,
  });

  final String title;
  final String formula;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.functions_rounded, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Rumus $title',
                style: AppTypography.titleMedium.copyWith(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: textColor.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: SelectableText(
                formula,
                style: AppTypography.headlineMedium.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textPrimary,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
