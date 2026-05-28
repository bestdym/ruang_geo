import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/core.dart';

// ─── Feature Imports ──────────────────────────────────────────────────────────
// Nanti import halaman dari masing-masing feature setelah dibuat
// import '../features/home/presentation/pages/home_page.dart';
// import '../features/bangun_ruang/presentation/pages/bangun_ruang_page.dart';
// import '../features/bangun_datar/presentation/pages/bangun_datar_page.dart';
// import '../features/ar/presentation/pages/ar_page.dart';
// import '../features/kuis/presentation/pages/kuis_page.dart';

// ─── Placeholder Pages (hapus setelah fitur dibuat) ───────────────────────────
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title, required this.color});
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(Icons.construction_rounded,
                  color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTypography.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Halaman sedang dikembangkan',
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Konfigurasi navigasi GoRouter untuk Ruang-Geo
///
/// Menggunakan shell route untuk bottom navigation bar yang persisten.
/// Struktur:
/// - / → Splash
/// - /onboarding → Onboarding
/// - Shell (bottom nav):
///   - /home → Home
///   - /bangun-ruang → Bangun Ruang List
///   - /bangun-datar → Bangun Datar List
///   - /ar → AR Home
///   - /kuis → Kuis Menu
/// - /bangun-ruang/:id → Detail Bangun Ruang
/// - /bangun-datar/:id → Detail Bangun Datar
/// - /ar/:shapeId → AR View
/// - /kuis/:kategori → Kuis Bermain
/// - /kuis/:kategori/hasil → Hasil Kuis
final GoRouter appRouter = GoRouter(
  initialLocation: AppConstants.routeSplash,
  debugLogDiagnostics: true,
  routes: [
    // ─── Splash ─────────────────────────────────────────────────────────────
    GoRoute(
      path: AppConstants.routeSplash,
      name: 'splash',
      builder: (context, state) => const _PlaceholderPage(
        title: 'Splash Screen',
        color: AppColors.primary,
      ),
    ),

    // ─── Onboarding ─────────────────────────────────────────────────────────
    GoRoute(
      path: AppConstants.routeOnboarding,
      name: 'onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const _PlaceholderPage(
          title: 'Onboarding',
          color: AppColors.secondary,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    // ─── Shell Route (Bottom Navigation) ────────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _MainShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppConstants.routeHome,
              name: 'home',
              builder: (context, state) => const _PlaceholderPage(
                title: 'Home',
                color: AppColors.primary,
              ),
            ),
          ],
        ),

        // Branch 1: Bangun Ruang
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bangun-ruang',
              name: 'bangun-ruang',
              builder: (context, state) => const _PlaceholderPage(
                title: 'Bangun Ruang',
                color: AppColors.primary,
              ),
            ),
          ],
        ),

        // Branch 2: Bangun Datar
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bangun-datar',
              name: 'bangun-datar',
              builder: (context, state) => const _PlaceholderPage(
                title: 'Bangun Datar',
                color: AppColors.success,
              ),
            ),
          ],
        ),

        // Branch 3: AR
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppConstants.routeAR,
              name: 'ar',
              builder: (context, state) => const _PlaceholderPage(
                title: 'Augmented Reality',
                color: AppColors.accent,
              ),
            ),
          ],
        ),

        // Branch 4: Kuis
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppConstants.routeKuis,
              name: 'kuis',
              builder: (context, state) => const _PlaceholderPage(
                title: 'Kuis',
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    ),

    // ─── Detail Pages (di luar shell) ───────────────────────────────────────
    GoRoute(
      path: AppConstants.routeBangunRuangDetail,
      name: 'bangun-ruang-detail',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return CustomTransitionPage(
          key: state.pageKey,
          child: _PlaceholderPage(
            title: 'Detail Bangun Ruang: $id',
            color: AppColors.primary,
          ),
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
        );
      },
    ),

    GoRoute(
      path: AppConstants.routeBangunDatarDetail,
      name: 'bangun-datar-detail',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return CustomTransitionPage(
          key: state.pageKey,
          child: _PlaceholderPage(
            title: 'Detail Bangun Datar: $id',
            color: AppColors.success,
          ),
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
        );
      },
    ),

    GoRoute(
      path: AppConstants.routeARView,
      name: 'ar-view',
      pageBuilder: (context, state) {
        final shapeId = state.pathParameters['shapeId']!;
        return CustomTransitionPage(
          key: state.pageKey,
          child: _PlaceholderPage(
            title: 'AR View: $shapeId',
            color: AppColors.accent,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),

    GoRoute(
      path: AppConstants.routeKuisPlay,
      name: 'kuis-play',
      builder: (context, state) {
        final kategori = state.pathParameters['kategori']!;
        return _PlaceholderPage(
          title: 'Kuis: $kategori',
          color: AppColors.warning,
        );
      },
      routes: [
        GoRoute(
          path: 'hasil',
          name: 'kuis-hasil',
          builder: (context, state) => const _PlaceholderPage(
            title: 'Hasil Kuis',
            color: AppColors.success,
          ),
        ),
      ],
    ),

    // ─── Settings ────────────────────────────────────────────────────────────
    GoRoute(
      path: AppConstants.routeSettings,
      name: 'settings',
      builder: (context, state) => const _PlaceholderPage(
        title: 'Pengaturan',
        color: AppColors.secondary,
      ),
    ),
  ],

  // ─── Error Handler ─────────────────────────────────────────────────────────
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppColors.background,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.map_outlined, color: AppColors.error, size: 64),
          const SizedBox(height: 16),
          Text('Halaman tidak ditemukan', style: AppTypography.headlineSmall),
          const SizedBox(height: 8),
          Text(
            state.error?.message ?? 'Route tidak valid',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => context.go(AppConstants.routeHome),
            child: const Text('Kembali ke Home'),
          ),
        ],
      ),
    ),
  ),
);

/// Shell widget dengan bottom navigation bar
class _MainShell extends StatelessWidget {
  const _MainShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            // Kembali ke initial route saat tab yang aktif di-tap lagi
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_in_ar_outlined),
            selectedIcon: Icon(Icons.view_in_ar_rounded),
            label: 'Bangun Ruang',
          ),
          NavigationDestination(
            icon: Icon(Icons.crop_square_outlined),
            selectedIcon: Icon(Icons.crop_square_rounded),
            label: 'Bangun Datar',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_outlined),
            selectedIcon: Icon(Icons.camera_rounded),
            label: 'AR',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz_rounded),
            label: 'Kuis',
          ),
        ],
      ),
    );
  }
}
