import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WIDGET UTAMA (WRAPPER JARING-JARING)
// ─────────────────────────────────────────────────────────────────────────────

class JaringWidget extends StatefulWidget {
  const JaringWidget({
    super.key,
    required this.bangunId,
  });

  final String bangunId;

  @override
  State<JaringWidget> createState() => _JaringWidgetState();
}

class _JaringWidgetState extends State<JaringWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFolded = false;

  @override
  void initState() {
    super.initState();
    // Durasi animasi: 2.5 detik
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_isFolded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isFolded = !_isFolded;
    });
  }

  void _resetAnimation() {
    _controller.reset();
    setState(() {
      _isFolded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Area Gambar Animasi
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, double.infinity),
                  painter: _getPainter(widget.bangunId, _controller.value),
                );
              },
            ),
          ),
        ),

        // Kontrol & Keterangan
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(20),
            border: Border(top: BorderSide(color: Colors.white.withAlpha(50))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Keterangan Warna
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _ColorLegend(color: Colors.purple.shade400, label: 'Alas/Depan'),
                  _ColorLegend(color: Colors.red.shade400, label: 'Atas'),
                  _ColorLegend(color: Colors.green.shade400, label: 'Bawah'),
                  _ColorLegend(color: Colors.blue.shade400, label: 'Sisi 1'),
                  _ColorLegend(color: Colors.orange.shade400, label: 'Sisi 2'),
                  _ColorLegend(color: Colors.yellow.shade600, label: 'Sisi 3/Tutup'),
                ],
              ),
              const SizedBox(height: 16),
              // Tombol
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _resetAnimation,
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                    label: Text(
                      'Reset',
                      style: AppTypography.labelMedium.copyWith(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withAlpha(100)),
                      foregroundColor: Colors.white.withAlpha(100),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _toggleAnimation,
                    icon: Icon(
                      _isFolded ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    ),
                    label: Text(
                      _isFolded ? 'Buka Jaring' : 'Lipat Bangun',
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  CustomPainter _getPainter(String id, double progress) {
    switch (id) {
      case 'br_kubus':
        return JaringKubusPainter(progress: progress);
      case 'br_balok':
        return JaringBalokPainter(progress: progress);
      case 'br_prisma_segitiga':
        return JaringPrismaPainter(progress: progress);
      case 'br_limas_segiempat':
        return JaringLimasPainter(progress: progress);
      case 'br_tabung':
        return JaringTabungPainter(progress: progress);
      case 'br_kerucut':
        return JaringKerucutPainter(progress: progress);
      case 'br_bola':
        return JaringBolaPainter(progress: progress);
      default:
        return JaringKubusPainter(progress: progress);
    }
  }
}

class _ColorLegend extends StatelessWidget {
  const _ColorLegend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BASE MATRIX EXTENSION UNTUK FOLDING 3D
// ─────────────────────────────────────────────────────────────────────────────

extension CanvasTransformExt on Canvas {
  /// Menggambar bidang dengan pivot dan rotasi sumbu lokal
  /// foldAngle = 0 (datar), math.pi/2 (tegak 90 derajat)
  void drawFace({
    required Offset globalPivot,
    required Offset pivot,
    required double foldAngle,
    required bool isAxisX,
    required VoidCallback drawCallback,
    double extraRotZ = 0,
    double globalTiltX = 0, // Untuk perspektif dasar
    double globalTiltZ = 0,
  }) {
    save();
    
    // Matriks dasar dengan perspektif
    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.0015); // Perspective

    // Global tilt untuk melihat bangun dari sudut miring isometrik
    matrix.translate(globalPivot.dx, globalPivot.dy, 0.0);
    matrix.rotateX(globalTiltX);
    matrix.rotateZ(globalTiltZ);
    matrix.translate(-globalPivot.dx, -globalPivot.dy, 0.0);

    // Translasi ke titik pivot, putar, lalu kembali
    matrix.translate(pivot.dx, pivot.dy, 0.0);
    
    if (isAxisX) {
      matrix.rotateX(foldAngle);
    } else {
      matrix.rotateY(foldAngle);
    }
    
    if (extraRotZ != 0) {
      matrix.rotateZ(extraRotZ);
    }

    matrix.translate(-pivot.dx, -pivot.dy, 0.0);
    
    transform(matrix.storage);
    drawCallback();
    restore();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. KUBUS
// ─────────────────────────────────────────────────────────────────────────────

class JaringKubusPainter extends CustomPainter {
  JaringKubusPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    // Ukuran satu sisi persegi
    final s = math.min(size.width, size.height) * 0.25;
    
    // Global tilt saat sedang melipat agar terlihat 3D
    // Saat progress 0 (terbuka), tilt = 0 (datar)
    // Saat progress 1 (terlipat), tilt X dan Z miring agar terlihat bentuk 3D
    final tiltX = progress * (math.pi / 5);
    final tiltZ = progress * (math.pi / 8);

    // Sudut lipat masing-masing (90 derajat = pi/2)
    final fold = progress * (-math.pi / 2); // Negatif karena kita melipat "ke dalam/belakang" z

    void drawFaceRect(Color c, Offset center) {
      final rect = Rect.fromCenter(center: center, width: s, height: s);
      canvas.drawRect(rect, Paint()..color = c..style = PaintingStyle.fill);
      canvas.drawRect(rect, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);
    }

    // Posisikan kubus sedikit lebih ke atas/kiri agar saat dilipat ada di tengah
    final offsetX = cx;
    final offsetY = cy;

    // URUTAN MENGGAMBAR: Paling jauh ke paling dekat (Painter's Algorithm)
    // Melipat ke arah DALAM layar (Z positif), sehingga SISI DEPAN adalah sisi yang paling dekat dengan kita
    
    // 1. SISI BELAKANG (Kuning - Paling jauh)
    canvas.save();
    final matrix = Matrix4.identity()..setEntry(3, 2, 0.0015);
    matrix.translate(offsetX, offsetY);
    matrix.rotateX(tiltX);
    matrix.rotateZ(tiltZ);
    matrix.translate(-offsetX, -offsetY);
    
    // Pertama, pindah ke engsel KANAN
    matrix.translate(offsetX + s/2, offsetY);
    // Putar sisi kanan ke dalam layar
    matrix.rotateY(fold);
    // Maju ke engsel luar sisi kanan
    matrix.translate(s, 0.0);
    // Putar sisi belakang sejajar dengan depan
    matrix.rotateY(fold);
    // Kembalikan anchor untuk menggambar
    matrix.translate(-(offsetX + s + s/2), -offsetY);
    
    canvas.transform(matrix.storage);
    drawFaceRect(Colors.yellow.shade600, Offset(offsetX + s * 2, offsetY));
    canvas.restore();

    // 2. SISI BAWAH (Hijau)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX, offsetY + s / 2),
      foldAngle: -fold, // Lipat ke dalam
      isAxisX: true,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.green.shade400, Offset(offsetX, offsetY + s)),
    );

    // 3. SISI KANAN (Oranye)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX + s / 2, offsetY),
      foldAngle: fold, // Lipat ke dalam
      isAxisX: false,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.orange.shade400, Offset(offsetX + s, offsetY)),
    );

    // 4. SISI ATAS (Merah)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX, offsetY - s / 2),
      foldAngle: fold, // Lipat ke dalam
      isAxisX: true,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.red.shade400, Offset(offsetX, offsetY - s)),
    );

    // 5. SISI KIRI (Biru)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX - s / 2, offsetY),
      foldAngle: -fold, // Lipat ke dalam
      isAxisX: false,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.blue.shade400, Offset(offsetX - s, offsetY)),
    );

    // 6. SISI DEPAN (Ungu - Paling dekat)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX, offsetY),
      foldAngle: 0,
      isAxisX: true,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.purple.shade400, Offset(offsetX, offsetY)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. BALOK
// ─────────────────────────────────────────────────────────────────────────────

class JaringBalokPainter extends CustomPainter {
  JaringBalokPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    // Ukuran balok
    final w = size.width * 0.4;  // lebar (X)
    final h = size.height * 0.2; // tinggi (Y)
    final d = size.width * 0.2;  // kedalaman (Z, yang dilipat)

    final tiltX = progress * (math.pi / 5);
    final tiltZ = progress * (math.pi / 8);
    final fold = progress * (-math.pi / 2);

    void drawFaceRect(Color c, Offset center, double width, double height) {
      final rect = Rect.fromCenter(center: center, width: width, height: height);
      canvas.drawRect(rect, Paint()..color = c..style = PaintingStyle.fill);
      canvas.drawRect(rect, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);
    }

    final offsetX = cx;
    final offsetY = cy;

    // URUTAN MENGGAMBAR: Paling jauh ke paling dekat (Painter's Algorithm)
    // Melipat ke arah DALAM layar (Z positif), sehingga SISI DEPAN adalah sisi yang paling dekat dengan kita

    // 1. SISI BELAKANG (Kuning - Paling jauh)
    canvas.save();
    final matrix = Matrix4.identity()..setEntry(3, 2, 0.0015);
    matrix.translate(offsetX, offsetY);
    matrix.rotateX(tiltX);
    matrix.rotateZ(tiltZ);
    matrix.translate(-offsetX, -offsetY);
    
    // Ke engsel kanan (W/2)
    matrix.translate(offsetX + w/2, offsetY);
    // Putar sisi kanan ke dalam
    matrix.rotateY(fold);
    // Maju selebar sisi kanan (D)
    matrix.translate(d, 0.0);
    // Putar sisi belakang sejajar dengan depan
    matrix.rotateY(fold);
    // Kembalikan
    matrix.translate(-(offsetX + w/2 + d + w/2), -offsetY);
    
    canvas.transform(matrix.storage);
    drawFaceRect(Colors.yellow.shade600, Offset(offsetX + w + d, offsetY), w, h);
    canvas.restore();

    // 2. SISI BAWAH (Hijau)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX, offsetY + h / 2),
      foldAngle: -fold, // Lipat ke dalam
      isAxisX: true,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.green.shade400, Offset(offsetX, offsetY + h/2 + d/2), w, d),
    );

    // 3. SISI KANAN (Oranye)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX + w / 2, offsetY),
      foldAngle: fold, // Lipat ke dalam
      isAxisX: false,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.orange.shade400, Offset(offsetX + w/2 + d/2, offsetY), d, h),
    );

    // 4. SISI ATAS (Merah)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX, offsetY - h / 2),
      foldAngle: fold, // Lipat ke dalam
      isAxisX: true,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.red.shade400, Offset(offsetX, offsetY - h/2 - d/2), w, d),
    );

    // 5. SISI KIRI (Biru)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX - w / 2, offsetY),
      foldAngle: -fold, // Lipat ke dalam
      isAxisX: false,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.blue.shade400, Offset(offsetX - w/2 - d/2, offsetY), d, h),
    );

    // 6. SISI DEPAN (Ungu - Paling dekat)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX, offsetY),
      foldAngle: 0,
      isAxisX: true,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.purple.shade400, Offset(offsetX, offsetY), w, h),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. LIMAS SEGIEMPAT
// ─────────────────────────────────────────────────────────────────────────────

class JaringLimasPainter extends CustomPainter {
  JaringLimasPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    // Ukuran alas persegi
    final s = math.min(size.width, size.height) * 0.3;
    // Tinggi segitiga sisi (sisi miring)
    final st = s * 0.9;
    
    // Sudut maksimum saat melipat (membentuk limas tertutup)
    // Sudut antara bidang alas dan sisi tegak = acos((s/2) / st)
    // Karena segitiga dimulai dari posisi datar (terbuka 180 derajat dari pusat),
    // maka sudut putarnya adalah 180 - sudut_dalam
    final maxFold = math.pi - math.acos((s / 2) / st);
    final fold = progress * (-maxFold);
    
    // Miringkan alas agar terlihat 3D menghadap atas (Isometric View)
    final tiltZ = progress * (math.pi / 4);  // Putar alas jadi belah ketupat
    final tiltX = progress * (-math.pi / 3); // Miringkan ke atas agar puncak terlihat tinggi

    void drawAlas() {
      final rect = Rect.fromCenter(center: Offset(cx, cy), width: s, height: s);
      canvas.drawRect(rect, Paint()..color = Colors.purple.shade400..style = PaintingStyle.fill);
      canvas.drawRect(rect, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);
    }

    void drawTriangle(Color c, Offset pivot, {bool isTop = false, bool isBottom = false, bool isLeft = false, bool isRight = false}) {
      final path = Path();
      if (isTop) {
        path.moveTo(pivot.dx - s/2, pivot.dy);
        path.lineTo(pivot.dx + s/2, pivot.dy);
        path.lineTo(pivot.dx, pivot.dy - st); // puncak atas
      } else if (isBottom) {
        path.moveTo(pivot.dx - s/2, pivot.dy);
        path.lineTo(pivot.dx + s/2, pivot.dy);
        path.lineTo(pivot.dx, pivot.dy + st); // puncak bawah
      } else if (isRight) {
        path.moveTo(pivot.dx, pivot.dy - s/2);
        path.lineTo(pivot.dx, pivot.dy + s/2);
        path.lineTo(pivot.dx + st, pivot.dy); // puncak kanan
      } else if (isLeft) {
        path.moveTo(pivot.dx, pivot.dy - s/2);
        path.lineTo(pivot.dx, pivot.dy + s/2);
        path.lineTo(pivot.dx - st, pivot.dy); // puncak kiri
      }
      path.close();
      canvas.drawPath(path, Paint()..color = c..style = PaintingStyle.fill);
      canvas.drawPath(path, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);
    }

    // URUTAN MENGGAMBAR SANGAT PENTING (Z-Sorting)
    
    // SISI ATAS (Sisi Belakang Kanan saat dilipat isometric)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(cx, cy - s/2), foldAngle: -fold, isAxisX: true, globalTiltX: tiltX, globalTiltZ: tiltZ,
      drawCallback: () => drawTriangle(Colors.red.shade400, Offset(cx, cy - s/2), isTop: true),
    );

    // SISI KIRI (Sisi Belakang Kiri saat dilipat isometric)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(cx - s/2, cy), foldAngle: fold, isAxisX: false, globalTiltX: tiltX, globalTiltZ: tiltZ,
      drawCallback: () => drawTriangle(Colors.blue.shade400, Offset(cx - s/2, cy), isLeft: true),
    );

    // ALAS (Tengah)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(cx, cy), foldAngle: 0, isAxisX: true, globalTiltX: tiltX, globalTiltZ: tiltZ,
      drawCallback: () => drawAlas(),
    );

    // SISI BAWAH (Sisi Depan Kiri saat dilipat isometric)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(cx, cy + s/2), foldAngle: fold, isAxisX: true, globalTiltX: tiltX, globalTiltZ: tiltZ,
      drawCallback: () => drawTriangle(Colors.green.shade400, Offset(cx, cy + s/2), isBottom: true),
    );

    // SISI KANAN (Sisi Depan Kanan saat dilipat isometric)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(cx + s/2, cy), foldAngle: -fold, isAxisX: false, globalTiltX: tiltX, globalTiltZ: tiltZ,
      drawCallback: () => drawTriangle(Colors.orange.shade400, Offset(cx + s/2, cy), isRight: true),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3.B. PRISMA SEGITIGA
// ─────────────────────────────────────────────────────────────────────────────
class JaringPrismaPainter extends CustomPainter {
  JaringPrismaPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Dimensi prisma (berdiri tegak)
    final w = size.width * 0.25; // Lebar sisi tegak (sisi segitiga alas)
    final h = size.height * 0.35; // Tinggi prisma
    final hTri = w * math.sqrt(3) / 2; // Tinggi segitiga tutup

    // Sudut lipat (Melipat ke arah DALAM layar / Z positif)
    // Segitiga tutup atas & bawah melipat 90 derajat ke dalam
    final foldCap = progress * (math.pi / 2); 
    // Persegi panjang sisi kiri & kanan melipat 120 derajat ke dalam (karena sudut dalam segitiga 60 derajat)
    final foldSide = progress * (math.pi * 2 / 3); 

    // Perspektif global
    final tiltX = progress * (math.pi / 6); // Tilt ke bawah
    final tiltZ = progress * (math.pi / 8); // Putar miring

    final offsetX = cx;
    final offsetY = cy;

    void drawFaceRect(Color c, Offset center, double width, double height) {
      final rect = Rect.fromCenter(center: center, width: width, height: height);
      canvas.drawRect(rect, Paint()..color = c..style = PaintingStyle.fill);
      canvas.drawRect(rect, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);
    }

    void drawTriangleAt(Color c, Offset center, bool isPointingUp) {
      final path = Path();
      if (isPointingUp) {
        // Segitiga ujung di atas
        path.moveTo(center.dx, center.dy - hTri / 2);
        path.lineTo(center.dx + w / 2, center.dy + hTri / 2);
        path.lineTo(center.dx - w / 2, center.dy + hTri / 2);
        path.close();
      } else {
        // Segitiga ujung di bawah
        path.moveTo(center.dx, center.dy + hTri / 2);
        path.lineTo(center.dx + w / 2, center.dy - hTri / 2);
        path.lineTo(center.dx - w / 2, center.dy - hTri / 2);
        path.close();
      }
      canvas.drawPath(path, Paint()..color = c..style = PaintingStyle.fill);
      canvas.drawPath(path, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);
    }

    // URUTAN MENGGAMBAR: Paling jauh ke paling dekat (Painter's Algorithm)
    // Melipat ke arah DEPAN layar (Z negatif), SISI DEPAN (Alas/Tengah) adalah paling jauh.

    // 1. SISI DEPAN (Dinding Tengah / Alas - Paling Jauh)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX, offsetY),
      foldAngle: 0,
      isAxisX: true,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.purple.shade400, Offset(offsetX, offsetY), w, h),
    );

    // 2. SISI BAWAH (Segitiga Bawah)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX, offsetY + h / 2),
      foldAngle: -foldCap, // Negatif -> Lipat ke depan (Y lokal positif)
      isAxisX: true,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawTriangleAt(Colors.green.shade400, Offset(offsetX, offsetY + h / 2 + hTri / 2), false),
    );

    // 3. SISI KANAN (Dinding Kanan)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX + w / 2, offsetY),
      foldAngle: foldSide, // Positif -> Lipat ke depan (X lokal positif)
      isAxisX: false,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.orange.shade400, Offset(offsetX + w, offsetY), w, h),
    );

    // 4. SISI KIRI (Dinding Kiri)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX - w / 2, offsetY),
      foldAngle: -foldSide, // Negatif -> Lipat ke depan (X lokal negatif)
      isAxisX: false,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawFaceRect(Colors.blue.shade400, Offset(offsetX - w, offsetY), w, h),
    );

    // 5. SISI ATAS (Segitiga Atas - Paling Dekat / Tutup Atas)
    canvas.drawFace(
      globalPivot: Offset(cx, cy),
      pivot: Offset(offsetX, offsetY - h / 2),
      foldAngle: foldCap, // Positif -> Lipat ke depan (Y lokal negatif)
      isAxisX: true,
      globalTiltX: tiltX,
      globalTiltZ: tiltZ,
      drawCallback: () => drawTriangleAt(Colors.red.shade400, Offset(offsetX, offsetY - h / 2 - hTri / 2), true),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


// ─────────────────────────────────────────────────────────────────────────────
// 4. TABUNG (Pseudo 3D / Trik 2D)
// ─────────────────────────────────────────────────────────────────────────────

class JaringTabungPainter extends CustomPainter {
  JaringTabungPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    
    final fullWidth = size.width * 0.7;
    final height = size.height * 0.3;
    final radius = fullWidth / (2 * math.pi); // Karena keliling selimut = 2*pi*r

    // Saat menggulung, lebar memendek jadi diameter (2*radius)
    // dan mendapat gradien gelap di tepi
    final currentWidth = fullWidth - (fullWidth - 2 * radius) * progress;
    
    // Selimut
    final rect = Rect.fromCenter(center: Offset(cx, cy), width: currentWidth, height: height);
    final paintSelimut = Paint()
      ..color = Colors.blue.shade400
      ..style = PaintingStyle.fill;
      
    // Tambahkan gradien shading 3D saat melengkung
    if (progress > 0) {
      paintSelimut.shader = LinearGradient(
        colors: [
          Colors.blue.shade800.withAlpha((150 * progress).round()),
          Colors.blue.shade400,
          Colors.blue.shade800.withAlpha((150 * progress).round()),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
    }
    
    canvas.drawRect(rect, paintSelimut);
    canvas.drawRect(rect, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);

    // Lingkaran Atas dan Bawah
    // Saat progress 0: utuh bulat, nempel di tepi
    // Saat progress 1: jadi elips (karena perspektif 3D silinder), geser ke tengah
    final currentRadiusY = radius * (1 - 0.7 * progress); // Memipih jadi elips
    
    final yAtas = cy - height/2 - radius + (radius * progress);
    final yBawah = cy + height/2 + radius - (radius * progress);

    final rectAtas = Rect.fromCenter(center: Offset(cx, yAtas), width: radius * 2, height: currentRadiusY * 2);
    final rectBawah = Rect.fromCenter(center: Offset(cx, yBawah), width: radius * 2, height: currentRadiusY * 2);

    canvas.drawOval(rectAtas, Paint()..color = Colors.red.shade400..style = PaintingStyle.fill);
    canvas.drawOval(rectAtas, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);

    canvas.drawOval(rectBawah, Paint()..color = Colors.green.shade400..style = PaintingStyle.fill);
    canvas.drawOval(rectBawah, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. KERUCUT (Pseudo 3D)
// ─────────────────────────────────────────────────────────────────────────────

class JaringKerucutPainter extends CustomPainter {
  JaringKerucutPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    
    final radius = math.min(size.width, size.height) * 0.15; // Jari-jari alas
    final s = math.min(size.width, size.height) * 0.35;      // Garis pelukis (selimut)
    
    final currentWidth = s * 2 - (s * 2 - radius * 2) * progress;
    final currentHeight = s; // tinggi kerucut tampak samping
    
    // Alas
    final currentRadiusY = radius * (1 - 0.7 * progress); // Memipih jadi elips
    final rectAlas = Rect.fromCenter(center: Offset(cx, cy + currentHeight / 2), width: radius * 2, height: currentRadiusY * 2);
    
    canvas.drawOval(rectAlas, Paint()..color = Colors.green.shade400..style = PaintingStyle.fill);
    canvas.drawOval(rectAlas, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);

    // Selimut
    final path = Path();
    
    final peakY = cy - currentHeight / 2;
    final leftX = cx - currentWidth / 2;
    final rightX = cx + currentWidth / 2;
    
    path.moveTo(cx, peakY);
    // Garis kiri
    path.lineTo(leftX, cy + currentHeight / 2);
    
    // Lengkung bawah
    if (progress > 0.1) {
      // Saat dilipat, bawahnya melengkung mengikuti oval
      path.arcTo(rectAlas, math.pi, -math.pi, false);
    } else {
      // Saat dibuka, melengkung membentuk juring yang lebar
      path.quadraticBezierTo(cx, cy + currentHeight / 2 + currentWidth/2, rightX, cy + currentHeight / 2);
    }
    
    // Garis kanan kembali ke puncak
    path.lineTo(cx, peakY);
    path.close();

    final paintSelimut = Paint()
      ..color = Colors.purple.shade400
      ..style = PaintingStyle.fill;

    if (progress > 0) {
      paintSelimut.shader = LinearGradient(
        colors: [
          Colors.purple.shade800.withAlpha((150 * progress).round()),
          Colors.purple.shade400,
          Colors.purple.shade800.withAlpha((150 * progress).round()),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTRB(leftX, peakY, rightX, cy + currentHeight / 2));
    }

    canvas.drawPath(path, paintSelimut);
    canvas.drawPath(path, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. BOLA (Pseudo 3D)
// ─────────────────────────────────────────────────────────────────────────────

class JaringBolaPainter extends CustomPainter {
  JaringBolaPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(size.width, size.height) * 0.25;

    // Bola tidak memiliki jaring-jaring 2D sederhana. Kita tampilkan beberapa elips atau bola
    // Saat progress 0: Pola garis-garis bujur/lintang terbuka (map projection)
    // Saat progress 1: Bola padat dengan shading 3D

    if (progress < 0.5) {
      // Gambarkan peta datar (proyeksi)
      final w = radius * 4 * (1 - progress);
      final h = radius * 2;
      final rect = Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);
      canvas.drawRect(rect, Paint()..color = Colors.blue.shade400..style = PaintingStyle.fill);
      canvas.drawRect(rect, Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 2);
    } else {
      final p = (progress - 0.5) * 2; // Normalize to 0-1
      final paint = Paint()
        ..color = Colors.blue.shade400
        ..style = PaintingStyle.fill;

      paint.shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.8,
        colors: [
          Colors.blue.shade300,
          Colors.blue.shade600,
          Colors.blue.shade900,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: radius));

      canvas.drawCircle(Offset(cx, cy), radius * p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
