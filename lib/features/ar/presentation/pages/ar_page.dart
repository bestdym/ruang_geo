import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/core/constants/qr_shape_mapping.dart';
import 'package:ruang_geo/models/bangun_model.dart';

/// Halaman QR Scanner untuk AR - scan marker fisik Ruang-Geo
/// Flow: QR discan → lookup mapping lokal → objek 3D overlay muncul di atas kamera
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

  bool _isProcessing = false;
  bool _isFlashOn = false;
  BangunModel? _detectedBangun;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing || _detectedBangun != null) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _isProcessing = true);

    final shapeId = QRShapeMapping.mapping[code];

    if (shapeId != null) {
      final bangun = _findBangunById(shapeId);
      if (bangun != null) {
        setState(() {
          _detectedBangun = bangun;
          _isProcessing = false;
        });
      } else {
        setState(() => _isProcessing = false);
        _showError('Model 3D untuk QR ini belum tersedia');
      }
    } else {
      setState(() => _isProcessing = false);
      _showError('QR tidak dikenali, gunakan marker Ruang-Geo');
    }
  }

  BangunModel? _findBangunById(String id) {
    for (final b in DummyData.bangunRuangList) {
      if (b.id == id) return b;
    }
    return null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _dismissOverlay() {
    setState(() => _detectedBangun = null);
  }

  void _toggleFlash() {
    _controller.toggleTorch();
    setState(() => _isFlashOn = !_isFlashOn);
  }

  @override
  Widget build(BuildContext context) {
    final bangun = _detectedBangun;

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
          if (bangun == null)
            CustomPaint(
              painter: _ScannerOverlayPainter(
                borderColor: AppColors.primary,
                borderRadius: 16,
                borderLength: 36,
                borderWidth: 5,
                cutOutSize: MediaQuery.of(context).size.width * 0.70,
              ),
            ),

          // ─── 3D Object Overlay ──────────────────────────────────────────
          if (bangun != null)
            _BangunOverlay(bangun: bangun),

          // ─── Overlay UI ─────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // TOP BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _CircleButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                      if (bangun == null)
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
                      if (bangun != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                bangun.nama,
                                style: AppTypography.titleMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: (bangun.isBangunRuang
                                          ? AppColors.primary
                                          : AppColors.secondary)
                                      .withAlpha(180),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  bangun.kategori.label,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
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
                if (bangun == null)
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

                // Buttons saat overlay aktif
                if (bangun != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _dismissOverlay,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 44),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                            label: const Text(
                              'Scan Lagi',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.push('/bangun-ruang/${bangun.id}');
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 44),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.menu_book_rounded, size: 18),
                            label: const Text(
                              'Lihat Materi',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),

          // ─── Scan Line Animation ─────────────────────────────────────────
          if (bangun == null)
            const _ScanLineAnimation(),
        ],
      ),
    );
  }
}

// ─── 3D Object Overlay on Camera ────────────────────────────────────────────
class _BangunOverlay extends StatelessWidget {
  const _BangunOverlay({
    required this.bangun,
  });

  final BangunModel bangun;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final objectSize = size.width * 0.55;

    return Center(
      child: Bangun3DViewer(
        bangunId: bangun.id,
        size: objectSize,
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

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final left = (size.width - cutOutSize) / 2;
    final top = (size.height - cutOutSize) / 2 - 40;

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, cutOutSize, cutOutSize),
          Radius.circular(borderRadius),
        ),
      );

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, paint);

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
