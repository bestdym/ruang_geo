import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SHAPE PAINTER FACTORY
// ─────────────────────────────────────────────────────────────────────────────

/// Factory untuk mendapatkan widget animasi sesuai nama/ID bangun datar.
abstract class ShapePainterFactory {
  static Widget getAnimatedShape(String bangunId) {
    return AnimatedShapeWidget(bangunId: bangunId);
  }

  /// Memilih CustomPainter yang sesuai berdasarkan bangunId
  static CustomPainter getShapePainter({
    required String bangunId,
    required double progress,
  }) {
    switch (bangunId) {
      case 'bd_segitiga':
        return SegitigaPainter(progress: progress);
      case 'bd_persegi':
        return PersegiPainter(progress: progress, isSquare: true);
      case 'bd_persegi_panjang':
        return PersegiPainter(progress: progress, isSquare: false);
      case 'bd_lingkaran':
        return LingkaranPainter(progress: progress);
      case 'bd_jajargenjang':
        return JajarGenjangPainter(progress: progress);
      case 'bd_trapesium':
        return TrapesiumPainter(progress: progress);
      case 'bd_layang':
        return LayangLayangPainter(progress: progress);
      default:
        return _DefaultShapePainter(progress: progress, bangunId: bangunId);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATED SHAPE WIDGET (Wrapper dengan Play/Replay + Speed Slider)
// ─────────────────────────────────────────────────────────────────────────────

/// Widget wrapper yang menampilkan animasi bangun datar dengan kontrol:
/// - Tombol ▶ Play / ↺ Replay
/// - Slider kecepatan: Lambat / Normal / Cepat
class AnimatedShapeWidget extends StatefulWidget {
  const AnimatedShapeWidget({
    super.key,
    required this.bangunId,
    this.showControls = true,
  });

  final String bangunId;

  /// Tampilkan tombol kontrol (Play/Replay dan speed slider)
  final bool showControls;

  @override
  State<AnimatedShapeWidget> createState() => _AnimatedShapeWidgetState();
}

class _AnimatedShapeWidgetState extends State<AnimatedShapeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// Nilai slider: 0.5 = lambat, 1.0 = normal, 2.0 = cepat
  double _speedMultiplier = 1.0;

  /// Durasi animasi default (2 detik)
  static const Duration _baseDuration = Duration(seconds: 2);

  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _baseDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _hasCompleted = true);
        }
      });

    // Auto-play saat widget pertama kali muncul
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _play() {
    if (_controller.isCompleted) {
      _replay();
    } else {
      _controller.forward();
    }
  }

  void _replay() {
    setState(() => _hasCompleted = false);
    _controller.reset();
    _controller.forward();
  }

  void _updateSpeed(double value) {
    setState(() => _speedMultiplier = value);
    final elapsed = _controller.value * _controller.duration!.inMilliseconds;
    _controller.duration = Duration(
      milliseconds: (_baseDuration.inMilliseconds / value).round(),
    );
    if (_controller.isAnimating) {
      _controller.value = elapsed / _controller.duration!.inMilliseconds;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── Canvas Animasi ───────────────────────────────────────────────
        Expanded(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter: ShapePainterFactory.getShapePainter(
                  bangunId: widget.bangunId,
                  progress: _controller.value,
                ),
              );
            },
          ),
        ),

        // ─── Kontrol (opsional) ───────────────────────────────────────────
        if (widget.showControls) ...[
          const Divider(height: 1),
          _buildControls(),
        ],
      ],
    );
  }

  Widget _buildControls() {
    final isPlaying = _controller.isAnimating;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Tombol Play / Replay
          GestureDetector(
            onTap: _hasCompleted ? _replay : (_controller.isAnimating ? null : _play),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _hasCompleted
                        ? Icons.replay_rounded
                        : isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _hasCompleted ? 'Replay' : isPlaying ? 'Putar...' : '▶ Play',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Label kecepatan
          Text(
            _speedLabel(_speedMultiplier),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),

          // Slider kecepatan
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                trackHeight: 3,
                activeTrackColor: AppColors.secondary,
                inactiveTrackColor: AppColors.outlineVariant,
                thumbColor: AppColors.secondary,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: _speedMultiplier,
                min: 0.5,
                max: 2.0,
                divisions: 3,
                onChanged: _updateSpeed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _speedLabel(double v) {
    if (v <= 0.5) return '🐢 Lambat';
    if (v <= 1.0) return '▶ Normal';
    return '⚡ Cepat';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BASE CLASS UTILITIES
// ─────────────────────────────────────────────────────────────────────────────

abstract class _BaseShapePainter extends CustomPainter {
  _BaseShapePainter({required this.progress});

  final double progress;

  // ─── Shared Paints ───────────────────────────────────────────────────────
  Paint get strokePaint => Paint()
    ..color = AppColors.primary
    ..strokeWidth = 2.5
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint get fillPaint => Paint()
    ..color = AppColors.primary.withAlpha(25)
    ..style = PaintingStyle.fill;

  Paint get accentPaint => Paint()
    ..color = AppColors.secondary
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  Paint get dotPaint => Paint()
    ..color = AppColors.primary
    ..style = PaintingStyle.fill;

  /// Menggambar sebagian path berdasarkan progress (0.0 – 1.0)
  void drawPartialPath(Canvas canvas, List<Offset> points, double t, Paint paint,
      {bool close = false}) {
    if (points.length < 2 || t <= 0) return;

    final totalSegments = points.length - 1 + (close ? 1 : 0);
    final totalProgress = t * totalSegments;
    final completedSegments = totalProgress.floor().clamp(0, totalSegments);
    final segmentFraction = totalProgress - completedSegments;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < completedSegments; i++) {
      final nextIdx = close && i == points.length - 1 ? 0 : i + 1;
      if (nextIdx < points.length) {
        path.lineTo(points[nextIdx].dx, points[nextIdx].dy);
      }
    }

    // Partial last segment
    if (completedSegments < totalSegments && segmentFraction > 0) {
      final fromIdx = completedSegments;
      final toIdx =
          close && completedSegments == points.length - 1 ? 0 : completedSegments + 1;
      if (fromIdx < points.length && toIdx < points.length) {
        final from = points[fromIdx];
        final to = points[toIdx];
        path.lineTo(
          from.dx + (to.dx - from.dx) * segmentFraction,
          from.dy + (to.dy - from.dy) * segmentFraction,
        );
      }
    }

    canvas.drawPath(path, paint);
  }

  /// Menggambar label teks di posisi tertentu
  void drawLabel(
    Canvas canvas,
    String text,
    Offset center, {
    Color color = const Color(0xFF424242),
    double fontSize = 13,
    bool bold = false,
    bool italic = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.w500,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  /// Opacity fade-in berdasarkan progress range
  double opacityInRange(double start, double end) {
    if (progress <= start) return 0.0;
    if (progress >= end) return 1.0;
    return ((progress - start) / (end - start)).clamp(0.0, 1.0);
  }

  /// Path progress dalam range tertentu
  double progressInRange(double start, double end) {
    if (progress <= start) return 0.0;
    if (progress >= end) return 1.0;
    return ((progress - start) / (end - start)).clamp(0.0, 1.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. SEGITIGA PAINTER
// ─────────────────────────────────────────────────────────────────────────────

/// Animasi segitiga dengan 4 fase:
/// - [0.0–0.3] titik A, B, C muncul (fade in)
/// - [0.3–0.7] garis sisi terbentuk satu per satu (path draw)
/// - [0.7–0.9] label a, b, c muncul
/// - [0.9–1.0] area fill warna transparan
class SegitigaPainter extends _BaseShapePainter {
  SegitigaPainter({required super.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Titik-titik segitiga sama sisi
    final pA = Offset(cx, cy - size.height * 0.35); // Atas
    final pB = Offset(cx - size.width * 0.35, cy + size.height * 0.28); // Kiri bawah
    final pC = Offset(cx + size.width * 0.35, cy + size.height * 0.28); // Kanan bawah

    // ─── Fase 4 (0.9–1.0): Fill area ──────────────────────────────────────
    final fillOpacity = opacityInRange(0.9, 1.0);
    if (fillOpacity > 0) {
      final fillP = Paint()
        ..color = AppColors.primary.withAlpha((25 * fillOpacity).round())
        ..style = PaintingStyle.fill;
      final fillPath = Path()
        ..moveTo(pA.dx, pA.dy)
        ..lineTo(pB.dx, pB.dy)
        ..lineTo(pC.dx, pC.dy)
        ..close();
      canvas.drawPath(fillPath, fillP);
    }

    // ─── Fase 2 (0.3–0.7): Garis sisi ─────────────────────────────────────
    final sisiProgress = progressInRange(0.3, 0.7);
    if (sisiProgress > 0) {
      drawPartialPath(
        canvas,
        [pA, pB, pC],
        sisiProgress,
        strokePaint,
        close: true,
      );
    }

    // ─── Fase 1 (0.0–0.3): Titik sudut A, B, C ────────────────────────────
    final dotAlpha = (opacityInRange(0.0, 0.15) * 255).round();
    if (dotAlpha > 0) {
      final dp = Paint()
        ..color = AppColors.primary.withAlpha(dotAlpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pA, 4, dp);
      canvas.drawCircle(pB, 4, dp);
      canvas.drawCircle(pC, 4, dp);
    }

    // Label titik A, B, C (muncul di fase 1)
    final labelVertexOpacity = opacityInRange(0.15, 0.3);
    if (labelVertexOpacity > 0) {
      drawLabel(canvas, 'A', pA - const Offset(0, 20),
          color: AppColors.primary.withAlpha((labelVertexOpacity * 255).round()),
          bold: true, fontSize: 14);
      drawLabel(canvas, 'B', pB + const Offset(-20, 14),
          color: AppColors.primary.withAlpha((labelVertexOpacity * 255).round()),
          bold: true, fontSize: 14);
      drawLabel(canvas, 'C', pC + const Offset(20, 14),
          color: AppColors.primary.withAlpha((labelVertexOpacity * 255).round()),
          bold: true, fontSize: 14);
    }

    // ─── Fase 3 (0.7–0.9): Label sisi a, b, c ─────────────────────────────
    final labelSisiOpacity = opacityInRange(0.7, 0.9);
    if (labelSisiOpacity > 0) {
      final labelColor = AppColors.textSecondary.withAlpha((labelSisiOpacity * 220).round());
      // Sisi a (B-C)
      drawLabel(canvas, 'a',
          Offset((pB.dx + pC.dx) / 2, pB.dy + 18),
          color: labelColor, italic: true);
      // Sisi b (A-C)
      drawLabel(canvas, 'b',
          Offset((pA.dx + pC.dx) / 2 + 22, (pA.dy + pC.dy) / 2),
          color: labelColor, italic: true);
      // Sisi c (A-B)
      drawLabel(canvas, 'c',
          Offset((pA.dx + pB.dx) / 2 - 22, (pA.dy + pB.dy) / 2),
          color: labelColor, italic: true);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. PERSEGI / PERSEGI PANJANG PAINTER
// ─────────────────────────────────────────────────────────────────────────────

/// Animasi persegi/persegi panjang:
/// - Garis terbentuk searah jarum jam (CW)
/// - Label sisi muncul
/// - Diagonal muncul dengan warna berbeda (secondary)
class PersegiPainter extends _BaseShapePainter {
  PersegiPainter({
    required super.progress,
    required this.isSquare,
  });

  final bool isSquare;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final double rectW = isSquare ? size.width * 0.6 : size.width * 0.75;
    final double rectH = isSquare ? size.width * 0.6 : size.height * 0.45;

    // Titik-titik (CW dari kiri-atas)
    final pA = Offset(cx - rectW / 2, cy - rectH / 2);
    final pB = Offset(cx + rectW / 2, cy - rectH / 2);
    final pC = Offset(cx + rectW / 2, cy + rectH / 2);
    final pD = Offset(cx - rectW / 2, cy + rectH / 2);

    // ─── Fill (0.8–1.0) ────────────────────────────────────────────────────
    final fillOpacity = opacityInRange(0.8, 1.0);
    if (fillOpacity > 0) {
      final fp = Paint()
        ..color = AppColors.primary.withAlpha((25 * fillOpacity).round())
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromPoints(pA, pC), fp);
    }

    // ─── Diagonal (muncul di 0.75–0.9 dengan warna secondary) ──────────────
    final diagOpacity = opacityInRange(0.75, 0.9);
    if (diagOpacity > 0) {
      final dp = Paint()
        ..color = AppColors.secondary.withAlpha((diagOpacity * 180).round())
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      final diagT = progressInRange(0.75, 0.9);
      // Diagonal AC
      final diagAC = [pA, pC];
      drawPartialPath(canvas, diagAC, diagT, Paint()
        ..color = AppColors.secondary.withAlpha((diagOpacity * 160).round())
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round);
      // Diagonal BD (dengan delay)
      if (diagT > 0.5) {
        final diagBD = [pB, pD];
        drawPartialPath(canvas, diagBD, (diagT - 0.5) * 2, Paint()
          ..color = AppColors.secondary.withAlpha((diagOpacity * 160).round())
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);
      }
      // Titik tengah
      canvas.drawCircle(Offset(cx, cy), 3,
          Paint()..color = AppColors.secondary.withAlpha((diagOpacity * 200).round())
            ..style = PaintingStyle.fill);
    }

    // ─── Garis sisi (0.0–0.7) searah jarum jam ─────────────────────────────
    final sisiProgress = progressInRange(0.0, 0.7);
    if (sisiProgress > 0) {
      drawPartialPath(canvas, [pA, pB, pC, pD], sisiProgress, strokePaint, close: true);
    }

    // ─── Label sudut (0.0–0.2) ─────────────────────────────────────────────
    final dotOpacity = opacityInRange(0.0, 0.2);
    if (dotOpacity > 0) {
      final dp = Paint()..color = AppColors.primary.withAlpha((dotOpacity * 255).round())..style = PaintingStyle.fill;
      canvas.drawCircle(pA, 3.5, dp);
      canvas.drawCircle(pB, 3.5, dp);
      canvas.drawCircle(pC, 3.5, dp);
      canvas.drawCircle(pD, 3.5, dp);
    }

    // ─── Label sisi (0.55–0.75) ────────────────────────────────────────────
    final labelOpacity = opacityInRange(0.55, 0.75);
    if (labelOpacity > 0) {
      final lc = AppColors.textSecondary.withAlpha((labelOpacity * 220).round());
      if (isSquare) {
        drawLabel(canvas, 's', Offset(cx, pA.dy - 16), color: lc, italic: true);
        drawLabel(canvas, 's', Offset(pB.dx + 16, cy), color: lc, italic: true);
      } else {
        drawLabel(canvas, 'p', Offset(cx, pA.dy - 16), color: lc, italic: true);
        drawLabel(canvas, 'l', Offset(pB.dx + 16, cy), color: lc, italic: true);
      }
      // Label sudut A, B, C, D
      final pc = AppColors.primary.withAlpha((labelOpacity * 200).round());
      drawLabel(canvas, 'A', pA - const Offset(14, 14), color: pc, bold: true, fontSize: 12);
      drawLabel(canvas, 'B', pB + const Offset(14, -14), color: pc, bold: true, fontSize: 12);
      drawLabel(canvas, 'C', pC + const Offset(14, 14), color: pc, bold: true, fontSize: 12);
      drawLabel(canvas, 'D', pD + const Offset(-14, 14), color: pc, bold: true, fontSize: 12);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. LINGKARAN PAINTER
// ─────────────────────────────────────────────────────────────────────────────

/// Animasi lingkaran:
/// - Arc sweep dari 0° ke 360° (0.0–0.6)
/// - Garis radius muncul (0.6–0.8)
/// - Label r dan d muncul (0.8–1.0)
class LingkaranPainter extends _BaseShapePainter {
  LingkaranPainter({required super.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(size.width, size.height) * 0.38;

    // ─── Fill (saat arc sudah menutup) ─────────────────────────────────────
    if (progress >= 0.6) {
      final fillOpacity = opacityInRange(0.6, 0.75);
      canvas.drawCircle(Offset(cx, cy), radius,
          Paint()..color = AppColors.primary.withAlpha((20 * fillOpacity).round())..style = PaintingStyle.fill);
    }

    // ─── Arc sweep (0.0–0.6) ───────────────────────────────────────────────
    final arcProgress = progressInRange(0.0, 0.6);
    if (arcProgress > 0) {
      final arcPath = Path()
        ..addArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: radius),
          -math.pi / 2,
          arcProgress * 2 * math.pi,
        );
      canvas.drawPath(arcPath, strokePaint);
    }

    // ─── Titik pusat O (muncul di 0.55) ────────────────────────────────────
    final centerOpacity = opacityInRange(0.55, 0.65);
    if (centerOpacity > 0) {
      canvas.drawCircle(Offset(cx, cy), 3.5,
          Paint()..color = AppColors.primary.withAlpha((centerOpacity * 255).round())..style = PaintingStyle.fill);
      drawLabel(canvas, 'O', Offset(cx - 12, cy + 10),
          color: AppColors.primary.withAlpha((centerOpacity * 200).round()), bold: true, fontSize: 12);
    }

    // ─── Garis radius r (0.6–0.8) ──────────────────────────────────────────
    final radiusProgress = progressInRange(0.6, 0.8);
    if (radiusProgress > 0) {
      final radiusEnd = Offset(cx + radius * radiusProgress, cy);
      canvas.drawLine(
        Offset(cx, cy),
        radiusEnd,
        Paint()
          ..color = AppColors.secondary.withAlpha(220)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    // ─── Garis diameter d (muncul diagonal, 0.75–0.9) ──────────────────────
    final diamProgress = progressInRange(0.75, 0.9);
    if (diamProgress > 0) {
      final startPt = Offset(cx - radius * diamProgress, cy);
      canvas.drawLine(
        startPt,
        Offset(cx + radius, cy),
        Paint()
          ..color = AppColors.primary.withAlpha(80)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    // ─── Label r dan d (0.8–1.0) ───────────────────────────────────────────
    final labelOpacity = opacityInRange(0.8, 1.0);
    if (labelOpacity > 0) {
      final lc = AppColors.textSecondary.withAlpha((labelOpacity * 220).round());
      drawLabel(canvas, 'r', Offset(cx + radius / 2, cy - 14), color: AppColors.secondary.withAlpha((labelOpacity * 220).round()), italic: true, bold: true);
      drawLabel(canvas, 'd', Offset(cx, cy + 16), color: lc, italic: true);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. JAJAR GENJANG PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class JajarGenjangPainter extends _BaseShapePainter {
  JajarGenjangPainter({required super.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final double w = size.width * 0.7;
    final double h = size.height * 0.4;
    final double skew = size.width * 0.15; // Geser horizontal

    final pA = Offset(cx - w / 2 + skew, cy - h / 2); // Kiri atas
    final pB = Offset(cx + w / 2 + skew, cy - h / 2); // Kanan atas
    final pC = Offset(cx + w / 2 - skew, cy + h / 2); // Kanan bawah
    final pD = Offset(cx - w / 2 - skew, cy + h / 2); // Kiri bawah

    // Fill (0.8–1.0)
    final fillOp = opacityInRange(0.8, 1.0);
    if (fillOp > 0) {
      final fp = Path()..moveTo(pA.dx, pA.dy)..lineTo(pB.dx, pB.dy)..lineTo(pC.dx, pC.dy)..lineTo(pD.dx, pD.dy)..close();
      canvas.drawPath(fp, Paint()..color = AppColors.primary.withAlpha((25 * fillOp).round())..style = PaintingStyle.fill);
    }

    // Garis path (0.0–0.7)
    final sp = progressInRange(0.0, 0.7);
    drawPartialPath(canvas, [pA, pB, pC, pD], sp, strokePaint, close: true);

    // Garis tinggi t (0.7–0.85)
    final tOp = opacityInRange(0.7, 0.85);
    if (tOp > 0) {
      final tPaint = Paint()
        ..color = AppColors.secondary.withAlpha((tOp * 180).round())
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      final footX = pD.dx + skew;
      canvas.drawLine(Offset(footX, pA.dy), Offset(footX, pD.dy), tPaint);
      // Tanda siku-siku
      const sq = 8.0;
      canvas.drawRect(
        Rect.fromLTWH(footX, pD.dy - sq, sq, sq),
        Paint()..color = AppColors.secondary.withAlpha((tOp * 150).round())..style = PaintingStyle.stroke..strokeWidth = 1.5,
      );
    }

    // Label (0.65–0.85)
    final lOp = opacityInRange(0.65, 0.85);
    if (lOp > 0) {
      final lc = AppColors.textSecondary.withAlpha((lOp * 220).round());
      drawLabel(canvas, 'a', Offset((pA.dx + pB.dx) / 2, pA.dy - 16), color: lc, italic: true);
      drawLabel(canvas, 'b', Offset(pD.dx - 16, (pD.dy + pA.dy) / 2), color: lc, italic: true);
      drawLabel(canvas, 't', Offset(pD.dx + skew - 18, cy), color: AppColors.secondary.withAlpha((lOp * 200).round()), italic: true, bold: true);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. TRAPESIUM PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class TrapesiumPainter extends _BaseShapePainter {
  TrapesiumPainter({required super.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final double topW = size.width * 0.4; // sisi atas lebih pendek
    final double botW = size.width * 0.72; // sisi bawah lebih panjang
    final double h = size.height * 0.42;

    final pA = Offset(cx - topW / 2, cy - h / 2); // Kiri atas
    final pB = Offset(cx + topW / 2, cy - h / 2); // Kanan atas
    final pC = Offset(cx + botW / 2, cy + h / 2); // Kanan bawah
    final pD = Offset(cx - botW / 2, cy + h / 2); // Kiri bawah

    // Fill (0.8–1.0)
    final fillOp = opacityInRange(0.8, 1.0);
    if (fillOp > 0) {
      final fp = Path()..moveTo(pA.dx, pA.dy)..lineTo(pB.dx, pB.dy)..lineTo(pC.dx, pC.dy)..lineTo(pD.dx, pD.dy)..close();
      canvas.drawPath(fp, Paint()..color = AppColors.primary.withAlpha((25 * fillOp).round())..style = PaintingStyle.fill);
    }

    // Garis sisi (0.0–0.7)
    final sp = progressInRange(0.0, 0.7);
    drawPartialPath(canvas, [pA, pB, pC, pD], sp, strokePaint, close: true);

    // Garis tinggi (0.65–0.82)
    final tOp = opacityInRange(0.65, 0.82);
    if (tOp > 0) {
      canvas.drawLine(
        Offset(cx, pA.dy), Offset(cx, pD.dy),
        Paint()..color = AppColors.secondary.withAlpha((tOp * 180).round())..strokeWidth = 1.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round,
      );
      // Tanda siku-siku
      const sq = 7.0;
      canvas.drawRect(
        Rect.fromLTWH(cx, pA.dy, sq, sq),
        Paint()..color = AppColors.secondary.withAlpha((tOp * 150).round())..style = PaintingStyle.stroke..strokeWidth = 1.5,
      );
    }

    // Label (0.62–0.8)
    final lOp = opacityInRange(0.62, 0.8);
    if (lOp > 0) {
      final lc = AppColors.textSecondary.withAlpha((lOp * 220).round());
      drawLabel(canvas, 'a', Offset((pA.dx + pB.dx) / 2, pA.dy - 16), color: lc, italic: true);
      drawLabel(canvas, 'b', Offset((pD.dx + pC.dx) / 2, pD.dy + 18), color: lc, italic: true);
      drawLabel(canvas, 't', Offset(cx + 16, cy), color: AppColors.secondary.withAlpha((lOp * 200).round()), italic: true, bold: true);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. LAYANG-LAYANG PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class LayangLayangPainter extends _BaseShapePainter {
  LayangLayangPainter({required super.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final pTop = Offset(cx, cy - size.height * 0.42);
    final pLeft = Offset(cx - size.width * 0.35, cy + size.height * 0.05);
    final pBot = Offset(cx, cy + size.height * 0.42);
    final pRight = Offset(cx + size.width * 0.35, cy + size.height * 0.05);

    // Fill (0.8–1.0)
    final fillOp = opacityInRange(0.8, 1.0);
    if (fillOp > 0) {
      final fp = Path()..moveTo(pTop.dx, pTop.dy)..lineTo(pLeft.dx, pLeft.dy)..lineTo(pBot.dx, pBot.dy)..lineTo(pRight.dx, pRight.dy)..close();
      canvas.drawPath(fp, Paint()..color = AppColors.primary.withAlpha((25 * fillOp).round())..style = PaintingStyle.fill);
    }

    // Garis sisi (0.0–0.7)
    final sp = progressInRange(0.0, 0.7);
    drawPartialPath(canvas, [pTop, pLeft, pBot, pRight], sp, strokePaint, close: true);

    // Diagonal d1 (vertikal, 0.65–0.8)
    final d1Op = opacityInRange(0.65, 0.8);
    if (d1Op > 0) {
      final dp = Paint()..color = AppColors.secondary.withAlpha((d1Op * 160).round())..strokeWidth = 1.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
      drawPartialPath(canvas, [pTop, pBot], progressInRange(0.65, 0.8), dp);
    }

    // Diagonal d2 (horizontal, 0.75–0.88)
    final d2Op = opacityInRange(0.75, 0.88);
    if (d2Op > 0) {
      final dp = Paint()..color = AppColors.secondary.withAlpha((d2Op * 130).round())..strokeWidth = 1.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
      drawPartialPath(canvas, [pLeft, pRight], progressInRange(0.75, 0.88), dp);

      // Tanda siku-siku di titik potong diagonal
      const sq = 7.0;
      final iy = (pLeft.dy + pTop.dy * 0.2) * 0.8 + cy * 0.3;
      canvas.drawRect(
        Rect.fromLTWH(cx, cy - sq / 2, sq, sq),
        Paint()..color = AppColors.secondary.withAlpha((d2Op * 150).round())..style = PaintingStyle.stroke..strokeWidth = 1.5,
      );
    }

    // Label d1, d2 (0.78–0.95)
    final lOp = opacityInRange(0.78, 0.95);
    if (lOp > 0) {
      final lc = AppColors.textSecondary.withAlpha((lOp * 220).round());
      drawLabel(canvas, 'd₁', Offset(cx + 18, cy - size.height * 0.15), color: AppColors.secondary.withAlpha((lOp * 200).round()), italic: true, bold: true);
      drawLabel(canvas, 'd₂', Offset((pLeft.dx + cx) / 2, cy - 16), color: lc, italic: true);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. DEFAULT PAINTER (fallback)
// ─────────────────────────────────────────────────────────────────────────────

class _DefaultShapePainter extends _BaseShapePainter {
  _DefaultShapePainter({required super.progress, required this.bangunId});
  final String bangunId;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(size.width, size.height) * 0.35 * progress;

    canvas.drawCircle(Offset(cx, cy), r, strokePaint);
    drawLabel(canvas, bangunId, Offset(cx, cy),
        color: AppColors.textHint.withAlpha((progress * 200).round()));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXTENSION: stroke dash helper (no-op shim agar kode compile)
// ─────────────────────────────────────────────────────────────────────────────
extension _PaintDashExt on Paint {
  // Dart/Flutter belum support native dash melalui Paint langsung.
  // Gunakan path_drawing package jika ingin dashed line.
  // Ini hanya placeholder agar field assign tidak error.
  // ignore: unused_element
  set strokeDashArray(Object? _) {}
}
