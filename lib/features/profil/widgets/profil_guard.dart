import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/core.dart';
import '../../../core/services/supabase_service.dart';
import '../services/profil_service.dart';

/// Membungkus widget child dan memblokir akses jika profil belum lengkap
class ProfilGuard extends StatefulWidget {
  const ProfilGuard({super.key, required this.child});

  final Widget child;

  @override
  State<ProfilGuard> createState() => _ProfilGuardState();
}

class _ProfilGuardState extends State<ProfilGuard> {
  final _profilService = ProfilService();
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkProfil();
  }

  Future<void> _checkProfil() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      if (!mounted) return;
      setState(() {
        _isChecking = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLoginBottomSheet();
      });
      return;
    }

    final complete = await _profilService.isProfileComplete(userId);
    if (!mounted) return;
    setState(() {
      _isChecking = false;
    });

    // Jika profil belum lengkap, tampilkan BottomSheet saat pertama kali
    if (!complete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showProfilBottomSheet();
      });
    }
  }

  void _showLoginBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'Akses Terbatas',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Anda harus masuk atau mendaftar untuk mengakses fitur ini (seperti kuis dan pencapaian).',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/login');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Masuk / Daftar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/home'); // Kembali ke home
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                foregroundColor: AppColors.textSecondary,
              ),
              child: const Text('Nanti saja, kembali ke Beranda'),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }

  void _showProfilBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.warning.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline_rounded, size: 40, color: AppColors.warning),
            ),
            const SizedBox(height: 20),
            Text(
              'Lengkapi Profil Dulu!',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Lengkapi profil kamu untuk mengakses fitur ini. Ini hanya perlu dilakukan sekali!',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/lengkapi-profil');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Lengkapi Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go(AppConstants.routeHome);
              },
              child: Text(
                'Kembali ke Beranda',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // Jika profil lengkap, tampilkan child langsung
    return widget.child;
  }
}
