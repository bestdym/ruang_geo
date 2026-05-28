import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'routes/app_router.dart';
import 'core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock ke portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar transparan
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const RuangGeoApp());
}

class RuangGeoApp extends StatelessWidget {
  const RuangGeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // ─── App Info ──────────────────────────────────────────────────────────
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // ─── Theme ────────────────────────────────────────────────────────────
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // ─── Router ───────────────────────────────────────────────────────────
      routerConfig: appRouter,

      // ─── Lokalisasi ───────────────────────────────────────────────────────
      locale: const Locale('id', 'ID'),
    );
  }
}
