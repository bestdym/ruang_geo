import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ruang_geo/core/core.dart';
import '../../models/ar_model.dart';
import '../../services/ar_service.dart';
import 'ar_model_viewer_page.dart';

/// Halaman QR Scanner untuk AR - scan marker fisik Ruang-Geo
class ArPage extends StatefulWidget {
  const ArPage({super.key});

  @override
  State<ArPage> createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  
  final _arService = ARService();

  bool _isProcessing = false;
  bool _isPaused = false;
  bool _isFlashOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || _isPaused) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    
    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _isProcessing = true);
    _controller.stop(); // Berhenti sementara

    if (!mounted) return;

    // Query Supabase
    final arModel = await _arService.getARModelByQR(code);

    if (!mounted) return;

    if (arModel != null) {
      _showModelFoundSheet(arModel);
    } else {
      // QR tidak dikenali
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('QR tidak dikenali, gunakan marker Ruang-Geo'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      await _resumeScanner();
    }

    setState(() => _isProcessing = false);
  }

  Future<void> _resumeScanner() async {
    await _controller.start();
    setState(() => _isPaused = false);
  }

  void _showModelFoundSheet(ARModelModel model) {
    setState(() => _isPaused = true);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FoundBottomSheet(
        model: model,
        onLihat3D: () {
          Navigator.pop(ctx);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ArModelViewerPage(arModel: model),
            ),
          );
        },
        onScanLagi: () {
          Navigator.pop(ctx);
          _resumeScanner();
        },
      ),
    );
  }

  void _toggleFlash() {
    _controller.toggleTorch();
    setState(() => _isFlashOn = !_isFlashOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ─── QR Scanner Fullscreen ──────────────────────────────────────
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // ─── Scanner Overlay Frame ──────────────────────────────────────
          CustomPaint(
            painter: _ScannerOverlayPainter(
              borderColor: AppColors.primary,
              borderRadius: 16,
              borderLength: 36,
              borderWidth: 5,
              cutOutSize: MediaQuery.of(context).size.width * 0.70,
            ),
          ),

          // ─── Overlay UI ─────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // TOP BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Tombol back
                      _CircleButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                      // Judul
                      Column(
                        children: [
                          Text(
                            'AR Scanner',
                            style: AppTypography.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Ruang-Geo',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Tombol flash
                      _CircleButton(
                        icon: _isFlashOn
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        iconColor:
                            _isFlashOn ? AppColors.warning : Colors.white,
                        onTap: _toggleFlash,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // TEKS INSTRUKSI DI BAWAH FRAME
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isProcessing) ...[
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Memproses...',
                          style: AppTypography.labelMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ] else ...[
                        const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Arahkan ke marker Ruang-Geo',
                          style: AppTypography.labelMedium.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Posisikan QR code dalam bingkai di atas',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // ─── Corner scan animasi ─────────────────────────────────────────
          const _ScanLineAnimation(),
        ],
      ),
    );
  }
}

// ─── Scanner Overlay Custom Painter ──────────────────────────────────────────
class _ScannerOverlayPainter extends CustomPainter {
  _ScannerOverlayPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
    required this.cutOutSize,
  });

  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final double cutOutSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Menggambar latar gelap
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Menghitung posisi kotak (di tengah)
    final left = (size.width - cutOutSize) / 2;
    // Beri offset ke atas sedikit mengikuti UI
    final top = (size.height - cutOutSize) / 2 - 40; 
    
    // Menggambar kotak bolong
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, cutOutSize, cutOutSize),
          Radius.circular(borderRadius),
        ),
      );

    // Mengurangi kotak dari latar gelap
    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, paint);

    // Menggambar sudut border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Kiri Atas
    path.moveTo(left, top + borderLength);
    path.lineTo(left, top + borderRadius);
    path.quadraticBezierTo(left, top, left + borderRadius, top);
    path.lineTo(left + borderLength, top);
    
    // Kanan Atas
    path.moveTo(left + cutOutSize - borderLength, top);
    path.lineTo(left + cutOutSize - borderRadius, top);
    path.quadraticBezierTo(left + cutOutSize, top, left + cutOutSize, top + borderRadius);
    path.lineTo(left + cutOutSize, top + borderLength);

    // Kanan Bawah
    path.moveTo(left + cutOutSize, top + cutOutSize - borderLength);
    path.lineTo(left + cutOutSize, top + cutOutSize - borderRadius);
    path.quadraticBezierTo(left + cutOutSize, top + cutOutSize, left + cutOutSize - borderRadius, top + cutOutSize);
    path.lineTo(left + cutOutSize - borderLength, top + cutOutSize);

    // Kiri Bawah
    path.moveTo(left + borderLength, top + cutOutSize);
    path.lineTo(left + borderRadius, top + cutOutSize);
    path.quadraticBezierTo(left, top + cutOutSize, left, top + cutOutSize - borderRadius);
    path.lineTo(left, top + cutOutSize - borderLength);

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Found Bottom Sheet ───────────────────────────────────────────────────────
class _FoundBottomSheet extends StatelessWidget {
  const _FoundBottomSheet({
    required this.model,
    required this.onLihat3D,
    required this.onScanLagi,
  });

  final ARModelModel model;
  final VoidCallback onLihat3D;
  final VoidCallback onScanLagi;

  @override
  Widget build(BuildContext context) {
    final kategoriColor = model.kategori == 'ruang'
        ? AppColors.primary
        : AppColors.secondary;
    final kategoriIcon = model.kategori == 'ruang'
        ? Icons.view_in_ar_rounded
        : Icons.shape_line_rounded;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indikator handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Ikon bangun
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: kategoriColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(kategoriIcon, color: kategoriColor, size: 38),
            ),
            const SizedBox(height: 14),

            // Status ditemukan
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'QR Dikenali!',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Nama bangun
            Text(
              'Ditemukan: ${model.nama}',
              style: AppTypography.titleLarge
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            if (model.deskripsi != null) ...[
              const SizedBox(height: 6),
              Text(
                model.deskripsi!,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 24),

            // Tombol Lihat 3D
            ElevatedButton.icon(
              onPressed: onLihat3D,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.view_in_ar_rounded),
              label: const Text(
                'Lihat Model 3D',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),

            // Tombol Scan Lagi
            OutlinedButton.icon(
              onPressed: onScanLagi,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: AppColors.outlineVariant),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.qr_code_scanner_rounded,
                  color: AppColors.textSecondary),
              label: Text(
                'Scan Lagi',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }
}

// ─── Circle Button Helper ─────────────────────────────────────────────────────
class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(120),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}

// ─── Scan Line Animation ──────────────────────────────────────────────────────
class _ScanLineAnimation extends StatefulWidget {
  const _ScanLineAnimation();

  @override
  State<_ScanLineAnimation> createState() => _ScanLineAnimationState();
}

class _ScanLineAnimationState extends State<_ScanLineAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cutOut = size.width * 0.70;
    final offsetTop = (size.height - cutOut) / 2 - 40;

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Positioned(
          top: offsetTop + (_anim.value * (cutOut - 4)),
          left: (size.width - cutOut) / 2,
          width: cutOut,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.primary.withAlpha(200),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
    );
  }
}
