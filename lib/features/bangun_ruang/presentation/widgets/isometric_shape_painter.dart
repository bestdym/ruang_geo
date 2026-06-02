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

// ─────────────────────────────────────────────────────────────────────────────
// KUBUS — isometrik heksagon sempurna
// ─────────────────────────────────────────────────────────────────────────────
class _Kubus3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2 + size.height * 0.05;
    final double r = size.width * 0.28;

    Offset v(double x, double y, double z) =>
        Offset(cx + (x - z) * 0.866, cy + (x + z) * 0.5 - y);

    final pTop1 = v(r, r, r);
    final pTop2 = v(r, r, -r);
    final pTop3 = v(-r, r, -r);
    final pTop4 = v(-r, r, r);

    final pBot1 = v(r, -r, r);
    final pBot2 = v(r, -r, -r);
    final pBot4 = v(-r, -r, r);

    canvas.drawPath(Path()..moveTo(pTop1.dx, pTop1.dy)..lineTo(pTop2.dx, pTop2.dy)..lineTo(pTop3.dx, pTop3.dy)..lineTo(pTop4.dx, pTop4.dy)..close(), Paint()..color = const Color(0xFF64B5F6));
    canvas.drawPath(Path()..moveTo(pTop1.dx, pTop1.dy)..lineTo(pTop4.dx, pTop4.dy)..lineTo(pBot4.dx, pBot4.dy)..lineTo(pBot1.dx, pBot1.dy)..close(), Paint()..color = const Color(0xFF1E88E5));
    canvas.drawPath(Path()..moveTo(pTop1.dx, pTop1.dy)..lineTo(pTop2.dx, pTop2.dy)..lineTo(pBot2.dx, pBot2.dy)..lineTo(pBot1.dx, pBot1.dy)..close(), Paint()..color = const Color(0xFF1565C0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// BALOK — isometrik memanjang
// ─────────────────────────────────────────────────────────────────────────────
class _Balok3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2 + size.height * 0.05;
    final double l = size.width * 0.38;
    final double d = size.width * 0.22;
    final double t = size.width * 0.22;

    Offset v(double x, double y, double z) =>
        Offset(cx + (x - z) * 0.866, cy + (x + z) * 0.5 - y);

    final pTop1 = v(l, t, d);
    final pTop2 = v(l, t, -d);
    final pTop3 = v(-l, t, -d);
    final pTop4 = v(-l, t, d);

    final pBot1 = v(l, -t, d);
    final pBot2 = v(l, -t, -d);
    final pBot4 = v(-l, -t, d);

    canvas.drawPath(Path()..moveTo(pTop1.dx, pTop1.dy)..lineTo(pTop2.dx, pTop2.dy)..lineTo(pTop3.dx, pTop3.dy)..lineTo(pTop4.dx, pTop4.dy)..close(), Paint()..color = const Color(0xFFCE93D8));
    canvas.drawPath(Path()..moveTo(pTop1.dx, pTop1.dy)..lineTo(pTop4.dx, pTop4.dy)..lineTo(pBot4.dx, pBot4.dy)..lineTo(pBot1.dx, pBot1.dy)..close(), Paint()..color = const Color(0xFF8E24AA));
    canvas.drawPath(Path()..moveTo(pTop1.dx, pTop1.dy)..lineTo(pTop2.dx, pTop2.dy)..lineTo(pBot2.dx, pBot2.dy)..lineTo(pBot1.dx, pBot1.dy)..close(), Paint()..color = const Color(0xFF6A1B9A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// PRISMA SEGITIGA — prisma tegak segitiga isometrik proper
// ─────────────────────────────────────────────────────────────────────────────
class _PrismaSegitiga3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2 + size.height * 0.05;
    final double l = size.width * 0.32;
    final double d = size.width * 0.25;
    final double t = size.width * 0.32;

    Offset v(double x, double y, double z) =>
        Offset(cx + (x - z) * 0.866, cy + (x + z) * 0.5 - y);

    final pTop1 = v(-l, t, d);
    final pTop2 = v(l, t, d);
    final pTop3 = v(0, t, -d);

    final pBot1 = v(-l, -t, d);
    final pBot2 = v(l, -t, d);
    final pBot3 = v(0, -t, -d);

    // Top
    canvas.drawPath(Path()..moveTo(pTop1.dx, pTop1.dy)..lineTo(pTop2.dx, pTop2.dy)..lineTo(pTop3.dx, pTop3.dy)..close(), Paint()..color = const Color(0xFF81C784));
    // Left
    canvas.drawPath(Path()..moveTo(pTop1.dx, pTop1.dy)..lineTo(pTop2.dx, pTop2.dy)..lineTo(pBot2.dx, pBot2.dy)..lineTo(pBot1.dx, pBot1.dy)..close(), Paint()..color = const Color(0xFF43A047));
    // Right
    canvas.drawPath(Path()..moveTo(pTop2.dx, pTop2.dy)..lineTo(pTop3.dx, pTop3.dy)..lineTo(pBot3.dx, pBot3.dy)..lineTo(pBot2.dx, pBot2.dy)..close(), Paint()..color = const Color(0xFF2E7D32));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// LIMAS SEGIEMPAT — isometrik proper 
// ─────────────────────────────────────────────────────────────────────────────
class _LimasSegiempat3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2 + size.height * 0.15;
    final double l = size.width * 0.35;
    final double d = size.width * 0.35;
    final double t = size.width * 0.45;

    Offset v(double x, double y, double z) =>
        Offset(cx + (x - z) * 0.866, cy + (x + z) * 0.5 - y);

    final apex = v(0, t, 0);
    final p1 = v(l, -t, d);   // Front
    final p2 = v(l, -t, -d);  // Right
    final p4 = v(-l, -t, d);  // Left

    // Left Face (Oranye Cerah)
    canvas.drawPath(Path()..moveTo(apex.dx, apex.dy)..lineTo(p4.dx, p4.dy)..lineTo(p1.dx, p1.dy)..close(), Paint()..color = const Color(0xFFFFA726));
    // Right Face (Oranye Tua)
    canvas.drawPath(Path()..moveTo(apex.dx, apex.dy)..lineTo(p1.dx, p1.dy)..lineTo(p2.dx, p2.dy)..close(), Paint()..color = const Color(0xFFFB8C00));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// TABUNG — silinder teal proper dengan ellipse atas-bawah
// ─────────────────────────────────────────────────────────────────────────────
class _Tabung3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double rx = size.width * 0.35;
    final double ry = size.height * 0.12;
    final double topY = size.height * 0.25;
    final double bottomY = size.height * 0.75;

    final Path body = Path()
      ..moveTo(cx - rx, topY)
      ..lineTo(cx - rx, bottomY)
      ..arcTo(Rect.fromCenter(center: Offset(cx, bottomY), width: rx * 2, height: ry * 2), math.pi, math.pi, false)
      ..lineTo(cx + rx, topY)
      ..arcTo(Rect.fromCenter(center: Offset(cx, topY), width: rx * 2, height: ry * 2), 0, math.pi, false)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFF26C6DA)..style = PaintingStyle.fill);

    final Path shadow = Path()
      ..moveTo(cx, topY)
      ..lineTo(cx, bottomY)
      ..arcTo(Rect.fromCenter(center: Offset(cx, bottomY), width: rx * 2, height: ry * 2), 0, math.pi, false)
      ..lineTo(cx + rx, topY)
      ..arcTo(Rect.fromCenter(center: Offset(cx, topY), width: rx * 2, height: ry * 2), 0, math.pi, false)
      ..close();
    canvas.drawPath(shadow, Paint()..color = const Color(0xFF00ACC1)..style = PaintingStyle.fill);

    canvas.drawOval(Rect.fromCenter(center: Offset(cx, bottomY), width: rx * 2, height: ry * 2), Paint()..color = const Color(0xFF00838F)..style = PaintingStyle.fill);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, topY), width: rx * 2, height: ry * 2), Paint()..color = const Color(0xFF80DEEA)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// KERUCUT — cone pink proper dengan ellipse alas
// ─────────────────────────────────────────────────────────────────────────────
class _Kerucut3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double rx = size.width * 0.38;
    final double ry = size.height * 0.12;
    final Offset apex = Offset(cx, size.height * 0.15);
    final double baseY = size.height * 0.78;

    final Path leftSide = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(cx - rx, baseY)
      ..arcTo(Rect.fromCenter(center: Offset(cx, baseY), width: rx * 2, height: ry * 2), math.pi, math.pi, false)
      ..close();
    canvas.drawPath(leftSide, Paint()..color = const Color(0xFFF48FB1)..style = PaintingStyle.fill);

    final Path rightSide = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(cx + rx, baseY)
      ..arcTo(Rect.fromCenter(center: Offset(cx, baseY), width: rx * 2, height: ry * 2), 0, math.pi, false)
      ..close();
    canvas.drawPath(rightSide, Paint()..color = const Color(0xFFE91E63)..style = PaintingStyle.fill);

    canvas.drawOval(Rect.fromCenter(center: Offset(cx, baseY), width: rx * 2, height: ry * 2), Paint()..color = const Color(0xFFAD1457)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// BOLA — radial gradient biru 3D
// ─────────────────────────────────────────────────────────────────────────────
class _Bola3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = math.min(size.width, size.height) * 0.42;

    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white,
            const Color(0xFF42A5F5),
            const Color(0xFF1565C0),
          ],
          stops: const [0.0, 0.45, 1.0],
          center: const Alignment(-0.35, -0.35),
          radius: 0.85,
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
