import 'package:flutter/material.dart';

/// Palet warna utama aplikasi Ruang-Geo
///
/// Menggunakan skema warna yang cerah dan edukatif:
/// - Ungu (#6C63FF) sebagai warna primer
/// - Hijau (#2DCB82) sebagai warna sukses/alam
/// - Oranye (#FF7043) sebagai warna aksen/energik
/// - Biru muda (#4FC3F7) sebagai warna sekunder/tenang
abstract class AppColors {
  // ─── Primary - Ungu ─────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF3D35CC);
  static const Color primaryContainer = Color(0xFFEDE9FF);

  // ─── Secondary - Biru Muda ───────────────────────────────────────────────────
  static const Color secondary = Color(0xFF4FC3F7);
  static const Color secondaryLight = Color(0xFF8FF6FF);
  static const Color secondaryDark = Color(0xFF0093C4);
  static const Color secondaryContainer = Color(0xFFE1F5FE);

  // ─── Success - Hijau ─────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2DCB82);
  static const Color successLight = Color(0xFF6DFEB3);
  static const Color successDark = Color(0xFF009854);
  static const Color successContainer = Color(0xFFDFF7EC);

  // ─── Accent - Oranye ─────────────────────────────────────────────────────────
  static const Color accent = Color(0xFFFF7043);
  static const Color accentLight = Color(0xFFFF9F72);
  static const Color accentDark = Color(0xFFC63F17);
  static const Color accentContainer = Color(0xFFFFEBE6);

  // ─── Warning - Kuning ────────────────────────────────────────────────────────
  static const Color warning = Color(0xFFFFD93D);
  static const Color warningLight = Color(0xFFFFE97A);
  static const Color warningDark = Color(0xFFC8A500);
  static const Color warningContainer = Color(0xFFFFF8E1);

  // ─── Error ───────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFF7070);
  static const Color errorDark = Color(0xFFB60000);
  static const Color errorContainer = Color(0xFFFFEBEB);

  // ─── Neutral / Surface ───────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8F7FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F2FF);
  static const Color outline = Color(0xFFD0CEF5);
  static const Color outlineVariant = Color(0xFFEBEAFF);

  // ─── Text ────────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1741);
  static const Color textSecondary = Color(0xFF5A5680);
  static const Color textHint = Color(0xFFA09DC0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ─── Dark Mode ───────────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F0D1E);
  static const Color darkSurface = Color(0xFF1A1735);
  static const Color darkSurfaceVariant = Color(0xFF252247);
  static const Color darkOutline = Color(0xFF3D3A6B);
  static const Color darkTextPrimary = Color(0xFFF0EEFF);
  static const Color darkTextSecondary = Color(0xFFB8B5E0);

  // ─── Gradient Presets ────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
  );

  static const LinearGradient bangunRuangGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
  );

  static const LinearGradient bangunDatarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF26C6DA), Color(0xFF00838F)],
  );

  static const LinearGradient arGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7043), Color(0xFFD84315)],
  );

  static const LinearGradient kuisGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, accentLight],
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [Color(0x4D6C63FF), Color(0x006C63FF)],
    radius: 0.8,
  );
}
