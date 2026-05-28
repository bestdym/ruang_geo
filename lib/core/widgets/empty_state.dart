import 'package:flutter/material.dart';
import 'package:ruang_geo/core/theme/theme.dart';
import 'package:ruang_geo/core/widgets/primary_button.dart';

/// Komponen Empty State
/// 
/// Contoh:
/// ```dart
/// EmptyState(
///   icon: Icons.inbox_rounded,
///   title: 'Data Kosong',
///   message: 'Belum ada data yang tersedia.',
///   buttonLabel: 'Refresh',
///   onButtonPressed: () {},
/// )
/// ```
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonLabel,
    this.onButtonPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.outlineVariant.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: AppColors.textHint),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 32),
              PrimaryButton(
                label: buttonLabel!,
                onPressed: onButtonPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
