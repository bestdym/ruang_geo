import 'package:flutter/material.dart';

/// Ekstensi utility untuk BuildContext
extension ContextExtension on BuildContext {
  // ─── Theme ───────────────────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // ─── Screen Size ─────────────────────────────────────────────────────────────
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  // ─── Responsive Breakpoints ───────────────────────────────────────────────────
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  bool get isDesktop => screenWidth >= 900;

  // ─── Navigation ──────────────────────────────────────────────────────────────
  NavigatorState get navigator => Navigator.of(this);

  // ─── Snackbar ────────────────────────────────────────────────────────────────
  void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : null,
        duration: duration,
      ),
    );
  }
}

/// Ekstensi untuk String
extension StringExtension on String {
  /// Capitalize first letter
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Convert to title case
  String get toTitleCase => split(' ')
      .map((word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
      .join(' ');

  /// Check if string is valid email
  bool get isValidEmail =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(this);

  /// Truncate string with ellipsis
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}...';
}

/// Ekstensi untuk num (int & double)
extension NumExtension on num {
  /// Format angka dengan pemisah ribuan Indonesia (1.000,00)
  String get formatId {
    final parts = toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return '$intPart,${parts[1]}';
  }

  /// Nilai dalam persen (0-100)
  String get toPercent => '${(this * 100).toStringAsFixed(0)}%';

  SizedBox get heightBox => SizedBox(height: toDouble());
  SizedBox get widthBox => SizedBox(width: toDouble());
}

/// Ekstensi untuk List
extension ListExtension<T> on List<T> {
  /// Chunk list menjadi sub-list berukuran [size]
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  /// Safe get dengan default value
  T? safeGet(int index) => index >= 0 && index < length ? this[index] : null;
}

/// Ekstensi untuk DateTime
extension DateTimeExtension on DateTime {
  /// Format tanggal Indonesia: "28 Mei 2026"
  String get formatId {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '$day ${months[month]} $year';
  }

  bool get isToday {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }
}
