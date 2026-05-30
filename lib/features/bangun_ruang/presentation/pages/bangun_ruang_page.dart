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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Bangun Ruang',
          style: AppTypography.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // ─── Filter Chips ────────────────────────────────────────────────
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
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
              },
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
class _BangunCard extends StatelessWidget {
  const _BangunCard({
    required this.bangun,
    required this.onTap,
  });

  final BangunModel bangun;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Gambar dan Ikon Favorit
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: getShapeWidget(bangun.id, 90),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.star_border_rounded,
                        color: Colors.grey,
                        size: 24,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${bangun.nama} ditambahkan ke favorit!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Nama Bangun
            Text(
              bangun.nama,
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
      ),
    );
  }

}


