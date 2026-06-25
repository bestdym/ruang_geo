import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/core.dart';
import '../../auth/services/auth_service.dart';
import '../services/profil_service.dart';
import '../models/profile_model.dart';

import '../../home/presentation/widgets/home_widgets.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final _authService = AuthService();
  final _profilService = ProfilService();
  
  ProfileModel? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final profile = await _profilService.getProfile(user.id);
      if (mounted) {
        setState(() {
          _profile = profile;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.signOut();
      if (mounted) {
        context.go('/home');
      }
    }
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.secondary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: Builder(
        builder: (context) => SafeArea(
          child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _profile == null
                ? const Center(child: Text('Gagal memuat profil'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HomeHeader(
                          onMenuTap: () => Scaffold.of(context).openDrawer(),
                          title: 'Profil',
                          icon: Icons.person_rounded,
                        ),
                        const SizedBox(height: 24),
                        // Avatar & Username Header
                        Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryContainer,
                                border: Border.all(color: AppColors.primary, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.2),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.person_rounded, size: 60, color: AppColors.primary),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _profile?.fullName ?? '-',
                              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@${_profile?.username ?? '-'}',
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // User Info
                      Text('Informasi Akun', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildInfoTile(Icons.school_rounded, 'Asal Sekolah', _profile?.sekolah ?? '-'),
                      _buildInfoTile(Icons.class_rounded, 'Kelas', _profile?.kelas ?? '-'),
                      _buildInfoTile(Icons.stars_rounded, 'Total Poin', '${_profile?.totalPoin ?? 0} Poin'),
                      
                      const SizedBox(height: 24),
                      
                      // Menu Lainnya
                      Text('Menu Lainnya', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildActionTile(
                        context,
                        icon: Icons.emoji_events_rounded,
                        title: 'Pencapaian Kuis',
                        subtitle: 'Lihat badge dan histori kuis kamu',
                        onTap: () => context.push('/profil/pencapaian'),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Logout Button
                      ElevatedButton.icon(
                        onPressed: _handleLogout,
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.errorContainer,
                          foregroundColor: AppColors.error,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
