import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';
import 'package:ruang_geo/features/bangun_ruang/presentation/widgets/model_viewer_widget.dart';
import 'package:ruang_geo/features/bangun_ruang/presentation/widgets/jaring_widget.dart';
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
  
  bool _isJaringMode = false;

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
          // ─── Pill Tab Bar ─────────────────────────────────────────────
          _PillTabBar(
            controller: _tabController,
            tabs: const ['Informasi', 'Rumus', 'Sifat', 'Contoh Soal'],
          ),

          // ─── Area Atas (Toggle Jaring & 3D) ─────────────────────────────
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isJaringMode
                        ? JaringWidget(
                            key: const ValueKey('jaring_mode'),
                            bangunId: bangun.id,
                          )
                        : ClipRRect(
                            key: const ValueKey('3d_mode'),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(32),
                            ),
                            child: RGModelViewer(
                              bangunId: bangun.id,
                              autoRotate: true,
                              backgroundColor: const Color(0x006C63FF),
                              fallbackSize: 120,
                            ),
                          ),
                  ),
                ),
                // Toggle Button (Model 3D / Jaring-jaring) di tengah atas
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildModeToggle(
                            title: 'Model 3D',
                            icon: Icons.view_in_ar_rounded,
                            isActive: !_isJaringMode,
                            onTap: () => setState(() => _isJaringMode = false),
                          ),
                          _buildModeToggle(
                            title: 'Jaring-jaring',
                            icon: Icons.layers_rounded,
                            isActive: _isJaringMode,
                            onTap: () => setState(() => _isJaringMode = true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Tombol Full 3D
                if (!_isJaringMode)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        context.push('/bangun-ruang/${bangun.id}/model');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(220),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.open_in_full_rounded,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Full 3D',
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

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push('/bangun-ruang/${bangun.id}/model');
                },
                icon: const Icon(Icons.view_in_ar_rounded),
                label: const Text('Model 3D'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: AppTypography.labelMedium
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('${AppConstants.routeAR}/${bangun.id}');
                },
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Lihat di AR'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: AppTypography.labelMedium
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
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
  // Helper widget untuk mode toggle
  Widget _buildModeToggle({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              ),
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
