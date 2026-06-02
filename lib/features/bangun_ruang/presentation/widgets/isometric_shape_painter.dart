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
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = w * 0.42;

    final Offset top         = Offset(cx, cy - r);
    final Offset topLeft     = Offset(cx - r * 0.866, cy - r * 0.5);
    final Offset bottomLeft  = Offset(cx - r * 0.866, cy + r * 0.5);
    final Offset bottom      = Offset(cx, cy + r);
    final Offset bottomRight = Offset(cx + r * 0.866, cy + r * 0.5);
    final Offset topRight    = Offset(cx + r * 0.866, cy - r * 0.5);
    final Offset center      = Offset(cx, cy);

    // Face Atas (Biru Muda)
    canvas.drawPath(
      Path()..moveTo(top.dx, top.dy)..lineTo(topLeft.dx, topLeft.dy)..lineTo(center.dx, center.dy)..lineTo(topRight.dx, topRight.dy)..close(),
      Paint()..color = const Color(0xFF64B5F6)..style = PaintingStyle.fill,
    );
    // Face Kiri (Biru Sedang)
    canvas.drawPath(
      Path()..moveTo(topLeft.dx, topLeft.dy)..lineTo(bottomLeft.dx, bottomLeft.dy)..lineTo(bottom.dx, bottom.dy)..lineTo(center.dx, center.dy)..close(),
      Paint()..color = const Color(0xFF1E88E5)..style = PaintingStyle.fill,
    );
    // Face Kanan (Biru Tua)
    canvas.drawPath(
      Path()..moveTo(center.dx, center.dy)..lineTo(bottom.dx, bottom.dy)..lineTo(bottomRight.dx, bottomRight.dy)..lineTo(topRight.dx, topRight.dy)..close(),
      Paint()..color = const Color(0xFF1565C0)..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// BALOK — isometrik memanjang horizontal
// ─────────────────────────────────────────────────────────────────────────────
class _Balok3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;

    // Proyeksi isometrik balok: lebar >> tinggi
    final double hw = w * 0.44;   // half-width (X isometrik)
    final double hd = h * 0.14;   // half-depth (Y isometrik atas)
    final double ht = h * 0.28;   // half-tinggi (Y vertikal)

    // 8 vertex balok diproyeksikan ke 2D isometrik
    // Top face: A(kiri-atas), B(kanan-atas), C(kanan-depan), D(kiri-depan)
    final Offset A = Offset(cx - hw * 0.3, cy - ht - hd);       // kiri-belakang-atas
    final Offset B = Offset(cx + hw * 0.7, cy - ht - hd * 0.3); // kanan-belakang-atas (digeser)
    final Offset C = Offset(cx + hw,       cy - ht + hd);        // kanan-depan-atas
    final Offset D = Offset(cx - hw * 0.3 + hw * 0.3, cy - ht + hd * 0.7); // kiri-depan-atas

    // Versi bottom (geser ke bawah sebesar 2*ht)
    final Offset A2 = Offset(A.dx, A.dy + ht * 2);
    final Offset B2 = Offset(B.dx, B.dy + ht * 2);
    final Offset C2 = Offset(C.dx, C.dy + ht * 2);
    final Offset D2 = Offset(D.dx, D.dy + ht * 2);

    // Face Atas (Ungu Muda)
    canvas.drawPath(
      Path()..moveTo(A.dx,A.dy)..lineTo(B.dx,B.dy)..lineTo(C.dx,C.dy)..lineTo(D.dx,D.dy)..close(),
      Paint()..color = const Color(0xFFCE93D8)..style = PaintingStyle.fill,
    );
    // Face Kiri (Ungu Sedang)
    canvas.drawPath(
      Path()..moveTo(A.dx,A.dy)..lineTo(D.dx,D.dy)..lineTo(D2.dx,D2.dy)..lineTo(A2.dx,A2.dy)..close(),
      Paint()..color = const Color(0xFF8E24AA)..style = PaintingStyle.fill,
    );
    // Face Depan / Kanan (Ungu Tua)
    canvas.drawPath(
      Path()..moveTo(D.dx,D.dy)..lineTo(C.dx,C.dy)..lineTo(C2.dx,C2.dy)..lineTo(D2.dx,D2.dy)..close(),
      Paint()..color = const Color(0xFF6A1B9A)..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// PRISMA SEGITIGA — tampak 3D proper
// ─────────────────────────────────────────────────────────────────────────────
class _PrismaSegitiga3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;

    // Titik-titik segitiga depan (alas depan prisma)
    final Offset frontTop   = Offset(cx, h * 0.15);          // puncak segitiga depan
    final Offset frontLeft  = Offset(w * 0.12, h * 0.82);    // bawah-kiri depan
    final Offset frontRight = Offset(w * 0.75, h * 0.82);    // bawah-kanan depan

    // Titik-titik segitiga belakang (offset ke kanan-atas untuk kedalaman)
    final double dx = w * 0.2;
    final double dy = -h * 0.08;
    final Offset backTop   = Offset(frontTop.dx + dx, frontTop.dy + dy);
    final Offset backLeft  = Offset(frontLeft.dx + dx, frontLeft.dy + dy);
    final Offset backRight = Offset(frontRight.dx + dx, frontRight.dy + dy);

    // Sisi kanan (gelap) — dari puncak ke kanan bawah, depan ke belakang
    canvas.drawPath(
      Path()..moveTo(frontTop.dx,frontTop.dy)..lineTo(backTop.dx,backTop.dy)..lineTo(backRight.dx,backRight.dy)..lineTo(frontRight.dx,frontRight.dy)..close(),
      Paint()..color = const Color(0xFF2E7D32)..style = PaintingStyle.fill,
    );

    // Sisi bawah / alas (sedang)
    canvas.drawPath(
      Path()..moveTo(frontLeft.dx,frontLeft.dy)..lineTo(frontRight.dx,frontRight.dy)..lineTo(backRight.dx,backRight.dy)..lineTo(backLeft.dx,backLeft.dy)..close(),
      Paint()..color = const Color(0xFF388E3C)..style = PaintingStyle.fill,
    );

    // Muka depan (terang)
    canvas.drawPath(
      Path()..moveTo(frontTop.dx,frontTop.dy)..lineTo(frontLeft.dx,frontLeft.dy)..lineTo(frontRight.dx,frontRight.dy)..close(),
      Paint()..color = const Color(0xFF66BB6A)..style = PaintingStyle.fill,
    );

    // Sisi atas / atap
    canvas.drawPath(
      Path()..moveTo(frontTop.dx,frontTop.dy)..lineTo(backTop.dx,backTop.dy)..lineTo(backLeft.dx,backLeft.dy)..lineTo(frontLeft.dx,frontLeft.dy)..close(),
      Paint()..color = const Color(0xFF81C784)..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// LIMAS SEGIEMPAT — 4 sisi segitiga + alas
// ─────────────────────────────────────────────────────────────────────────────
class _LimasSegiempat3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;

    final Offset apex  = Offset(cx, h * 0.1);           // puncak
    final Offset front = Offset(cx, h * 0.88);           // depan-bawah
    final Offset left  = Offset(w * 0.1, h * 0.65);      // kiri-bawah
    final Offset right = Offset(w * 0.9, h * 0.65);      // kanan-bawah
    final Offset back  = Offset(cx, h * 0.45);           // belakang-bawah (tersembunyi)

    // Alas (tersembunyi sebagian — gambil perspektif)
    canvas.drawPath(
      Path()..moveTo(left.dx,left.dy)..lineTo(front.dx,front.dy)..lineTo(right.dx,right.dy)..lineTo(back.dx,back.dy)..close(),
      Paint()..color = const Color(0xFFE65100)..style = PaintingStyle.fill,
    );

    // Sisi kiri (oranye cerah)
    canvas.drawPath(
      Path()..moveTo(apex.dx,apex.dy)..lineTo(left.dx,left.dy)..lineTo(front.dx,front.dy)..close(),
      Paint()..color = const Color(0xFFFFA726)..style = PaintingStyle.fill,
    );

    // Sisi kanan (oranye tua)
    canvas.drawPath(
      Path()..moveTo(apex.dx,apex.dy)..lineTo(front.dx,front.dy)..lineTo(right.dx,right.dy)..close(),
      Paint()..color = const Color(0xFFFB8C00)..style = PaintingStyle.fill,
    );

    // Sisi belakang kanan (lebih gelap)
    canvas.drawPath(
      Path()..moveTo(apex.dx,apex.dy)..lineTo(right.dx,right.dy)..lineTo(back.dx,back.dy)..close(),
      Paint()..color = const Color(0xFFE65100)..style = PaintingStyle.fill,
    );
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
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;

    final double rx = w * 0.38;     // jari-jari ellipse X
    final double ry = h * 0.13;     // jari-jari ellipse Y (kedalaman)
    final double topY    = h * 0.2;
    final double bottomY = h * 0.82;

    // Body (sisi silinder) — Teal sedang
    final Path body = Path()
      ..moveTo(cx - rx, topY)
      ..lineTo(cx - rx, bottomY)
      ..arcTo(
        Rect.fromCenter(center: Offset(cx, bottomY), width: rx * 2, height: ry * 2),
        math.pi, math.pi, false,
      )
      ..lineTo(cx + rx, topY)
      ..arcTo(
        Rect.fromCenter(center: Offset(cx, topY), width: rx * 2, height: ry * 2),
        0, math.pi, false,
      )
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFF26C6DA)..style = PaintingStyle.fill);

    // Sisi gelap kanan untuk efek 3D
    final Path shadow = Path()
      ..moveTo(cx, topY)
      ..lineTo(cx, bottomY)
      ..arcTo(
        Rect.fromCenter(center: Offset(cx, bottomY), width: rx * 2, height: ry * 2),
        0, math.pi, false,
      )
      ..lineTo(cx + rx, topY)
      ..arcTo(
        Rect.fromCenter(center: Offset(cx, topY), width: rx * 2, height: ry * 2),
        0, math.pi, false, // setengah
      )
      ..close();
    canvas.drawPath(shadow, Paint()..color = const Color(0xFF00ACC1)..style = PaintingStyle.fill);

    // Lingkaran bawah (bayangan)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, bottomY), width: rx * 2, height: ry * 2),
      Paint()..color = const Color(0xFF00838F)..style = PaintingStyle.fill,
    );

    // Lingkaran atas (highlight)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, topY), width: rx * 2, height: ry * 2),
      Paint()..color = const Color(0xFF80DEEA)..style = PaintingStyle.fill,
    );
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
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;

    final double rx = w * 0.40;
    final double ry = h * 0.12;
    final Offset apex = Offset(cx, h * 0.08);
    final double baseY = h * 0.80;

    // Sisi kiri (lebih terang)
    final Path leftSide = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(cx - rx, baseY)
      ..arcTo(
        Rect.fromCenter(center: Offset(cx, baseY), width: rx * 2, height: ry * 2),
        math.pi, math.pi, false,
      )
      ..close();
    canvas.drawPath(leftSide, Paint()..color = const Color(0xFFF48FB1)..style = PaintingStyle.fill);

    // Sisi kanan (lebih gelap)
    final Path rightSide = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(cx + rx, baseY)
      ..arcTo(
        Rect.fromCenter(center: Offset(cx, baseY), width: rx * 2, height: ry * 2),
        0, math.pi, false,
      )
      ..close();
    canvas.drawPath(rightSide, Paint()..color = const Color(0xFFE91E63)..style = PaintingStyle.fill);

    // Elips alas (gelap)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, baseY), width: rx * 2, height: ry * 2),
      Paint()..color = const Color(0xFFAD1457)..style = PaintingStyle.fill,
    );
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
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = math.min(w, h) * 0.44;

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
