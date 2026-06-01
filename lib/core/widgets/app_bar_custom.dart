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
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.centerTitle = true,
  });

  final String title;
  final VoidCallback? onBack;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.background,
      elevation: 0,
      centerTitle: centerTitle,
      leadingWidth: 64, // Beri sedikit ruang agar padding di leading pas
      leading: Center(
        child: _AppBarIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: onBack ?? () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      title: Text(
        title,
        style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      ),
      actions: actions ?? [
        if (actionIcon != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _AppBarIconButton(
                icon: actionIcon!,
                onTap: onActionPressed ?? () {},
              ),
            ),
          ),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceVariant,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
