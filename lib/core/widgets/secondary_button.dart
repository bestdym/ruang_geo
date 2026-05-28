import 'package:flutter/material.dart';
import 'package:ruang_geo/core/theme/theme.dart';

/// Komponen Secondary Button Outline
/// 
/// Contoh:
/// ```dart
/// SecondaryButton(
///   label: 'Batal',
///   onPressed: () {},
///   icon: Icons.cancel, // opsional
/// )
/// ```
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.color = AppColors.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: onPressed != null ? color : AppColors.outlineVariant),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: onPressed != null ? color : AppColors.textHint),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: AppTypography.titleSmall.copyWith(
              color: onPressed != null ? color : AppColors.textHint,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
