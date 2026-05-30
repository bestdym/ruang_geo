import 'dart:math' as math;
import 'package:flutter/material.dart';

class JaringJaringViewer extends StatelessWidget {
  final String bangunId;
  final Color color;

  const JaringJaringViewer({
    super.key,
    required this.bangunId,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 120),
      painter: _JaringJaringPainter(bangunId: bangunId, color: color),
    );
  }
}

class _JaringJaringPainter extends CustomPainter {
  final String bangunId;
  final Color color;

  _JaringJaringPainter({
    required this.bangunId,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final paintFill = Paint()
      ..color = color.withAlpha(50)
      ..style = PaintingStyle.fill;
    
    final paintStroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    void drawPoly(List<Offset> points) {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
      canvas.drawPath(path, paintFill);
      canvas.drawPath(path, paintStroke);
    }

    void drawRectCenter(double x, double y, double w, double h) {
      final rect = Rect.fromCenter(center: Offset(x, y), width: w, height: h);
      canvas.drawRect(rect, paintFill);
      canvas.drawRect(rect, paintStroke);
    }

    switch (bangunId) {
      case 'br_kubus':
        // Jaring-jaring kubus (bentuk salib)
        double s = 25;
        // Tengah vertikal
        drawRectCenter(cx, cy - s, s, s);
        drawRectCenter(cx, cy, s, s);
        drawRectCenter(cx, cy + s, s, s);
        drawRectCenter(cx, cy + 2 * s, s, s);
        // Sayap kiri kanan (pada kotak ke-2)
        drawRectCenter(cx - s, cy, s, s);
        drawRectCenter(cx + s, cy, s, s);
        break;

      case 'br_balok':
        // Jaring-jaring balok
        double w = 30; // lebar
        double h = 20; // tinggi
        double d = 15; // kedalaman
        
        // Tengah vertikal
        drawRectCenter(cx, cy - (h+d)/2, w, d); // tutup
        drawRectCenter(cx, cy, w, h); // depan
        drawRectCenter(cx, cy + (h+d)/2, w, d); // alas
        drawRectCenter(cx, cy + h + d, w, h); // belakang
        
        // Sayap kiri kanan
        drawRectCenter(cx - (w+d)/2, cy, d, h); // kiri
        drawRectCenter(cx + (w+d)/2, cy, d, h); // kanan
        break;

      case 'br_prisma_segitiga':
        // 3 persegi panjang + 2 segitiga
        double w = 25;
        double h = 40;
        double th = 15; // tinggi segitiga
        
        // 3 persegi panjang
        drawRectCenter(cx - w, cy, w, h);
        drawRectCenter(cx, cy, w, h);
        drawRectCenter(cx + w, cy, w, h);
        
        // Segitiga atas & bawah di kotak tengah
        drawPoly([
          Offset(cx - w/2, cy - h/2),
          Offset(cx + w/2, cy - h/2),
          Offset(cx, cy - h/2 - th)
        ]);
        drawPoly([
          Offset(cx - w/2, cy + h/2),
          Offset(cx + w/2, cy + h/2),
          Offset(cx, cy + h/2 + th)
        ]);
        break;

      case 'br_limas_segiempat':
        // 1 persegi di tengah + 4 segitiga
        double s = 30;
        double th = 25; // tinggi segitiga

        drawRectCenter(cx, cy, s, s);
        
        // Atas
        drawPoly([Offset(cx - s/2, cy - s/2), Offset(cx + s/2, cy - s/2), Offset(cx, cy - s/2 - th)]);
        // Bawah
        drawPoly([Offset(cx - s/2, cy + s/2), Offset(cx + s/2, cy + s/2), Offset(cx, cy + s/2 + th)]);
        // Kiri
        drawPoly([Offset(cx - s/2, cy - s/2), Offset(cx - s/2, cy + s/2), Offset(cx - s/2 - th, cy)]);
        // Kanan
        drawPoly([Offset(cx + s/2, cy - s/2), Offset(cx + s/2, cy + s/2), Offset(cx + s/2 + th, cy)]);
        break;

      case 'br_tabung':
        // 1 persegi panjang besar + 2 lingkaran
        double r = 15;
        double w = 2 * math.pi * r;
        double h = 40;

        drawRectCenter(cx, cy, w, h);
        
        // Lingkaran atas & bawah
        canvas.drawCircle(Offset(cx, cy - h/2 - r), r, paintFill);
        canvas.drawCircle(Offset(cx, cy - h/2 - r), r, paintStroke);
        
        canvas.drawCircle(Offset(cx, cy + h/2 + r), r, paintFill);
        canvas.drawCircle(Offset(cx, cy + h/2 + r), r, paintStroke);
        break;

      case 'br_kerucut':
        // 1 juring lingkaran besar + 1 lingkaran kecil
        double r = 15; // Jari-jari alas
        double s = 45; // Garis pelukis
        
        // Sudut juring (dalam radian)
        double theta = (r / s) * 2 * math.pi;
        
        final rect = Rect.fromCircle(center: Offset(cx, cy + s/2), radius: s);
        final path = Path();
        path.moveTo(cx, cy + s/2);
        path.arcTo(rect, -math.pi/2 - theta/2, theta, false);
        path.close();
        
        canvas.drawPath(path, paintFill);
        canvas.drawPath(path, paintStroke);

        // Lingkaran alas
        canvas.drawCircle(Offset(cx, cy + s/2 - s - r), r, paintFill);
        canvas.drawCircle(Offset(cx, cy + s/2 - s - r), r, paintStroke);
        break;

      case 'br_bola':
        // Bola direpresentasikan dengan "goresan" (map projection)
        // Kita gambar beberapa bentuk perahu menyambung
        int gores = 6;
        double w = 80;
        double h = 60;
        double gw = w / gores;
        for (int i = 0; i < gores; i++) {
          final path = Path();
          double startX = cx - w/2 + i * gw;
          path.moveTo(startX + gw/2, cy - h/2);
          path.quadraticBezierTo(startX + gw, cy, startX + gw/2, cy + h/2);
          path.quadraticBezierTo(startX, cy, startX + gw/2, cy - h/2);
          
          canvas.drawPath(path, paintFill);
          canvas.drawPath(path, paintStroke);
        }
        break;

      default:
        // Text fallback
        final textPainter = TextPainter(
          text: TextSpan(
            text: 'Jaring-jaring tidak tersedia',
            style: TextStyle(color: color, fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(cx - textPainter.width / 2, cy - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _JaringJaringPainter oldDelegate) {
    return oldDelegate.bangunId != bangunId;
  }
}
