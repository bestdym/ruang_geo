import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';

/// Halaman daftar Bangun Datar
class BangunDatarPage extends StatelessWidget {
  const BangunDatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final listBangunDatar = DummyData.bangunDatarList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Bangun Datar'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Lebih compact (3 kolom)
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
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

  // Fungsi helper untuk mendapatkan ikon yang sesuai dengan nama bangun datar
  IconData _getIconForBangunDatar(String id) {
    switch (id) {
      case 'bd_persegi':
        return Icons.crop_square_rounded;
      case 'bd_persegi_panjang':
        return Icons.rectangle_outlined;
      case 'bd_segitiga':
        return Icons.change_history_rounded; // Mirip segitiga
      case 'bd_jajargenjang':
        return Icons.smart_display_outlined; // Mirip jajar genjang
      case 'bd_trapesium':
        return Icons.pentagon_outlined; // Placeholder
      case 'bd_layang':
        return Icons.diamond_outlined;
      case 'bd_lingkaran':
        return Icons.circle_outlined;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withAlpha(100),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForBangunDatar(bangun.id),
                color: AppColors.secondary,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                bangun.nama,
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
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
