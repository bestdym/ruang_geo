import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/core/utils/model_path_helper.dart';

/// Widget reusable untuk menampilkan model 3D menggunakan model_viewer_plus.
///
/// Jika file .glb belum tersedia, otomatis fallback ke [Bangun3DViewer]
/// (custom painter) agar tampilan tetap ada.
class RGModelViewer extends StatefulWidget {
  const RGModelViewer({
    super.key,
    required this.bangunId,
    this.autoRotate = true,
    this.cameraControls = true,
    this.backgroundColor = const Color(0xFFEEF0FF),
    this.shadowIntensity = 1.0,
    this.fallbackSize = 120.0,
  });

  /// ID bangun ruang (contoh: 'br_kubus', 'br_balok')
  final String bangunId;

  /// Aktifkan auto rotate
  final bool autoRotate;

  /// Aktifkan kontrol kamera (drag untuk rotate manual)
  final bool cameraControls;

  /// Warna latar belakang viewer
  final Color backgroundColor;

  /// Intensitas bayangan (0.0 - 1.0)
  final double shadowIntensity;

  /// Ukuran fallback 3D viewer jika file .glb belum ada
  final double fallbackSize;

  @override
  State<RGModelViewer> createState() => _RGModelViewerState();
}

class _RGModelViewerState extends State<RGModelViewer> {
  bool _hasError = false;
  bool _isLoading = true;
  late final String? _modelPath;

  @override
  void initState() {
    super.initState();
    _modelPath = ModelPathHelper.getModelPath(widget.bangunId);
  }

  @override
  Widget build(BuildContext context) {
    // Jika path tidak ditemukan atau sudah error, tampilkan fallback
    if (_modelPath == null || _hasError) {
      return _buildFallback();
    }

    return Stack(
      children: [
        // ─── Model Viewer ───────────────────────────────────────────────
        ModelViewer(
          src: _modelPath!,
          autoRotate: widget.autoRotate,
          cameraControls: widget.cameraControls,
          backgroundColor: widget.backgroundColor,
          shadowIntensity: widget.shadowIntensity,
          autoRotateDelay: 0,
          rotationPerSecond: '30deg',
          onWebViewCreated: (controller) {
            // Model mulai loading
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            // Halaman WebView selesai load
            if (mounted) setState(() => _isLoading = false);
          },
          onPageStarted: (url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onWebResourceError: (error) {
            // Error loading model
            if (mounted) setState(() {
              _hasError = true;
              _isLoading = false;
            });
          },
        ),

        // ─── Loading Indicator ──────────────────────────────────────────
        if (_isLoading)
          Container(
            color: widget.backgroundColor,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Memuat model 3D...',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Fallback: tampilkan Bangun3DViewer jika .glb belum tersedia
  Widget _buildFallback() {
    return Container(
      color: widget.backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Bangun3DViewer(
              bangunId: widget.bangunId,
              size: widget.fallbackSize,
            ),
            if (_hasError) ...[
              const SizedBox(height: 8),
              Text(
                'Model 3D belum tersedia',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
