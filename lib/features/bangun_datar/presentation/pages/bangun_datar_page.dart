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
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0, // sama persis kayak Bangun Ruang
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

/// Card dengan bintang favorit yang bisa di-toggle
class _BangunDatarCard extends StatefulWidget {
  const _BangunDatarCard({
    required this.bangun,
    required this.onTap,
  });

  final BangunModel bangun;
  final VoidCallback onTap;

  @override
  State<_BangunDatarCard> createState() => _BangunDatarCardState();
}

class _BangunDatarCardState extends State<_BangunDatarCard>
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

  Color _getColor(String id) {
    switch (id) {
      case 'bd_persegi':         return const Color(0xFF4CAF50);
      case 'bd_persegi_panjang': return const Color(0xFF2196F3);
      case 'bd_segitiga':        return const Color(0xFFFF9800);
      case 'bd_jajargenjang':    return const Color(0xFF009688);
      case 'bd_trapesium':       return const Color(0xFF9C27B0);
      case 'bd_layang':          return const Color(0xFFE91E63);
      case 'bd_belah_ketupat':   return const Color(0xFF3F51B5);
      case 'bd_lingkaran':       return const Color(0xFFFFC107);
      default:                   return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(widget.bangun.id);
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
                // Shape Icon besar, tanpa lingkaran, di tengah
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShapeIcon(
                        shapeId: widget.bangun.id,
                        color: color,
                        size: 120,
                      ),
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
