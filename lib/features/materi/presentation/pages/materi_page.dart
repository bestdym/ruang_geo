import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../home/presentation/widgets/home_widgets.dart';

class MateriPage extends StatelessWidget {
  const MateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: Builder(
        builder: (context) => SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            children: [
              HomeHeader(
                onMenuTap: () => Scaffold.of(context).openDrawer(),
              title: 'Materi',
              icon: Icons.menu_book_rounded,
            ),
            const SizedBox(height: AppConstants.spacingLG),
            _buildMenuCard(
            context,
            title: 'Bangun Datar',
            subtitle: 'Pelajari berbagai bentuk dua dimensi',
            icon: Icons.category_rounded,
            color: AppColors.primary,
            route: AppConstants.routeBangunDatar,
          ),
          const SizedBox(height: AppConstants.spacingMD),
          _buildMenuCard(
            context,
            title: 'Bangun Ruang',
            subtitle: 'Pelajari berbagai bentuk tiga dimensi',
            icon: Icons.view_in_ar_rounded,
            color: AppColors.secondary,
            route: AppConstants.routeBangunRuang,
          ),
        ],
      ),
      ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(AppConstants.radiusLG),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        decoration: BoxDecoration(
          color: color.withAlpha(25), // equivalent to withOpacity(0.1) roughly
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          border: Border.all(color: color.withAlpha(75), width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMD),
              decoration: BoxDecoration(
                color: color.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: AppConstants.iconLG),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXS),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color),
          ],
        ),
      ),
    );
  }
}
