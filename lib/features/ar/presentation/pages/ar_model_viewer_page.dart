import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:ruang_geo/core/core.dart';
import '../../models/ar_model.dart';

/// Halaman menampilkan model 3D bangun setelah QR berhasil discan
class ArModelViewerPage extends StatelessWidget {
  const ArModelViewerPage({super.key, required this.arModel});

  final ARModelModel arModel;

  @override
  Widget build(BuildContext context) {
    final hasModel = arModel.modelUrl != null && arModel.modelUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ─── Model Viewer atau placeholder ─────────────────────────────────
          if (hasModel)
            ModelViewer(
              src: arModel.modelUrl!,
              autoRotate: true,
              cameraControls: true,
              ar: true,
              arModes: const ['webxr', 'scene-viewer', 'quick-look'],
              backgroundColor: const Color.fromARGB(255, 12, 10, 30),
            )
          else
            _buildNoModelPlaceholder(context),

          // ─── TOP BAR overlay ───────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(120),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nama bangun
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          arModel.nama,
                          style: AppTypography.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (arModel.deskripsi != null)
                          Text(
                            arModel.deskripsi!,
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white60,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  // Badge kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (arModel.kategori == 'ruang'
                              ? AppColors.primary
                              : AppColors.secondary)
                          .withAlpha(200),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      arModel.kategori == 'ruang' ? 'Ruang' : 'Datar',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── BOTTOM: Panduan interaksi ──────────────────────────────────────
          if (hasModel)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(140),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _HintItem(
                        icon: Icons.touch_app_rounded, label: 'Putar'),
                    _HintItem(
                        icon: Icons.pinch_rounded, label: 'Zoom'),
                    _HintItem(
                        icon: Icons.view_in_ar_rounded, label: 'AR Mode'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoModelPlaceholder(BuildContext context) {
    return Container(
      color: const Color(0xFF0C0A1E),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.view_in_ar_rounded,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              arModel.nama,
              style: AppTypography.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Model 3D belum tersedia',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Upload file .glb ke Supabase Storage\ndan isi kolom model_url',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white38,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HintItem extends StatelessWidget {
  const _HintItem({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: Colors.white60),
        ),
      ],
    );
  }
}
