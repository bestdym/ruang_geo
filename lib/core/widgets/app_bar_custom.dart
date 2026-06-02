import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/theme/theme.dart';

/// Komponen AppBar kustom yang reusable dengan gradient biru
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
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0)),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF4C8EF7),
                Color(0xFF2563EB),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      // Tombol Back
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _AppBarIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: onBack ?? () {
                            if (context.canPop()) context.pop();
                          },
                        ),
                      ),
                      // Title
                      Expanded(
                        child: centerTitle
                            ? Center(
                                child: Text(
                                  title,
                                  style: AppTypography.titleLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  title,
                                  style: AppTypography.titleLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                      // Actions
                      if (actions != null) ...actions!
                      else if (actionIcon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _AppBarIconButton(
                            icon: actionIcon!,
                            onTap: onActionPressed ?? () {},
                          ),
                        )
                      else
                        const SizedBox(width: 56), // placeholder biar title tetap center
                    ],
                  ),
                ),
                if (bottom != null) bottom!,
              ],
            ),
          ),
        ),
      ),
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
      color: Colors.white.withAlpha(40),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
