import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

/// Widget dekorasi background floating shapes
///
/// Menampilkan bentuk geometri transparan sebagai elemen visual
/// yang membuat halaman terasa lebih hidup dan sesuai tema geometri.
class FloatingDecorations extends StatelessWidget {
  const FloatingDecorations({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ─── Lingkaran besar kanan atas ────────────────────────────────────
        Positioned(
          top: -60,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withAlpha(15),
            ),
          ),
        ),

        // ─── Lingkaran medium kiri atas ────────────────────────────────────
        Positioned(
          top: 60,
          left: -40,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withAlpha(20),
            ),
          ),
        ),

        // ─── Persegi miring (kubus kecil) ─────────────────────────────────
        Positioned(
          top: 180,
          right: 20,
          child: Transform.rotate(
            angle: 0.5,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // ─── Dot grid kecil dekoratif ──────────────────────────────────────
        Positioned(
          top: 130,
          right: 30,
          child: _DotGrid(
            rows: 3,
            cols: 3,
            color: AppColors.primary.withAlpha(40),
          ),
        ),

        // ─── Segitiga (pakai ClipPath) ────────────────────────────────────
        Positioned(
          bottom: 200,
          left: 10,
          child: Transform.rotate(
            angle: -0.3,
            child: CustomPaint(
              size: const Size(45, 40),
              painter: _TrianglePainter(
                color: AppColors.success.withAlpha(30),
              ),
            ),
          ),
        ),

        // ─── Lingkaran kecil bawah kanan ──────────────────────────────────
        Positioned(
          bottom: 100,
          right: -20,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success.withAlpha(20),
            ),
          ),
        ),

        // ─── Diamond shape ────────────────────────────────────────────────
        Positioned(
          bottom: 260,
          right: 60,
          child: Transform.rotate(
            angle: 0.785, // 45 derajat
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.warning.withAlpha(60),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Grid titik-titik dekoratif
class _DotGrid extends StatelessWidget {
  const _DotGrid({
    required this.rows,
    required this.cols,
    required this.color,
  });

  final int rows;
  final int cols;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rows, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(cols, (c) {
            return Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            );
          }),
        );
      }),
    );
  }
}

/// Custom painter untuk segitiga dekoratif
class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}
