import 'dart:math' as math;
import 'package:flutter/material.dart';

class ShapeIcon extends StatelessWidget {
  const ShapeIcon({
    super.key,
    required this.shapeId,
    required this.color,
    this.size = 40.0,
  });

  final String shapeId;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: ShapeIconPainter(shapeId: shapeId, color: color),
      ),
    );
  }
}

class ShapeIconPainter extends CustomPainter {
  ShapeIconPainter({
    required this.shapeId,
    required this.color,
  });

  final String shapeId;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (shapeId) {
      case 'bd_persegi':
        drawPersegi(canvas, size, paint);
        break;
      case 'bd_persegi_panjang':
        drawPersegiPanjang(canvas, size, paint);
        break;
      case 'bd_segitiga':
        drawSegitiga(canvas, size, paint);
        break;
      case 'bd_jajargenjang':
        drawJajarGenjang(canvas, size, paint);
        break;
      case 'bd_trapesium':
        drawTrapesium(canvas, size, paint);
        break;
      case 'bd_layang':
        drawLayangLayang(canvas, size, paint);
        break;
      case 'bd_belah_ketupat':
        drawBelahKetupat(canvas, size, paint);
        break;
      case 'bd_lingkaran':
        drawLingkaran(canvas, size, paint);
        break;
      default:
        drawPersegi(canvas, size, paint);
    }
  }

  void drawPersegi(Canvas canvas, Size size, Paint paint) {
    final double side = math.min(size.width, size.height) * 0.8;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: side,
      height: side,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);
  }

  void drawPersegiPanjang(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.9,
      height: size.height * 0.6,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);
  }

  void drawSegitiga(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final double w = size.width * 0.9;
    final double h = size.height * 0.85;
    final cx = size.width / 2;
    final cy = size.height / 2;

    path.moveTo(cx, cy - h / 2); // Top
    path.lineTo(cx - w / 2, cy + h / 2); // Bottom left
    path.lineTo(cx + w / 2, cy + h / 2); // Bottom right
    path.close();

    canvas.drawPath(path, paint);
  }

  void drawJajarGenjang(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final double w = size.width * 0.85;
    final double h = size.height * 0.65;
    final double skew = size.width * 0.2;
    final cx = size.width / 2;
    final cy = size.height / 2;

    path.moveTo(cx - w / 2 + skew, cy - h / 2);
    path.lineTo(cx + w / 2, cy - h / 2);
    path.lineTo(cx + w / 2 - skew, cy + h / 2);
    path.lineTo(cx - w / 2, cy + h / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  void drawTrapesium(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final double topW = size.width * 0.5;
    final double botW = size.width * 0.9;
    final double h = size.height * 0.65;
    final cx = size.width / 2;
    final cy = size.height / 2;

    path.moveTo(cx - topW / 2, cy - h / 2);
    path.lineTo(cx + topW / 2, cy - h / 2);
    path.lineTo(cx + botW / 2, cy + h / 2);
    path.lineTo(cx - botW / 2, cy + h / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  void drawLayangLayang(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final double w = size.width * 0.8;
    final double h = size.height * 0.9;
    final cx = size.width / 2;
    final cy = size.height / 2;

    path.moveTo(cx, cy - h / 2); // Top
    path.lineTo(cx + w / 2, cy - h / 6); // Right
    path.lineTo(cx, cy + h / 2); // Bottom
    path.lineTo(cx - w / 2, cy - h / 6); // Left
    path.close();

    canvas.drawPath(path, paint);
  }

  void drawBelahKetupat(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final double w = size.width * 0.85;
    final double h = size.height * 0.85;
    final cx = size.width / 2;
    final cy = size.height / 2;

    path.moveTo(cx, cy - h / 2);       // Top
    path.lineTo(cx + w / 2, cy);       // Right
    path.lineTo(cx, cy + h / 2);       // Bottom
    path.lineTo(cx - w / 2, cy);       // Left
    path.close();

    canvas.drawPath(path, paint);
  }

  void drawLingkaran(Canvas canvas, Size size, Paint paint) {
    final double r = math.min(size.width, size.height) / 2 * 0.85;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), r, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
