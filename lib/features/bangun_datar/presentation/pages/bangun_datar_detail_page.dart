import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';
import 'package:ruang_geo/features/bangun_datar/presentation/widgets/shape_painter_widget.dart';

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
      appBar: AppBarCustom(
        title: bangun.nama,
        actionIcon: Icons.favorite_border_rounded,
        onActionPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${bangun.nama} ditambahkan ke favorit!')),
          );
        },
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
                        painter: ShapePainterFactory.getShapePainter(
                          bangunId: bangun.id,
                          progress: _drawController.value,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _drawController.reset();
                      _drawController.forward();
                    },
                    icon: const Icon(Icons.play_circle_fill_rounded, color: Colors.white),
                    label: const Text(
                      'Lihat Animasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF), // ungu
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
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
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Jawaban kamu...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
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


