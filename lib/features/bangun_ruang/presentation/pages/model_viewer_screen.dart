import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/core/utils/model_path_helper.dart';
import 'package:ruang_geo/models/models.dart';
import 'package:ruang_geo/features/bangun_ruang/presentation/widgets/model_viewer_widget.dart';

/// Halaman full-screen untuk melihat model 3D secara interaktif.
///
/// Layout:
/// - AppBar dengan nama bangun & tombol favorit
/// - ModelViewer (50% tinggi layar atas)
/// - Tombol Auto Rotate + AR Mode
/// - Panel info bawah: Sisi / Rusuk / Titik Sudut
class ModelViewerScreen extends StatefulWidget {
  const ModelViewerScreen({
    super.key,
    required this.bangunId,
  });

  final String bangunId;

  @override
  State<ModelViewerScreen> createState() => _ModelViewerScreenState();
}

class _ModelViewerScreenState extends State<ModelViewerScreen> {
  late final BangunModel _bangun;
  bool _autoRotate = true;
  bool _hasModel = false;
  bool _isCheckingModel = true;

  @override
  void initState() {
    super.initState();
    _bangun = DummyData.bangunRuangList.firstWhere(
      (b) => b.id == widget.bangunId,
      orElse: () => DummyData.bangunRuangList.first,
    );
    _checkModelExistence();
  }

  Future<void> _checkModelExistence() async {
    final path = ModelPathHelper.getModelPath(widget.bangunId);
    if (path == null) {
      if (mounted) {
        setState(() {
          _hasModel = false;
          _isCheckingModel = false;
        });
      }
      return;
    }

    try {
      final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      if (mounted) {
        setState(() {
          _hasModel = manifestMap.containsKey(path);
          _isCheckingModel = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasModel = false;
          _isCheckingModel = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBarCustom(
        backgroundColor: Colors.transparent,
        title: _bangun.nama,
        actionIcon: Icons.favorite_border_rounded,
        onActionPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_bangun.nama} ditambahkan ke favorit!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),

      body: Column(
        children: [
          // ─── Area Model Viewer (50% layar) ──────────────────────────────
          Container(
            height: screenHeight * 0.50,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF0FF),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              child: RGModelViewer(
                bangunId: widget.bangunId,
                autoRotate: _autoRotate,
                backgroundColor: const Color(0xFFEEF0FF),
                shadowIntensity: 1.0,
                fallbackSize: 140,
              ),
            ),
          ),

          // ─── Tombol Kontrol ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                // Tombol Auto Rotate
                Expanded(
                  child: _ControlButton(
                    icon: _autoRotate
                        ? Icons.sync_disabled_rounded
                        : Icons.sync_rounded,
                    label: _autoRotate ? 'Stop Rotate' : '↺ Auto Rotate',
                    isActive: _autoRotate,
                    onTap: () => setState(() => _autoRotate = !_autoRotate),
                    activeColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                // Tombol AR Mode
                Expanded(
                  child: _ControlButton(
                    icon: Icons.view_in_ar_rounded,
                    label: '📷 AR Mode',
                    isActive: false,
                    onTap: () {
                      context.push('${AppConstants.routeAR}/${_bangun.id}');
                    },
                    activeColor: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),

          // ─── Panel Info ─────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kartu Statistik: Sisi / Rusuk / Sudut
                  _buildStatRow(),
                  const SizedBox(height: 20),

                  // Status model
                  _buildModelStatus(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    final sisi = _extractNumber('sisi');
    final rusuk = _extractNumber('rusuk');
    final sudut = _extractNumber('sudut');

    return Row(
      children: [
        _StatCard(
          icon: Icons.square_outlined,
          label: 'Sisi',
          value: sisi,
          color: AppColors.primary,
        ),
        const SizedBox(width: 10),
        _StatCard(
          icon: Icons.horizontal_rule_rounded,
          label: 'Rusuk',
          value: rusuk,
          color: AppColors.secondary,
        ),
        const SizedBox(width: 10),
        _StatCard(
          icon: Icons.architecture_rounded,
          label: 'Titik Sudut',
          value: sudut,
          color: AppColors.accent,
        ),
      ],
    );
  }

  Widget _buildModelStatus() {
    if (_isCheckingModel) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_hasModel) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.successContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success.withAlpha(80)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Model 3D siap — geser untuk rotate, pinch untuk zoom!',
                style: AppTypography.bodySmall.copyWith(
                    color: AppColors.successDark),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withAlpha(120)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.warningDark, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'File model 3D belum tersedia',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.warningDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tambahkan file "${_getModelFileName()}" ke folder '
                  'assets/models/bangun_ruang/ untuk mengaktifkan viewer 3D interaktif.',
                  style: AppTypography.bodySmall.copyWith(
                      color: AppColors.warningDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getModelFileName() {
    final path = ModelPathHelper.getModelPath(widget.bangunId);
    if (path == null) return '${widget.bangunId}.glb';
    return path.split('/').last;
  }

  String _extractNumber(String keyword) {
    for (var kalimat in _bangun.sifatSifat) {
      if (kalimat.toLowerCase().contains(keyword)) {
        final regex = RegExp(r'\d+');
        final match = regex.firstMatch(kalimat);
        if (match != null) return match.group(0)!;
      }
    }
    return '-';
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? activeColor : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? activeColor : AppColors.outlineVariant,
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withAlpha(60),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTypography.headlineMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
