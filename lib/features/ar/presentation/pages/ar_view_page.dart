import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';

/// Halaman Kamera AR (Sisi Flutter)
class ArViewPage extends StatefulWidget {
  const ArViewPage({super.key, required this.shapeId});

  final String shapeId;

  @override
  State<ArViewPage> createState() => _ArViewPageState();
}

class _ArViewPageState extends State<ArViewPage> {
  // State management untuk model aktif
  late BangunModel _activeModel;
  
  // State untuk mode kontrol
  bool _isRotating = false;
  bool _isZooming = false;

  @override
  void initState() {
    super.initState();
    _loadModel(widget.shapeId);
  }

  void _loadModel(String id) {
    // Cari di bangun ruang
    BangunModel? model;
    try {
      model = DummyData.bangunRuangList.firstWhere((b) => b.id == id);
    } catch (_) {
      try {
        model = DummyData.bangunDatarList.firstWhere((b) => b.id == id);
      } catch (_) {
        model = DummyData.bangunRuangList.first; // fallback
      }
    }
    setState(() {
      _activeModel = model!;
    });
  }

  // ─── Method Channel Placeholders ──────────────────────────────────────────
  void _changeModel(String modelName) {
    // Nanti panggil: UnityWidgetController.postMessage(...)
    debugPrint('Unity Method Channel: changeModel($modelName)');
  }

  void _rotateModel(double angle) {
    debugPrint('Unity Method Channel: rotateModel($angle)');
  }

  void _zoomModel(double scale) {
    debugPrint('Unity Method Channel: zoomModel($scale)');
  }
  // ────────────────────────────────────────────────────────────────────────

  void _showModelPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    'Pilih Bangun',
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: DummyData.bangunRuangList.length, // Tampilkan bangun ruang dulu
                      itemBuilder: (context, index) {
                        final bangun = DummyData.bangunRuangList[index];
                        final isSelected = _activeModel.id == bangun.id;
                        
                        return GestureDetector(
                          onTap: () {
                            _loadModel(bangun.id);
                            _changeModel(bangun.nama); // Panggil ke Unity
                            context.pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary.withAlpha(20) : AppColors.primary.withAlpha(5),
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.view_in_ar_rounded, size: 48, color: AppColors.primary),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      bangun.nama,
                                      style: AppTypography.labelMedium.copyWith(
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ─── Kamera / Unity Placeholder ──────────────────────────────────
          Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_rounded, size: 64, color: Colors.white.withAlpha(100)),
                  const SizedBox(height: 16),
                  Text(
                    'Camera Preview',
                    style: AppTypography.headlineSmall.copyWith(color: Colors.white.withAlpha(150)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Model aktif: ${_activeModel.nama}',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.primaryContainer),
                  ),
                ],
              ),
            ),
          ),

          // ─── Overlay UI SafeArea ────────────────────────────────────────
          SafeArea(
            child: Stack(
              children: [
                // ─── TOP: Instruksi Center ─────────────────────────────────
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(150),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Arahkan kamera ke marker untuk menampilkan model 3D',
                      style: AppTypography.labelSmall.copyWith(color: Colors.white),
                    ),
                  ),
                ),

                // ─── TOP LEFT: Back Button ──────────────────────────────────
                Positioned(
                  top: 8,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),

                // ─── TOP RIGHT: Help Button ─────────────────────────────────
                Positioned(
                  top: 8,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.help_outline_rounded, color: Colors.white),
                      onPressed: () {
                        // TODO: Tampilkan bantuan AR
                      },
                    ),
                  ),
                ),

                // ─── RIGHT CENTER: Panel Kontrol Vertikal ───────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(150),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildControlButton(
                            icon: Icons.360_rounded,
                            isActive: _isRotating,
                            onTap: () {
                              setState(() => _isRotating = !_isRotating);
                              _rotateModel(90); // trigger dummy method
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildControlButton(
                            icon: Icons.zoom_out_map_rounded,
                            isActive: _isZooming,
                            onTap: () {
                              setState(() => _isZooming = !_isZooming);
                              _zoomModel(1.5); // trigger dummy method
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildControlButton(
                            icon: Icons.visibility_rounded,
                            isActive: false,
                            onTap: () {
                              // Ganti mode tampilan (solid/wireframe)
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── BOTTOM CENTER: Ganti Model Button ──────────────────────
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: ElevatedButton.icon(
                      onPressed: _showModelPickerSheet,
                      icon: const Icon(Icons.dashboard_customize_rounded, color: AppColors.primary),
                      label: Text(
                        'Ganti Model',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white70,
          size: 26,
        ),
      ),
    );
  }
}
