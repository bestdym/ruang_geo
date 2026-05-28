import 'package:flutter/material.dart';
import 'package:ruang_geo/core/theme/theme.dart';

/// Komponen TabBar Custom Style
/// 
/// Harus dibungkus dengan [DefaultTabController] atau
/// pass [TabController] ke dalamnya.
/// 
/// Contoh:
/// ```dart
/// TabBarCustom(
///   controller: _tabController,
///   tabs: ['Info', 'Rumus', 'Sifat', 'Soal'],
/// )
/// ```
class TabBarCustom extends StatelessWidget {
  const TabBarCustom({
    super.key,
    required this.tabs,
    this.controller,
  });

  final List<String> tabs;
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.primary,
      indicatorWeight: 3,
      labelStyle: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: AppTypography.titleSmall,
      tabs: tabs.map((t) => Tab(text: t)).toList(),
    );
  }
}
