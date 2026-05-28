import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';

/// Halaman Detail Bangun Datar
class BangunDatarDetailPage extends StatefulWidget {
  const BangunDatarDetailPage({
    super.key,
    required this.bangunId,
  });

  final String bangunId;

  @override
  State<BangunDatarDetailPage> createState() => _BangunDatarDetailPageState();
}

class _BangunDatarDetailPageState extends State<BangunDatarDetailPage>
    with TickerProviderStateMixin {
  late final BangunModel bangun;
  late final TabController _tabController;

  // Controller untuk animasi pembentukan bangun datar
  late final AnimationController _drawController;

  @override
  void initState() {
    super.initState();
    bangun = DummyData.bangunDatarList.firstWhere(
      (b) => b.id == widget.bangunId,
      orElse: () => DummyData.bangunDatarList.first,
    );

    _tabController = TabController(length: 4, vsync: this);
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Otomatis jalankan animasi saat halaman dibuka
    _drawController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _drawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(bangun.nama),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${bangun.nama} ditambahkan ke favorit!')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ─── Tab Bar ──────────────────────────────────────────────────
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: const [
              Tab(text: 'Informasi'),
              Tab(text: 'Rumus'),
              Tab(text: 'Sifat'),
              Tab(text: 'Contoh Soal'),
            ],
          ),

          // ─── Tab Bar View ─────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabInformasi(),
                _buildTabRumus(),
                _buildTabSifat(),
                _buildTabSoal(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ISI TAB INFORMASI
  // =========================================================================
  Widget _buildTabInformasi() {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        // Ilustrasi Bangun Datar
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(10),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedBuilder(
                    animation: _drawController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(double.infinity, double.infinity),
                        painter: BangunDatarPainter(
                          bangunId: bangun.id,
                          progress: _drawController.value,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextButton.icon(
                  onPressed: () {
                    _drawController.reset();
                    _drawController.forward();
                  },
                  icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.secondary),
                  label: Text(
                    'Lihat Animasi',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.secondary),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Deskripsi',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          bangun.deskripsi,
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }

  // =========================================================================
  // ISI TAB RUMUS
  // =========================================================================
  Widget _buildTabRumus() {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildRumusCard('Keliling', bangun.rumusVolume ?? '-', AppColors.primaryContainer, AppColors.primary),
        const SizedBox(height: 16),
        _buildRumusCard('Luas', bangun.rumusLuas, AppColors.secondaryContainer, AppColors.secondary),
      ],
    );
  }

  Widget _buildRumusCard(String title, String rumus, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.functions_rounded, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Rumus $title',
                style: AppTypography.titleMedium.copyWith(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: textColor.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: SelectableText(
                rumus,
                style: AppTypography.headlineMedium.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textPrimary,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ISI TAB SIFAT
  // =========================================================================
  Widget _buildTabSifat() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: bangun.sifatSifat.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6, right: 12),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                bangun.sifatSifat[index],
                style: AppTypography.bodyMedium.copyWith(height: 1.5),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================================
  // ISI TAB CONTOH SOAL
  // =========================================================================
  Widget _buildTabSoal() {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildSoalCard(
          no: 1,
          pertanyaan: 'Sebuah ${bangun.nama.toLowerCase()} memiliki keliling 40 cm. Berapakah luasnya?',
          jawabanBenar: '100', // Dummy
        ),
      ],
    );
  }

  Widget _buildSoalCard({required int no, required String pertanyaan, required String jawabanBenar}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Soal $no',
                  style: AppTypography.labelSmall.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            pertanyaan,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _InteractiveAnswerDatar(jawabanBenar: jawabanBenar),
        ],
      ),
    );
  }
}

class _InteractiveAnswerDatar extends StatefulWidget {
  const _InteractiveAnswerDatar({required this.jawabanBenar});
  final String jawabanBenar;

  @override
  State<_InteractiveAnswerDatar> createState() => _InteractiveAnswerDatarState();
}

class _InteractiveAnswerDatarState extends State<_InteractiveAnswerDatar> {
  final TextEditingController _controller = TextEditingController();
  bool? _isCorrect;

  void _cekJawaban() {
    setState(() {
      _isCorrect = _controller.text.trim() == widget.jawabanBenar;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Jawaban kamu...',
                  suffixIcon: _isCorrect == null
                      ? null
                      : Icon(
                          _isCorrect! ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: _isCorrect! ? AppColors.success : AppColors.error,
                        ),
                ),
                onChanged: (val) {
                  if (_isCorrect != null) setState(() => _isCorrect = null);
                },
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _cekJawaban,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Cek', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        if (_isCorrect == false)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Jawaban kurang tepat.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        if (_isCorrect == true)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Mantap! Jawaban benar.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.success),
            ),
          ),
      ],
    );
  }
}

/// CustomPainter untuk menggambar bangun datar
class BangunDatarPainter extends CustomPainter {
  BangunDatarPainter({
    required this.bangunId,
    required this.progress,
  });

  final String bangunId;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = AppColors.primary.withAlpha(30)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void drawLabel(String text, Offset offset, {Color color = Colors.black87, double fontSize = 14, bool bold = false}) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, offset - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    final double w = size.width;
    final double h = size.height;
    final Path path = Path();

    // Default center
    final cx = w / 2;
    final cy = h / 2;

    switch (bangunId) {
      case 'bd_segitiga':
        // Segitiga sama sisi / sama kaki
        final p1 = Offset(cx, cy - h / 3); // Titik atas (A)
        final p2 = Offset(cx - w / 3, cy + h / 3); // Titik kiri bawah (B)
        final p3 = Offset(cx + w / 3, cy + h / 3); // Titik kanan bawah (C)

        // Animasi gambar garis
        path.moveTo(p1.dx, p1.dy);
        if (progress > 0.33) {
          path.lineTo(p2.dx, p2.dy);
          if (progress > 0.66) {
            path.lineTo(p3.dx, p3.dy);
            if (progress >= 0.99) {
              path.close();
            } else {
              // Interpolasi garis 3
              final t = (progress - 0.66) * 3;
              path.lineTo(p3.dx + (p1.dx - p3.dx) * t, p3.dy + (p1.dy - p3.dy) * t);
            }
          } else {
            // Interpolasi garis 2
            final t = (progress - 0.33) * 3;
            path.lineTo(p2.dx + (p3.dx - p2.dx) * t, p2.dy + (p3.dy - p2.dy) * t);
          }
        } else {
          // Interpolasi garis 1
          final t = progress * 3;
          path.lineTo(p1.dx + (p2.dx - p1.dx) * t, p1.dy + (p2.dy - p1.dy) * t);
        }

        if (progress >= 1.0) {
          canvas.drawPath(path, fillPaint);
          // Label Sudut
          drawLabel('A', p1 - const Offset(0, 20), bold: true);
          drawLabel('B', p2 - const Offset(20, -10), bold: true);
          drawLabel('C', p3 + const Offset(20, 10), bold: true);
          // Label Sisi
          drawLabel('c', Offset((p1.dx + p2.dx) / 2 - 15, (p1.dy + p2.dy) / 2), color: Colors.grey[700]!);
          drawLabel('a', Offset((p2.dx + p3.dx) / 2, p2.dy + 15), color: Colors.grey[700]!);
          drawLabel('b', Offset((p1.dx + p3.dx) / 2 + 15, (p1.dy + p3.dy) / 2), color: Colors.grey[700]!);
        }
        canvas.drawPath(path, paint);
        break;

      case 'bd_persegi':
      case 'bd_persegi_panjang':
        final double rectW = bangunId == 'bd_persegi' ? w * 0.6 : w * 0.8;
        final double rectH = bangunId == 'bd_persegi' ? w * 0.6 : h * 0.5;
        
        final p1 = Offset(cx - rectW / 2, cy - rectH / 2); // Kiri atas (A)
        final p2 = Offset(cx + rectW / 2, cy - rectH / 2); // Kanan atas (B)
        final p3 = Offset(cx + rectW / 2, cy + rectH / 2); // Kanan bawah (C)
        final p4 = Offset(cx - rectW / 2, cy + rectH / 2); // Kiri bawah (D)

        path.moveTo(p1.dx, p1.dy);
        if (progress > 0.25) {
          path.lineTo(p2.dx, p2.dy);
          if (progress > 0.50) {
            path.lineTo(p3.dx, p3.dy);
            if (progress > 0.75) {
              path.lineTo(p4.dx, p4.dy);
              if (progress >= 0.99) {
                path.close();
              } else {
                final t = (progress - 0.75) * 4;
                path.lineTo(p4.dx + (p1.dx - p4.dx) * t, p4.dy + (p1.dy - p4.dy) * t);
              }
            } else {
              final t = (progress - 0.50) * 4;
              path.lineTo(p3.dx + (p4.dx - p3.dx) * t, p3.dy + (p4.dy - p3.dy) * t);
            }
          } else {
            final t = (progress - 0.25) * 4;
            path.lineTo(p2.dx + (p3.dx - p2.dx) * t, p2.dy + (p3.dy - p2.dy) * t);
          }
        } else {
          final t = progress * 4;
          path.lineTo(p1.dx + (p2.dx - p1.dx) * t, p1.dy + (p2.dy - p1.dy) * t);
        }

        if (progress >= 1.0) {
          canvas.drawPath(path, fillPaint);
          // Label Sudut
          drawLabel('A', p1 - const Offset(15, 15), bold: true);
          drawLabel('B', p2 + const Offset(15, -15), bold: true);
          drawLabel('C', p3 + const Offset(15, 15), bold: true);
          drawLabel('D', p4 - const Offset(15, -15), bold: true);
          
          if (bangunId == 'bd_persegi') {
            drawLabel('s', Offset(cx, p1.dy - 15), color: Colors.grey[700]!);
            drawLabel('s', Offset(p2.dx + 15, cy), color: Colors.grey[700]!);
          } else {
            drawLabel('p', Offset(cx, p1.dy - 15), color: Colors.grey[700]!);
            drawLabel('l', Offset(p2.dx + 15, cy), color: Colors.grey[700]!);
          }
        }
        canvas.drawPath(path, paint);
        break;

      case 'bd_lingkaran':
        final double radius = math.min(w, h) * 0.4;
        
        // Animasi lingkaran menggunakan arc
        final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);
        final sweepAngle = progress * 2 * math.pi;
        path.addArc(rect, -math.pi / 2, sweepAngle);
        
        if (progress >= 1.0) {
          canvas.drawCircle(Offset(cx, cy), radius, fillPaint);
          
          // Titik pusat
          canvas.drawCircle(Offset(cx, cy), 3, Paint()..color = Colors.black);
          drawLabel('O', Offset(cx - 10, cy + 10), bold: true);
          
          // Garis jari-jari
          final pRadius = Offset(cx + radius, cy);
          canvas.drawLine(Offset(cx, cy), pRadius, Paint()..color = Colors.grey[600]!..strokeWidth = 1.5..style = PaintingStyle.stroke);
          drawLabel('r', Offset(cx + radius / 2, cy - 10), color: Colors.grey[700]!);
        }
        canvas.drawPath(path, paint);
        break;

      default:
        // Placeholder untuk bentuk lain (gambar kotak saja)
        final rect = Rect.fromCenter(center: Offset(cx, cy), width: w * 0.5, height: h * 0.5);
        if (progress >= 1.0) canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, paint);
        drawLabel('Ilustrasi ${bangunId.split('_')[1]}', Offset(cx, cy));
    }
  }

  @override
  bool shouldRepaint(covariant BangunDatarPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.bangunId != bangunId;
  }
}
