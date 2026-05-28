import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Sistem tipografi aplikasi Ruang-Geo
///
/// Menggunakan font Poppins via google_fonts package.
/// Tidak perlu file .ttf lokal — didownload otomatis saat debug,
/// dan di-bundle saat release via google_fonts.
abstract class AppTypography {
  static const String fontFamily = 'Poppins';

  // ─── Helper: base TextStyle dengan Poppins ────────────────────────────────
  static TextStyle _poppins({
    required double fontSize,
    required FontWeight fontWeight,
    double letterSpacing = 0,
    double height = 1.4,
    Color color = AppColors.textPrimary,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
      fontStyle: fontStyle,
    );
  }

  // ─── Display ─────────────────────────────────────────────────────────────────
  static TextStyle get displayLarge => _poppins(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.25,
        height: 1.12,
      );

  static TextStyle get displayMedium => _poppins(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        height: 1.16,
      );

  static TextStyle get displaySmall => _poppins(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.22,
      );

  // ─── Headline ────────────────────────────────────────────────────────────────
  static TextStyle get headlineLarge => _poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get headlineMedium => _poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
      );

  static TextStyle get headlineSmall => _poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
      );

  // ─── Title ───────────────────────────────────────────────────────────────────
  static TextStyle get titleLarge => _poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
      );

  static TextStyle get titleMedium => _poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle get titleSmall => _poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // ─── Body ────────────────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => _poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyMedium => _poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => _poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        color: AppColors.textHint,
      );

  // ─── Label ───────────────────────────────────────────────────────────────────
  static TextStyle get labelLarge => _poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get labelMedium => _poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelSmall => _poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
        color: AppColors.textHint,
      );

  // ─── Custom App-Specific Styles ───────────────────────────────────────────────
  /// Judul hero section di home
  static TextStyle get heroTitle => _poppins(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.2,
        color: AppColors.textOnPrimary,
      );

  /// Nama bangun pada card
  static TextStyle get cardTitle => _poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  /// Rumus matematika
  static TextStyle get formula => _poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        height: 1.6,
        color: AppColors.primary,
        fontStyle: FontStyle.italic,
      );

  /// Badge / chip kategori
  static TextStyle get badge => _poppins(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        height: 1.4,
        color: AppColors.textOnPrimary,
      );

  /// Skor / angka di kuis
  static TextStyle get scoreDisplay => _poppins(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        height: 1.1,
        color: AppColors.primary,
      );

  // ─── TextTheme untuk ThemeData ────────────────────────────────────────────────
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
