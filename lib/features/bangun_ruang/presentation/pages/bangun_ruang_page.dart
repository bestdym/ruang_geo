import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Bangun Ruang'),
      ),
      body: Column(
        children: [
          // ─── Filter Chips ────────────────────────────────────────────────
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Colors.transparent,
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: AppTypography.labelMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.outline,
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
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
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
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Bagian Gambar (Placeholder) ──────────────────────────────
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(15),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    // Bangun 3D Viewer di tengah
                    Center(
                      child: Bangun3DViewer(
                        bangunId: bangun.id,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),

                    // Tombol Favorit di pojok kanan atas
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface.withAlpha(200),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.star_border_rounded,
                            color: AppColors.textHint,
                            size: 20,
                          ),
                          onPressed: () {
                            // TODO: Implementasi logika favorit
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${bangun.nama} ditambahkan ke favorit!'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Bagian Teks Nama Bangun ──────────────────────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bangun.nama,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tingkat: ${bangun.tingkat.label}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


