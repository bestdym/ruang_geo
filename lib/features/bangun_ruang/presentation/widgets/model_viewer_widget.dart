import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/core/utils/model_path_helper.dart';

/// Widget reusable untuk menampilkan model 3D menggunakan model_viewer_plus.
///
/// Jika file .glb belum tersedia (path null atau tidak ada di bundle), otomatis fallback ke
/// [Bangun3DViewer] (custom painter) agar tampilan tetap ada.
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
  late final String? _modelPath;

  @override
  void initState() {
    super.initState();
    _modelPath = ModelPathHelper.getModelPath(widget.bangunId);
  }

  Future<bool> _checkAssetExists(BuildContext context, String? path) async {
    if (path == null) return false;
    try {
      final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      return manifestMap.containsKey(path);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jika path tidak ditemukan, tampilkan fallback Bangun3DViewer
    if (_modelPath == null) {
      return _buildFallback();
    }

    return FutureBuilder<bool>(
      future: _checkAssetExists(context, _modelPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: widget.backgroundColor,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final assetExists = snapshot.data ?? false;
        if (!assetExists) {
          return _buildFallback();
        }

        // Render ModelViewer jika file .glb benar-benar tersedia di bundle
        return ModelViewer(
          src: _modelPath,
          autoRotate: widget.autoRotate,
          cameraControls: widget.cameraControls,
          backgroundColor: widget.backgroundColor,
          shadowIntensity: widget.shadowIntensity,
          autoRotateDelay: 0,
          rotationPerSecond: '30deg',
          debugLogging: false,
          onWebViewCreated: (controller) {
            // WebView berhasil dibuat; model mulai loading di WebGL
          },
        );
      },
    );
  }

  /// Fallback: tampilkan Bangun3DViewer jika .glb belum tersedia
  Widget _buildFallback() {
    return Container(
      color: widget.backgroundColor,
      child: Center(
        child: Bangun3DViewer(
          bangunId: widget.bangunId,
          size: widget.fallbackSize,
        ),
      ),
    );
  }
}
