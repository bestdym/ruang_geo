import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import '../widgets/widgets.dart';

/// Data menu utama Home Screen
final List<_MenuData> _menus = [
  _MenuData(
    title: 'Bangun Ruang',
    description: 'Kubus, balok, tabung, kerucut & bola',
    icon: Icons.view_in_ar_rounded,
    gradient: AppColors.bangunRuangGradient,
    route: '/bangun-ruang',
    heroTag: 'hero-bangun-ruang',
  ),
  _MenuData(
    title: 'Bangun Datar',
    description: 'Persegi, segitiga, lingkaran & lebih',
    icon: Icons.hexagon_outlined,
    gradient: AppColors.bangunDatarGradient,
    route: '/bangun-datar',
    heroTag: 'hero-bangun-datar',
  ),
  _MenuData(
    title: 'AR Kamera',
    description: 'Lihat bangun geometri nyata di sekitarmu',
    icon: Icons.center_focus_strong_rounded,
    gradient: AppColors.arGradient,
    route: '/ar',
    badge: 'AR',
    heroTag: 'hero-ar',
  ),
  _MenuData(
    title: 'Kuis & Latihan',
    description: 'Uji pemahaman dengan soal interaktif',
    icon: Icons.sports_esports_rounded,
    gradient: AppColors.kuisGradient,
    route: '/kuis',
    heroTag: 'hero-kuis',
  ),
];

/// Home Screen utama aplikasi Ruang-Geo
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Mulai animasi setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const _DrawerMenu(),
      body: Stack(
        children: [
          // ─── Background dekorasi ───────────────────────────────────────────
          const Positioned.fill(child: FloatingDecorations()),

          // ─── Konten utama ──────────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Header
                          HomeHeader(
                            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                            onProfileTap: () => context.push('/profil'),
                          ),

                          const SizedBox(height: 20),

                          // Hero banner
                          const HomeHeroBanner(),

                          const SizedBox(height: 28),

                          // Section label
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Menu Belajar',
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Menu cards dengan staggered animation
                          ..._buildMenuCards(context),

                          const SizedBox(height: 20),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Buat daftar MenuCard dengan staggered delay animation
  List<Widget> _buildMenuCards(BuildContext context) {
    return List.generate(_menus.length, (index) {
      final menu = _menus[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: _StaggeredCard(
          index: index,
          parentController: _fadeController,
          child: MenuCard(
            title: menu.title,
            description: menu.description,
            icon: menu.icon,
            gradient: menu.gradient,
            badge: menu.badge,
            heroTag: menu.heroTag,
            onTap: () => context.push(menu.route),
          ),
        ),
      );
    });
  }
}

/// Wrapper untuk animasi staggered pada tiap card
class _StaggeredCard extends StatelessWidget {
  const _StaggeredCard({
    required this.index,
    required this.parentController,
    required this.child,
  });

  final int index;
  final AnimationController parentController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Setiap card muncul dengan delay 80ms per index
    final begin = (index * 0.1).clamp(0.0, 0.6);
    final end = (begin + 0.5).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: parentController,
      curve: Interval(begin, end, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

/// Bottom sheet drawer menu sederhana
class _DrawerMenu extends StatelessWidget {
  const _DrawerMenu();

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

/// Internal data class untuk menu
class _MenuData {
  const _MenuData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.route,
    this.badge,
    this.heroTag,
  });

  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;
  final String route;
  final String? badge;
  final String? heroTag;
}
