import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';
import '../widgets/isometric_shape_painter.dart';

/// Halaman daftar Bangun Ruang
class BangunRuangPage extends StatefulWidget {
  const BangunRuangPage({super.key});

  @override
  State<BangunRuangPage> createState() => _BangunRuangPageState();
}

class _BangunRuangPageState extends State<BangunRuangPage> {
  // Kategori filter yang tersedia
  final List<String> _filters = ['Semua', 'Prisma', 'Limas', 'Tabung', 'Bola'];
  String _selectedFilter = 'Semua';

  // Daftar data semua bangun ruang
  final List<BangunModel> _allBangun = DummyData.bangunRuangList;

  // Mendapatkan daftar bangun ruang yang difilter
  List<BangunModel> get _filteredBangun {
    if (_selectedFilter == 'Semua') return _allBangun;

    return _allBangun.where((bangun) {
      if (_selectedFilter == 'Prisma') {
        return bangun.nama.toLowerCase().contains('kubus') ||
            bangun.nama.toLowerCase().contains('balok') ||
            bangun.nama.toLowerCase().contains('prisma');
      } else if (_selectedFilter == 'Limas') {
        return bangun.nama.toLowerCase().contains('limas') ||
            bangun.nama.toLowerCase().contains('kerucut');
      } else {
        return bangun.nama.toLowerCase().contains(_selectedFilter.toLowerCase());
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: const AppBarCustom(title: 'Bangun Ruang'),
      body: Column(
        children: [
          // ─── Filter Chips ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _filters.map((filter) {
                  final isSelected = filter == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      showCheckmark: isSelected,
                      checkmarkColor: Colors.white,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF6C63FF),
                      labelStyle: AppTypography.labelMedium.copyWith(
                        color: isSelected ? Colors.white : const Color(0xFF555555),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ─── Grid View ───────────────────────────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: _filteredBangun.length,
              itemBuilder: (context, index) {
                final bangun = _filteredBangun[index];
                return _BangunCard(
                  bangun: bangun,
                  onTap: () {
                    context.push('/bangun-ruang/${bangun.id}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget Card untuk menampilkan item Bangun Ruang
class _BangunCard extends StatefulWidget {
  const _BangunCard({
    required this.bangun,
    required this.onTap,
  });

  final BangunModel bangun;
  final VoidCallback onTap;

  @override
  State<_BangunCard> createState() => _BangunCardState();
}

class _BangunCardState extends State<_BangunCard>
    with SingleTickerProviderStateMixin {
  bool _isFavorit = false;
  late AnimationController _starController;
  late Animation<double> _starScale;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _starScale = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _starController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  void _toggleFavorit() {
    setState(() => _isFavorit = !_isFavorit);
    _starController.forward(from: 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorit
              ? '${widget.bangun.nama} ditambahkan ke favorit!'
              : '${widget.bangun.nama} dihapus dari favorit.',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ─── Konten utama ─────────────────────────────────────────
            Column(
              children: [
                // Shape 3D
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: getShapeWidget(widget.bangun.id, 140),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Nama Bangun
                Text(
                  widget.bangun.nama,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: const Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // ─── Tombol Bintang ────────────────────────────────────────
            Positioned(
              top: -4,
              right: -4,
              child: GestureDetector(
                onTap: _toggleFavorit,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ScaleTransition(
                    scale: _starScale,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _isFavorit
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        key: ValueKey(_isFavorit),
                        color: _isFavorit
                            ? const Color(0xFFFFB300)
                            : Colors.grey.shade400,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
