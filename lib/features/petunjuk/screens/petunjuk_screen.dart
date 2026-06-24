import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import '../../home/presentation/widgets/home_widgets.dart';

class PetunjukScreen extends StatelessWidget {
  const PetunjukScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: Builder(
        builder: (context) => SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            children: [
              HomeHeader(
                onMenuTap: () => Scaffold.of(context).openDrawer(),
                onProfileTap: () => context.push('/profil'),
              ),
              const SizedBox(height: 20),
              // ─── Header Card ──────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF5A52D5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(50),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.explore_rounded, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang!',
                            style: AppTypography.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'di Aplikasi Ruang Geo',
                            style: AppTypography.bodyMedium.copyWith(color: Colors.white.withAlpha(200)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Ruang Geo adalah aplikasi pembelajaran interaktif untuk membantumu memahami materi bangun datar dan bangun ruang dengan visualisasi 2D, 3D, dan Augmented Reality (AR).',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white.withAlpha(230), height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          Text(
            'Panduan Fitur Utama',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),

          // ─── Panduan Cards ────────────────────────────────────────────────
          const _PanduanCard(
            icon: Icons.view_in_ar_rounded,
            color: AppColors.primary,
            title: 'Eksplorasi Bangun',
            description: 'Pilih menu Bangun Datar atau Bangun Ruang di beranda. Kamu bisa melihat animasi pembentukan bangun, membaca sifat-sifatnya, dan mempelajari rumusnya.',
          ),
          const SizedBox(height: 16),
          
          const _PanduanCard(
            icon: Icons.layers_rounded,
            color: AppColors.secondary,
            title: 'Visualisasi 3D & Jaring-jaring',
            description: 'Pada detail Bangun Ruang, gunakan tombol toggle untuk beralih antara melihat model 3D yang bisa diputar, dan animasi jaring-jaring yang dilipat.',
          ),
          const SizedBox(height: 16),

          const _PanduanCard(
            icon: Icons.camera_alt_rounded,
            color: AppColors.warning,
            title: 'Augmented Reality (AR)',
            description: 'Bawa bangun ruang ke dunia nyata! Gunakan fitur AR untuk menampilkan objek 3D di atas meja atau lantai melalui kamera smartphone kamu.',
          ),
          const SizedBox(height: 16),

          const _PanduanCard(
            icon: Icons.quiz_rounded,
            color: AppColors.success,
            title: 'Kuis & Evaluasi',
            description: 'Uji kemampuanmu melalui Kuis! Terdapat pilihan tingkat kesulitan dan pembahasan lengkap untuk setiap soal yang telah kamu kerjakan.',
          ),
          const SizedBox(height: 16),

          const _PanduanCard(
            icon: Icons.emoji_events_rounded,
            color: Color(0xFFF06292), // Pink
            title: 'Sistem Pencapaian',
            description: 'Setiap kali kamu menyelesaikan materi atau kuis, kamu akan mendapatkan poin dan lencana. Kumpulkan lencana sebanyak-banyaknya di menu Pencapaian!',
          ),
          
          const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanduanCard extends StatefulWidget {
  const _PanduanCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;

  @override
  State<_PanduanCard> createState() => _PanduanCardState();
}

class _PanduanCardState extends State<_PanduanCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.02 : 1.0)
            ..translate(0.0, _isHovered ? -4.0 : 0.0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? widget.color.withAlpha(100) : AppColors.outlineVariant,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withAlpha(_isHovered ? 30 : 10),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color.withAlpha(_isHovered ? 40 : 20),
                  shape: BoxShape.circle,
                ),
                child: AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: Icon(widget.icon, color: widget.color, size: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _isHovered ? widget.color : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
