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
          // ─── Pill Tab Bar ────────────────────────────────────────────────
          _PillTabBar(
            controller: _tabController,
            tabs: const ['Informasi', 'Rumus', 'Sifat', 'Contoh Soal'],
          ),

          // ─── Area Atas (Tampilan Bangun Datar) ─────────────────────────────
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Stack(
              children: [
                // Background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
                // Ornamen Lingkaran
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withAlpha(10),
                    ),
                  ),
                ),
                // Konten Aktif
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 70, left: 24, right: 24),
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
                // Tombol Animasi
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        _drawController.reset();
                        _drawController.forward();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withAlpha(50)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_circle_fill_rounded, size: 18, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Lihat Animasi',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
        Text(
          'Deskripsi',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          bangun.deskripsi,
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: 24),
        // Info Cards (Sisi, Sudut) - dummy extraction based on sifatSifat
        Row(
          children: [
            _buildInfoCard('Sisi', _extractNumber(bangun.sifatSifat, 'sisi'), Icons.square_outlined),
            const SizedBox(width: 12),
            _buildInfoCard('Sudut', _extractNumber(bangun.sifatSifat, 'sudut'), Icons.architecture_rounded),
          ],
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
          pertanyaan: 'Sebuah ${bangun.nama.toLowerCase()} memiliki ukuran utama 10 cm. Berapakah luasnya? (Anggap luas = ukuran × ukuran)',
          jawabanBenar: '100', // Dummy
          rumus: bangun.rumusLuas,
          pembahasan: 'Luas = 10 × 10\nLuas = 100 cm²',
        ),
      ],
    );
  }

  Widget _buildSoalCard({
    required int no,
    required String pertanyaan,
    required String jawabanBenar,
    required String rumus,
    required String pembahasan,
  }) {
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
          _InteractiveAnswerDatar(
            jawabanBenar: jawabanBenar,
            rumus: rumus,
            pembahasan: pembahasan,
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // HELPER LOGIC
  // =========================================================================

  /// Ekstrak angka dari kalimat sifat (misal "Memiliki 4 sisi" -> "4")
  String _extractNumber(List<String> sifat, String keyword) {
    for (var kalimat in sifat) {
      if (kalimat.toLowerCase().contains(keyword)) {
        final regex = RegExp(r'\d+');
        final match = regex.firstMatch(kalimat);
        if (match != null) {
          return match.group(0)!;
        }
      }
    }
    return '-'; // Jika tidak ada
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTypography.headlineMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pill Tab Bar Widget ────────────────────────────────────────────────────
class _PillTabBar extends StatefulWidget {
  const _PillTabBar({
    required this.controller,
    required this.tabs,
  });

  final TabController controller;
  final List<String> tabs;

  @override
  State<_PillTabBar> createState() => _PillTabBarState();
}

class _PillTabBarState extends State<_PillTabBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.tabs.length, (index) {
          final isSelected = widget.controller.index == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => widget.controller.animateTo(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  widget.tabs[index],
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _InteractiveAnswerDatar extends StatefulWidget {
  const _InteractiveAnswerDatar({
    required this.jawabanBenar,
    required this.rumus,
    required this.pembahasan,
  });
  final String jawabanBenar;
  final String rumus;
  final String pembahasan;

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
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withAlpha(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jawaban kurang tepat. Ingat kembali rumus:',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.rumus,
                    style: AppTypography.bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_isCorrect == true)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withAlpha(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mantap! Jawaban benar.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pembahasan:',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.pembahasan,
                    style: AppTypography.bodyMedium.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
