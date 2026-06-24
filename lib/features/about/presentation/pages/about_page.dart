import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarCustom(title: 'Tentang Aplikasi'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Logo App
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(20),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logo.png',
                height: 80,
                width: 80,
              ),
            ),
            const SizedBox(height: 24),
            
            // App Title & Subtitle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ruang',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Geo',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Aplikasi Geometri Berbasis AR',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'RuangGeo adalah aplikasi pembelajaran geometri berbasis Augmented Reality (AR) yang membantu siswa memahami konsep bangun ruang secara interaktif dan visual.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Logos Container
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/univ.png',
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Image.asset(
                      'assets/images/dikt.png',
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Developer Card
            _buildCard(
              title: 'Profil Pengembang (Ketua Peneliti)',
              icon: Icons.person_rounded,
              headerColor: AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: AppColors.surface,
                        width: 100,
                        height: 120,
                        child: Image.asset(
                          'assets/images/psigit.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sigit Rimbatmojo, M.Pd.',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.school_outlined, 'Dosen Pendidikan Matematika'),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.account_balance_outlined, 'Fakultas Keguruan dan Ilmu Pendidikan\nUniversitas Peradaban'),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.email_outlined, 'sigit.rimbatmojo@peradaban.ac.id'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Research Info Card
            _buildCard(
              title: 'Informasi Penelitian',
              icon: Icons.assignment_outlined,
              headerColor: AppColors.secondary,
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.military_tech_outlined,
                    title: 'Didanai oleh',
                    subtitle: 'DPPM Kemdiktisaintek',
                    trailing: Image.asset('assets/images/dikt.png', height: 40),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.layers_outlined,
                    title: 'Skema',
                    subtitle: 'Penelitian Dosen Pemula',
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.description_outlined,
                    title: 'Nomor Kontrak',
                    subtitle: '285/C3/DT.05.00/PL-BARU/2026',
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.calendar_today_outlined,
                    title: 'Tahun',
                    subtitle: '2026',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Research Members Card
            _buildCard(
              title: 'Anggota Peneliti',
              icon: Icons.group_outlined,
              headerColor: AppColors.success,
              child: Column(
                children: [
                  _buildMemberTile(
                    name: 'Eka Farida Fasha, S.Si., M.Pd.',
                    role: 'Dosen Universitas Peradaban',
                    imagePath: 'assets/images/beka.png',
                  ),
                  _buildDivider(),
                  _buildMemberTile(
                    name: 'Khurotul Aeni, M.Kom.',
                    role: 'Dosen Universitas Peradaban',
                    imagePath: 'assets/images/bkhurotul.png',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textHint),
                const SizedBox(width: 8),
                Text(
                  'Versi Aplikasi 1.0.0',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textHint),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '© 2026 Universitas Peradaban',
              style: AppTypography.labelSmall.copyWith(color: AppColors.textHint),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color headerColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: headerColor.withAlpha(50), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: headerColor.withAlpha(20),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Icon(icon, color: headerColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: headerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
      title: Text(title, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
      trailing: trailing,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildMemberTile({
    required String name,
    required String role,
    required String imagePath,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.surface,
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(role, style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: AppColors.outline.withAlpha(50));
  }
}
