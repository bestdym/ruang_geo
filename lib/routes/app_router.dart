import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/core.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/bangun_ruang/presentation/pages/bangun_ruang_page.dart';
import '../features/bangun_ruang/presentation/pages/bangun_ruang_detail_page.dart';
import '../features/bangun_ruang/presentation/pages/model_viewer_screen.dart';
import '../features/bangun_ruang/presentation/pages/vr_mode_screen.dart';
import '../features/bangun_datar/presentation/pages/bangun_datar_page.dart';
import '../features/bangun_datar/presentation/pages/bangun_datar_detail_page.dart';
import '../features/ar/presentation/pages/ar_page.dart';
import '../features/ar/presentation/pages/ar_view_page.dart';
import '../features/kuis/presentation/pages/kuis_page.dart';
import '../features/kuis/presentation/pages/kuis_play_page.dart';
import '../features/kuis/presentation/pages/kuis_hasil_page.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';

import '../features/profil/widgets/profil_guard.dart';
import '../features/pencapaian/screens/pencapaian_screen.dart';
import '../features/auth/services/auth_notifier.dart';
import '../features/petunjuk/screens/petunjuk_screen.dart';
import '../core/services/supabase_service.dart';
import '../features/about/presentation/pages/about_page.dart';
import '../features/profil/screens/profil_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/materi/presentation/pages/materi_page.dart';
// ─── Placeholder pages untuk shell bottom nav ─────────────────────────────────

class _PencapaianPage extends StatelessWidget {
  const _PencapaianPage();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AppBarCustom(title: 'Pencapaian'),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.emoji_events_rounded,
                size: 64, color: AppColors.warning),
            const SizedBox(height: 16),
            Text('Pencapaian Kamu', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Text('Kumpulkan badge dengan belajar!',
                style: AppTypography.bodyMedium),
          ]),
        ),
      );
}



// ─── GoRouter Configuration ───────────────────────────────────────────────────

/// Konfigurasi navigasi utama Ruang-Geo
///
/// Struktur:
/// - / → Splash (redirect ke /home)
/// - Shell (bottom nav: Home | Petunjuk | Profil | Pencapaian | Pengaturan):
///   - /home
///   - /petunjuk
///   - /profil
///   - /pencapaian
///   - /pengaturan
/// - Detail pages (di luar shell, full-screen):
///   - /bangun-ruang
///   - /bangun-ruang/:id
///   - /bangun-datar
///   - /bangun-datar/:id
///   - /ar
///   - /ar/:shapeId
///   - /kuis
///   - /kuis/:kategori
///   - /kuis/:kategori/hasil
final _authNotifier = AuthNotifier();

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppConstants.routeHome,
  debugLogDiagnostics: false,
  refreshListenable: _authNotifier,
  redirect: (context, state) {
    final session = supabase.auth.currentSession;
    final isLoggedIn = session != null;
    final path = state.uri.path;
    final isGoingToAuth = path == '/login' || path == '/register';

    if (isLoggedIn && (isGoingToAuth || path == AppConstants.routeSplash)) {
      return AppConstants.routeHome;
    }
    
    if (!isLoggedIn && path == AppConstants.routeSplash) {
      return AppConstants.routeHome;
    }
    
    return null;
  },
  routes: [
    // ─── Auth Routes ────────────────────────────────────────────────────────
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) => _fadePageBuilder(state, const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      pageBuilder: (context, state) => _slidePageBuilder(state, const RegisterScreen()),
    ),


    // ─── Splash redirect ────────────────────────────────────────────────────
    GoRoute(
      path: AppConstants.routeSplash,
      redirect: (_, __) => AppConstants.routeHome,
    ),

    // ─── Shell Route: Bottom Navigation ─────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _AppShell(navigationShell: navigationShell);
      },
      branches: [
        // 0: Home
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppConstants.routeHome,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
        ]),

        // 1: Materi
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/materi',
            name: 'materi',
            builder: (context, state) => const MateriPage(),
          ),
        ]),

        // 2: AR
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppConstants.routeAR,
            name: 'ar',
            builder: (context, state) => const ArPage(),
            routes: [
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: ':shapeId',
                name: 'ar-view',
                pageBuilder: (context, state) => _fadePageBuilder(
                  state,
                  ArViewPage(shapeId: state.pathParameters['shapeId']!),
                ),
              ),
            ],
          ),
        ]),

        // 3: Kuis
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppConstants.routeKuis,
            name: 'kuis',
            builder: (context, state) => const ProfilGuard(child: KuisPage()),
            routes: [
              GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: ':kategori',
                name: 'kuis-play',
                builder: (context, state) =>
                    KuisPlayPage(kategori: state.pathParameters['kategori']!),
                routes: [
                  GoRoute(
                    path: 'hasil',
                    name: 'kuis-hasil',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>? ?? {};
                      return KuisHasilPage(
                        kategori: state.pathParameters['kategori']!,
                        score: extra['score'] as int? ?? 0,
                        total: extra['total'] as int? ?? 0,
                        poin: extra['poin'] as int? ?? 0,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ]),

        // 4: Profil
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/profil',
            name: 'profil',
            builder: (context, state) => const ProfilGuard(child: ProfilScreen()),
            routes: [
              GoRoute(
                path: 'pencapaian',
                name: 'pencapaian',
                pageBuilder: (context, state) => _slidePageBuilder(
                  state,
                  const ProfilGuard(child: PencapaianScreen()),
                ),
              ),
            ],
          ),
        ]),
      ],
    ),

    // ─── Feature Pages (Full-screen, di luar shell) ──────────────────────────
    GoRoute(
      path: AppConstants.routeAbout,
      name: 'about',
      pageBuilder: (context, state) => _slidePageBuilder(
        state,
        const AboutPage(),
      ),
    ),

    GoRoute(
      path: AppConstants.routeSettings,
      name: 'pengaturan',
      pageBuilder: (context, state) => _slidePageBuilder(
        state,
        const SettingsScreen(),
      ),
    ),

    GoRoute(
      path: '/petunjuk',
      name: 'petunjuk',
      pageBuilder: (context, state) => _slidePageBuilder(
        state,
        const PetunjukScreen(),
      ),
    ),

    GoRoute(
      path: '/bangun-ruang',
      name: 'bangun-ruang',
      pageBuilder: (context, state) => _slidePageBuilder(
        state,
        const BangunRuangPage(),
      ),
      routes: [
        GoRoute(
          path: ':id',
          name: 'bangun-ruang-detail',
          pageBuilder: (context, state) => _slidePageBuilder(
            state,
            BangunRuangDetailPage(
                bangunId: state.pathParameters['id']!),
          ),
          routes: [
            GoRoute(
              path: 'model',
              name: 'bangun-ruang-model',
              pageBuilder: (context, state) => _slidePageBuilder(
                state,
                ModelViewerScreen(
                    bangunId: state.pathParameters['id']!),
              ),
            ),
            GoRoute(
              path: 'vr',
              name: 'bangun-ruang-vr',
              pageBuilder: (context, state) => _fadePageBuilder(
                state,
                VrModeScreen(
                    bangunId: state.pathParameters['id']!),
              ),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/bangun-datar',
      name: 'bangun-datar',
      pageBuilder: (context, state) => _slidePageBuilder(
        state,
        const BangunDatarPage(),
      ),
      routes: [
        GoRoute(
          path: ':id',
          name: 'bangun-datar-detail',
          pageBuilder: (context, state) => _slidePageBuilder(
            state,
            BangunDatarDetailPage(
                bangunId: state.pathParameters['id']!),
          ),
        ),
      ],
    ),
  ],

  // ─── Error page ─────────────────────────────────────────────────────────────
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppColors.background,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, color: AppColors.error, size: 64),
            const SizedBox(height: 16),
            Text('Halaman tidak ditemukan',
                style: AppTypography.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              state.error?.message ?? 'Route tidak valid',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go(AppConstants.routeHome),
              icon: const Icon(Icons.home_rounded),
              label: const Text('Kembali ke Home'),
            ),
          ],
        ),
      ),
    ),
  ),
);

// ─── Page transition helpers ──────────────────────────────────────────────────

CustomTransitionPage<void> _slidePageBuilder(
    GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 280),
  );
}

CustomTransitionPage<void> _fadePageBuilder(
    GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}

// ─── App Shell (Bottom Navigation) ───────────────────────────────────────────

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 22),
        child: Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.background,
          ),
          padding: const EdgeInsets.all(8),
          child: FloatingActionButton(
            onPressed: () => navigationShell.goBranch(
              2,
              initialLocation: 2 == navigationShell.currentIndex,
            ),
            backgroundColor: AppColors.primary,
            elevation: 0,
            highlightElevation: 0,
            shape: const CircleBorder(),
            child: const Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 34),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: _BottomNav(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Materi',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 72),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.quiz_rounded,
                  label: 'Kuis',
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profil',
                  isSelected: currentIndex == 4,
                  onTap: () => onTap(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.isSelected;
    final bool isEnlarged = isActive || _isHovered;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) {
          setState(() => _isHovered = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isHovered = false),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          transform: Matrix4.identity()
            ..translate(0.0, isEnlarged ? -5.0 : 0.0)
            ..scale(isEnlarged ? 1.15 : 1.0),
          transformAlignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(
            horizontal: isActive ? 18 : 12,
            vertical: isActive ? 10 : 8,
          ),
          decoration: BoxDecoration(
            color: isActive 
                ? AppColors.primary.withAlpha(25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                transform: Matrix4.identity()..scale(isEnlarged ? 1.15 : 1.0),
                transformAlignment: Alignment.center,
                child: Icon(
                  widget.icon,
                  color: isActive ? AppColors.primary : AppColors.textHint,
                  size: 24,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                style: AppTypography.labelSmall.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textHint,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  fontSize: isEnlarged ? 13 : 11,
                ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
