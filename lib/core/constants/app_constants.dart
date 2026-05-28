/// Konstanta aplikasi Ruang-Geo
///
/// Semua konstanta global yang digunakan di seluruh aplikasi.
abstract class AppConstants {
  // ─── App Info ────────────────────────────────────────────────────────────────
  static const String appName = 'Ruang-Geo';
  static const String appTagline = 'Belajar Geometri Lebih Seru dengan AR';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ─── Route Names ─────────────────────────────────────────────────────────────
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeHome = '/home';
  static const String routeBangunRuang = '/bangun-ruang';
  static const String routeBangunRuangDetail = '/bangun-ruang/:id';
  static const String routeBangunDatar = '/bangun-datar';
  static const String routeBangunDatarDetail = '/bangun-datar/:id';
  static const String routeAR = '/ar';
  static const String routeARView = '/ar/:shapeId';
  static const String routeKuis = '/kuis';
  static const String routeKuisPlay = '/kuis/:kategori';
  static const String routeKuisHasil = '/kuis/:kategori/hasil';
  static const String routeSettings = '/settings';
  static const String routeAbout = '/about';

  // ─── SharedPreferences Keys ───────────────────────────────────────────────────
  static const String prefThemeMode = 'pref_theme_mode';
  static const String prefOnboardingDone = 'pref_onboarding_done';
  static const String prefLanguage = 'pref_language';
  static const String prefHighScore = 'pref_high_score';
  static const String prefFavoritShapes = 'pref_favorit_shapes';

  // ─── Animasi Duration ─────────────────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animVerySlow = Duration(milliseconds: 800);
  static const Duration splashDuration = Duration(seconds: 2);

  // ─── Ukuran / Spacing ─────────────────────────────────────────────────────────
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 28.0;
  static const double radiusCircle = 999.0;

  static const double iconSM = 16.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 48.0;

  // ─── Kuis Config ─────────────────────────────────────────────────────────────
  static const int kuisTimePerSoal = 30; // detik
  static const int kuisTotalSoal = 10;
  static const int kuisSkipLimit = 3;
  static const double kuisPassScore = 60.0; // persen

  // ─── Kategori Bangun ─────────────────────────────────────────────────────────
  static const String kategoriRuang = 'bangun_ruang';
  static const String kategoriDatar = 'bangun_datar';
  static const String kategoriSemua = 'semua';

  // ─── Asset Paths ─────────────────────────────────────────────────────────────
  static const String assetImages = 'assets/images/';
  static const String assetIcons = 'assets/icons/';
  static const String assetAnimations = 'assets/animations/';
  static const String assetData = 'assets/data/';

  // ─── Animation File Names ─────────────────────────────────────────────────────
  static const String animSuccess = 'assets/animations/success.json';
  static const String animFailed = 'assets/animations/failed.json';
  static const String animLoading = 'assets/animations/loading.json';
  static const String animAR = 'assets/animations/ar_scan.json';
  static const String animEmpty = 'assets/animations/empty.json';
}
