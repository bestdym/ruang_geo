import 'package:flutter/material.dart';
import 'package:ruang_geo/core/theme/theme.dart';

/// Komponen Loading Widget Branded
/// 
/// Contoh:
/// ```dart
/// LoadingWidget()
/// ```
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.message,
    this.color = AppColors.primary,
  });

  final String? message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: 4,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
