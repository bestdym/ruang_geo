import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text('Menu', style: AppTypography.titleMedium),
            const SizedBox(height: 16),
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.info_outline_rounded,
              label: 'Tentang Aplikasi',
              onTap: () {
                Navigator.pop(context);
                context.push(AppConstants.routeAbout);
              },
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Pengaturan',
              onTap: () {
                Navigator.pop(context);
                context.push(AppConstants.routeSettings);
              },
            ),
            _DrawerItem(
              icon: Icons.help_outline_rounded,
              label: 'Bantuan',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: AppTypography.bodyMedium),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: AppColors.textHint),
      onTap: onTap,
    );
  }
}
