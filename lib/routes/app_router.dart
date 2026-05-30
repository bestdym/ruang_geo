import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/core.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/bangun_ruang/presentation/pages/bangun_ruang_page.dart';
import '../features/bangun_ruang/presentation/pages/bangun_ruang_detail_page.dart';
import '../features/bangun_ruang/presentation/pages/model_viewer_screen.dart';
import '../features/bangun_datar/presentation/pages/bangun_datar_page.dart';
import '../features/bangun_datar/presentation/pages/bangun_datar_detail_page.dart';
import '../features/ar/presentation/pages/ar_page.dart';
import '../features/ar/presentation/pages/ar_view_page.dart';
import '../features/kuis/presentation/pages/kuis_page.dart';
import '../features/kuis/presentation/pages/kuis_play_page.dart';
import '../features/kuis/presentation/pages/kuis_hasil_page.dart';
// ─── Placeholder pages untuk shell bottom nav ─────────────────────────────────

class _PetunjukPage extends StatelessWidget {
  const _PetunjukPage();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Petunjuk')),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.menu_book_rounded,
                size: 64, color: AppColors.secondary),
            const SizedBox(height: 16),
            Text('Petunjuk Penggunaan', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Text('Segera hadir!', style: AppTypography.bodyMedium),
          ]),
        ),
      );
}

class _ProfilPage extends StatelessWidget {
  const _ProfilPage();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Profil')),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded,
                  size: 44, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text('Profil Pengguna', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Text('Segera hadir!', style: AppTypography.bodyMedium),
          ]),
        ),
      );
}

class _PencapaianPage extends StatelessWidget {
  const _PencapaianPage();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Pencapaian')),
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

class _PengaturanPage extends StatelessWidget {
  const _PengaturanPage();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Pengaturan')),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.settings_rounded,
                size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text('Pengaturan', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Text('Segera hadir!', style: AppTypography.bodyMedium),
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
final GoRouter appRouter = GoRouter(
  initialLocation: AppConstants.routeHome,
  debugLogDiagnostics: false,
  routes: [
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

        // 1: Petunjuk
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/petunjuk',
            name: 'petunjuk',
            builder: (context, state) => const _PetunjukPage(),
          ),
        ]),

        // 2: Profil
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/profil',
            name: 'profil',
            builder: (context, state) => const _ProfilPage(),
          ),
        ]),

        // 3: Pencapaian
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/pencapaian',
            name: 'pencapaian',
            builder: (context, state) => const _PencapaianPage(),
          ),
        ]),

        // 4: Pengaturan
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppConstants.routeSettings,
            name: 'pengaturan',
            builder: (context, state) => const _PengaturanPage(),
          ),
        ]),
      ],
    ),

    // ─── Feature Pages (Full-screen, di luar shell) ──────────────────────────
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

    GoRoute(
      path: AppConstants.routeAR,
      name: 'ar',
      pageBuilder: (context, state) => _fadePageBuilder(
        state,
        const ArPage(),
      ),
      routes: [
        GoRoute(
          path: ':shapeId',
          name: 'ar-view',
          pageBuilder: (context, state) => _fadePageBuilder(
            state,
            ArViewPage(shapeId: state.pathParameters['shapeId']!),
          ),
        ),
      ],
    ),

    GoRoute(
      path: AppConstants.routeKuis,
      name: 'kuis',
      pageBuilder: (context, state) => _slidePageBuilder(
        state,
        const KuisPage(),
      ),
      routes: [
        GoRoute(
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
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF6C63FF),
      unselectedItemColor: const Color(0xFF9E9E9E),
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 11,
      ),
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          activeIcon: Icon(Icons.menu_book),
          label: 'Petunjuk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events_outlined),
          activeIcon: Icon(Icons.emoji_events),
          label: 'Pencapaian',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Pengaturan',
        ),
      ],
    );
  }
}
