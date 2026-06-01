import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';
import 'package:ruang_geo/features/bangun_datar/presentation/widgets/shape_icon.dart';

/// Halaman daftar Bangun Datar
class BangunDatarPage extends StatelessWidget {
  const BangunDatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final listBangunDatar = DummyData.bangunDatarList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarCustom(title: 'Bangun Datar'),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 100, // Card height: 100px
        ),
        itemCount: listBangunDatar.length,
        itemBuilder: (context, index) {
          final bangun = listBangunDatar[index];
          return _BangunDatarCard(
            bangun: bangun,
            onTap: () {
              context.push('/bangun-datar/${bangun.id}');
            },
          );
        },
      ),
    );
  }
}

class _BangunDatarCard extends StatelessWidget {
  const _BangunDatarCard({
    required this.bangun,
    required this.onTap,
  });

  final BangunModel bangun;
  final VoidCallback onTap;

  // Fungsi helper untuk mendapatkan warna yang sesuai
  Color _getColorForBangunDatar(String id) {
    switch (id) {
      case 'bd_persegi':
        return const Color(0xFF4CAF50); // Hijau
      case 'bd_persegi_panjang':
        return const Color(0xFF2196F3); // Biru
      case 'bd_segitiga':
        return const Color(0xFFFF9800); // Oranye
      case 'bd_jajargenjang':
        return const Color(0xFF009688); // Teal
      case 'bd_trapesium':
        return const Color(0xFF9C27B0); // Ungu
      case 'bd_layang':
        return const Color(0xFFE91E63); // Pink
      case 'bd_lingkaran':
        return const Color(0xFFFFC107); // Kuning
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Shape Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getColorForBangunDatar(bangun.id).withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ShapeIcon(
                shapeId: bangun.id,
                color: _getColorForBangunDatar(bangun.id),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            // Nama Bangun
            Expanded(
              child: Text(
                bangun.nama,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
