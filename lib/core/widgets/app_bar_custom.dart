import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/theme/theme.dart';

/// Komponen AppBar kustom yang reusable
/// 
/// Contoh:
/// ```dart
/// Scaffold(
///   appBar: AppBarCustom(
///     title: 'Judul Halaman',
///     onBack: () => context.pop(),
///     actionIcon: Icons.favorite_border,
///     onActionPressed: () {},
///   ),
/// )
/// ```
class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({
    super.key,
    required this.title,
    this.onBack,
    this.actionIcon,
    this.onActionPressed,
    this.centerTitle = true,
  });

  final String title;
  final VoidCallback? onBack;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: centerTitle,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
        onPressed: onBack ?? () {
          if (context.canPop()) context.pop();
        },
      ),
      title: Text(
        title,
        style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      actions: [
        if (actionIcon != null)
          IconButton(
            icon: Icon(actionIcon, color: AppColors.textPrimary),
            onPressed: onActionPressed,
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
