import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Widget factory untuk merender CustomPainter bentuk 3D isometrik
Widget getShapeWidget(String bangunId, double size) {
  CustomPainter painter;
  switch (bangunId) {
    case 'br_kubus':
      painter = _Kubus3DPainter();
      break;
    case 'br_balok':
      painter = _Balok3DPainter();
      break;
    case 'br_prisma_segitiga':
      painter = _PrismaSegitiga3DPainter();
      break;
    case 'br_limas_segiempat':
      painter = _LimasSegiempat3DPainter();
      break;
    case 'br_tabung':
      painter = _Tabung3DPainter();
      break;
    case 'br_kerucut':
      painter = _Kerucut3DPainter();
      break;
    case 'br_bola':
      painter = _Bola3DPainter();
      break;
    default:
      painter = _Kubus3DPainter();
  }

  return CustomPaint(
    size: Size(size, size),
    painter: painter,
  );
}

class _Kubus3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;

    // Radius jarak ke titik ujung hex (isometric projection)
    final double r = w * 0.45;
    
    // Titik-titik heksagon isometrik
    final Offset center = Offset(cx, cy);
    final Offset top = Offset(cx, cy - r);
    final Offset bottom = Offset(cx, cy + r);
    final Offset topLeft = Offset(cx - r * 0.866, cy - r * 0.5);
    final Offset bottomLeft = Offset(cx - r * 0.866, cy + r * 0.5);
    final Offset topRight = Offset(cx + r * 0.866, cy - r * 0.5);
    final Offset bottomRight = Offset(cx + r * 0.866, cy + r * 0.5);

    // Face Atas (Biru Muda #64B5F6)
    final Path topPath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(topLeft.dx, topLeft.dy)
      ..lineTo(center.dx, center.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();
    canvas.drawPath(topPath, Paint()..color = const Color(0xFF64B5F6)..style = PaintingStyle.fill);

    // Face Kiri (Biru Sedang #1E88E5)
    final Path leftPath = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(center.dx, center.dy)
      ..close();
    canvas.drawPath(leftPath, Paint()..color = const Color(0xFF1E88E5)..style = PaintingStyle.fill);

    // Face Kanan (Biru Tua #1565C0)
    final Path rightPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();
    canvas.drawPath(rightPath, Paint()..color = const Color(0xFF1565C0)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Balok3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;

    // Proporsi isometrik balok (lebar x lebih panjang)
    final double rx = w * 0.45; 
    final double ry = h * 0.35;
    
    // Titik-titik balok isometrik (lebih memanjang ke kanan)
    final Offset center = Offset(cx - rx*0.2, cy + ry*0.2);
    final Offset top = Offset(cx - rx*0.2, cy - ry*0.8);
    final Offset bottom = Offset(cx - rx*0.2, cy + ry*1.2);
    
    final Offset topLeft = Offset(cx - rx * 0.9, cy - ry * 0.3);
    final Offset bottomLeft = Offset(cx - rx * 0.9, cy + ry * 0.7);
    
    final Offset topRight = Offset(cx + rx * 0.9, cy - ry * 0.3);
    final Offset bottomRight = Offset(cx + rx * 0.9, cy + ry * 0.7);

    // Hitung titik top face dengan benar
    final Offset topBack = Offset(cx + rx*0.2, cy - ry*1.2);

    // Face Atas (Ungu Muda #CE93D8)
    final Path topPath = Path()
      ..moveTo(topBack.dx, topBack.dy)
      ..lineTo(topLeft.dx, topLeft.dy)
      ..lineTo(top.dx, top.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();
    canvas.drawPath(topPath, Paint()..color = const Color(0xFFCE93D8)..style = PaintingStyle.fill);

    // Face Kiri (Ungu Sedang #8E24AA)
    final Path leftPath = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(top.dx, top.dy)
      ..close();
    canvas.drawPath(leftPath, Paint()..color = const Color(0xFF8E24AA)..style = PaintingStyle.fill);

    // Face Kanan (Ungu Tua #6A1B9A)
    final Path rightPath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();
    canvas.drawPath(rightPath, Paint()..color = const Color(0xFF6A1B9A)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PrismaSegitiga3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    
    final Offset topFront = Offset(w * 0.5, h * 0.2);
    final Offset topBackLeft = Offset(w * 0.2, h * 0.15);
    final Offset topBackRight = Offset(w * 0.8, h * 0.35);
    
    final Offset bottomFront = Offset(w * 0.5, h * 0.8);
    final Offset bottomBackLeft = Offset(w * 0.2, h * 0.75);
    final Offset bottomBackRight = Offset(w * 0.8, h * 0.95);

    // Atas (Hijau Muda)
    final Path topPath = Path()
      ..moveTo(topFront.dx, topFront.dy)
      ..lineTo(topBackLeft.dx, topBackLeft.dy)
      ..lineTo(topBackRight.dx, topBackRight.dy)
      ..close();
    canvas.drawPath(topPath, Paint()..color = const Color(0xFF81C784)..style = PaintingStyle.fill);

    // Kiri (Hijau Sedang)
    final Path leftPath = Path()
      ..moveTo(topBackLeft.dx, topBackLeft.dy)
      ..lineTo(bottomBackLeft.dx, bottomBackLeft.dy)
      ..lineTo(bottomFront.dx, bottomFront.dy)
      ..lineTo(topFront.dx, topFront.dy)
      ..close();
    canvas.drawPath(leftPath, Paint()..color = const Color(0xFF43A047)..style = PaintingStyle.fill);

    // Kanan (Hijau Tua)
    final Path rightPath = Path()
      ..moveTo(topFront.dx, topFront.dy)
      ..lineTo(bottomFront.dx, bottomFront.dy)
      ..lineTo(bottomBackRight.dx, bottomBackRight.dy)
      ..lineTo(topBackRight.dx, topBackRight.dy)
      ..close();
    canvas.drawPath(rightPath, Paint()..color = const Color(0xFF2E7D32)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LimasSegiempat3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    
    final Offset top = Offset(w * 0.5, h * 0.1);
    
    // Base points (isometrik)
    final Offset left = Offset(w * 0.2, h * 0.7);
    final Offset right = Offset(w * 0.8, h * 0.6);
    final Offset front = Offset(w * 0.5, h * 0.9);

    // Kiri (Oranye Sedang)
    final Path leftPath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(front.dx, front.dy)
      ..close();
    canvas.drawPath(leftPath, Paint()..color = const Color(0xFFFB8C00)..style = PaintingStyle.fill);

    // Kanan (Oranye Tua)
    final Path rightPath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(front.dx, front.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(rightPath, Paint()..color = const Color(0xFFEF6C00)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Tabung3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    
    final double cx = w / 2;
    final double rx = w * 0.35;
    final double ry = h * 0.15;
    
    final double topY = h * 0.25;
    final double bottomY = h * 0.75;

    // Body (Merah Muda Sedang)
    final Path bodyPath = Path()
      ..moveTo(cx - rx, topY)
      ..lineTo(cx - rx, bottomY)
      ..arcTo(Rect.fromCenter(center: Offset(cx, bottomY), width: rx * 2, height: ry * 2), math.pi, math.pi, false)
      ..lineTo(cx + rx, topY)
      ..arcTo(Rect.fromCenter(center: Offset(cx, topY), width: rx * 2, height: ry * 2), 0, math.pi, false)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFFD81B60)..style = PaintingStyle.fill);

    // Atap Ellipse (Merah Muda Terang)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, topY), width: rx * 2, height: ry * 2),
      Paint()..color = const Color(0xFFF06292)..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Kerucut3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    
    final double cx = w / 2;
    final double rx = w * 0.35;
    final double ry = h * 0.15;
    
    final Offset top = Offset(cx, h * 0.1);
    final double bottomY = h * 0.8;

    // Body (Pink dengan sedikit gradient/dua sisi warna untuk 3d)
    final Path leftBody = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(cx - rx, bottomY)
      ..arcTo(Rect.fromCenter(center: Offset(cx, bottomY), width: rx * 2, height: ry * 2), math.pi, math.pi/2, false)
      ..lineTo(top.dx, top.dy)
      ..close();
    canvas.drawPath(leftBody, Paint()..color = const Color(0xFFF06292)..style = PaintingStyle.fill);

    final Path rightBody = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(cx, bottomY + ry)
      ..arcTo(Rect.fromCenter(center: Offset(cx, bottomY), width: rx * 2, height: ry * 2), math.pi/2, math.pi/2, false)
      ..lineTo(top.dx, top.dy)
      ..close();
    canvas.drawPath(rightBody, Paint()..color = const Color(0xFFE91E63)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Bola3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = math.min(w, h) * 0.4;

    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          const Color(0xFF42A5F5), // Biru Muda
          const Color(0xFF1565C0), // Biru Tua
        ],
        stops: const [0.0, 0.4, 1.0],
        center: const Alignment(-0.3, -0.3),
        radius: 0.8,
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));

    canvas.drawCircle(Offset(cx, cy), r, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
