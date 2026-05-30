import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';

/// Halaman Detail Bangun Ruang
class BangunRuangDetailPage extends StatefulWidget {
  const BangunRuangDetailPage({
    super.key,
    required this.bangunId,
  });

  final String bangunId;

  @override
  State<BangunRuangDetailPage> createState() => _BangunRuangDetailPageState();
}

class _BangunRuangDetailPageState extends State<BangunRuangDetailPage>
    with TickerProviderStateMixin {
  late final BangunModel bangun;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Cari data bangun berdasarkan ID
    bangun = DummyData.bangunRuangList.firstWhere(
      (b) => b.id == widget.bangunId,
      orElse: () => DummyData.bangunRuangList.first,
    );

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          // ─── Area Atas (Placeholder 3D) ───────────────────────────────
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Stack(
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
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
                      color: Colors.white.withAlpha(20),
                    ),
                  ),
                ),
                // Bangun 3D Viewer
                Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      border: Border.all(color: Colors.white.withAlpha(100), width: 2),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Bangun3DViewer(
                        bangunId: bangun.id,
                        size: 120,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

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
        
        // Info Cards (Sisi, Rusuk, Sudut) - dummy extraction based on sifatSifat
        Row(
          children: [
            _buildInfoCard('Sisi', _extractNumber(bangun.sifatSifat, 'sisi'), Icons.square_outlined),
            const SizedBox(width: 12),
            _buildInfoCard('Rusuk', _extractNumber(bangun.sifatSifat, 'rusuk'), Icons.horizontal_rule_rounded),
            const SizedBox(width: 12),
            _buildInfoCard('Sudut', _extractNumber(bangun.sifatSifat, 'sudut'), Icons.architecture_rounded),
          ],
        ),
        const SizedBox(height: 24),

        Text(
          'Jaring-Jaring',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Container(
          height: 160,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Center(
            child: JaringJaringViewer(
              bangunId: bangun.id,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 32),

        ElevatedButton.icon(
          onPressed: () {
            context.push('${AppConstants.routeAR}/${bangun.id}');
          },
          icon: const Icon(Icons.view_in_ar_rounded),
          label: const Text('Lihat di AR'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
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

  // =========================================================================
  // ISI TAB RUMUS
  // =========================================================================
  Widget _buildTabRumus() {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        if (bangun.rumusVolume != null) ...[
          _buildRumusCard('Volume', bangun.rumusVolume!, AppColors.primaryContainer, AppColors.primary),
          const SizedBox(height: 16),
        ],
        _buildRumusCard('Luas Permukaan', bangun.rumusLuas, AppColors.secondaryContainer, AppColors.secondary),
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
                color: AppColors.primary,
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
          pertanyaan: 'Sebuah ${bangun.nama.toLowerCase()} memiliki panjang sisi 5 cm. Berapakah luas permukaannya?',
          jawabanBenar: '150', // Dummy answer, not dynamic
        ),
        const SizedBox(height: 20),
        _buildSoalCard(
          no: 2,
          pertanyaan: 'Jika volume sebuah ${bangun.nama.toLowerCase()} adalah 64 cm³, berapakah panjang sisinya?',
          jawabanBenar: '4', // Dummy answer, not dynamic
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
                  color: AppColors.secondary,
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
          _InteractiveAnswer(jawabanBenar: jawabanBenar),
        ],
      ),
    );
  }

  // =========================================================================
  // HELPER LOGIC
  // =========================================================================
  
  /// Ekstrak angka dari kalimat sifat (misal "Memiliki 6 sisi" -> "6")
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
}

/// Widget untuk input jawaban soal
class _InteractiveAnswer extends StatefulWidget {
  const _InteractiveAnswer({required this.jawabanBenar});
  final String jawabanBenar;

  @override
  State<_InteractiveAnswer> createState() => _InteractiveAnswerState();
}

class _InteractiveAnswerState extends State<_InteractiveAnswer> {
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
              child: const Text('Cek'),
            ),
          ],
        ),
        if (_isCorrect == false)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Jawaban masih kurang tepat. Coba lagi!',
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        if (_isCorrect == true)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Mantap! Jawaban kamu benar.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.success),
            ),
          ),
      ],
    );
  }
}
