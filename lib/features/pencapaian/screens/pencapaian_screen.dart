import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/core.dart';
import '../../../core/services/supabase_service.dart';
import '../models/pencapaian_model.dart';
import '../services/pencapaian_service.dart';
import '../../home/presentation/widgets/home_widgets.dart';

class PencapaianScreen extends StatefulWidget {
  const PencapaianScreen({super.key});

  @override
  State<PencapaianScreen> createState() => _PencapaianScreenState();
}

class _PencapaianScreenState extends State<PencapaianScreen> {
  final _service = PencapaianService();
  bool _isLoading = true;
  List<PencapaianModel> _pencapaianList = [];
  StatistikModel? _statistik;
  String? _error;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _error = 'Sesi tidak ditemukan. Silakan login kembali.';
        });
        return;
      }
      final list = await _service.getPencapaianUser(userId);
      final statistik = _service.getStatistikUser(list);
      setState(() {
        _pencapaianList = list;
        _statistik = statistik;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Gagal memuat data. Periksa koneksi Anda.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ─── Header: HomeHeader & Card ─────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    HomeHeader(
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFF5A52D5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(50),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(40),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 32),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pencapaian Kamu',
                                  style: AppTypography.titleLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Lihat perjalanan belajarmu',
                                  style: AppTypography.bodyMedium.copyWith(color: Colors.white.withAlpha(200)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ─── Konten ───────────────────────────────────────────────────────
          if (_isLoading)
            _buildShimmerSliver()
          else if (_error != null)
            _buildErrorSliver()
          else ...[
            // Statistik card
            SliverToBoxAdapter(
              child: _buildStatistikCard(),
            ),
            // Riwayat header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  children: [
                    Text(
                      'Riwayat Kuis',
                      style: AppTypography.titleMedium
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_pencapaianList.length}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // List atau empty state
            if (_pencapaianList.isEmpty)
              SliverToBoxAdapter(child: _buildEmptyState())
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildPencapaianItem(_pencapaianList[index], index),
                  childCount: _pencapaianList.length,
                ),
              ),
            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
        ),
      ),
    );
  }

  // ─── Widget: Statistik Header Card ─────────────────────────────────────────
  Widget _buildStatistikCard() {
    final stat = _statistik;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.quiz_rounded,
              iconColor: AppColors.primary,
              label: 'Total Kuis',
              value: '${stat?.totalKuis ?? 0}',
            ),
          ),
          Container(
              width: 1, height: 48, color: AppColors.outlineVariant),
          Expanded(
            child: _StatItem(
              icon: Icons.bar_chart_rounded,
              iconColor: AppColors.success,
              label: 'Rata-rata',
              value:
                  '${(stat?.rataSkor ?? 0).toStringAsFixed(0)}%',
            ),
          ),
          Container(
              width: 1, height: 48, color: AppColors.outlineVariant),
          Expanded(
            child: _StatItem(
              icon: Icons.stars_rounded,
              iconColor: AppColors.warning,
              label: 'Total Poin',
              value: '${stat?.totalPoin ?? 0}',
            ),
          ),
        ],
      ),
    );
  }

  // ─── Widget: Satu item riwayat ──────────────────────────────────────────────
  Widget _buildPencapaianItem(PencapaianModel p, int index) {
    final kategoriColor = _getKategoriColor(p.kategori);
    final kategoriIcon = _getKategoriIcon(p.kategori);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOut,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Ikon kategori
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kategoriColor.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(kategoriIcon, color: kategoriColor, size: 26),
            ),
            const SizedBox(width: 14),

            // Info tengah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.kategoriLabel,
                    style: AppTypography.titleSmall
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTanggal(p.createdAt),
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textHint),
                  ),
                  const SizedBox(height: 6),
                  // Baris bintang
                  _buildBintangRow(p.bintang),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Skor & poin
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Skor
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSkorColor(p.skor).withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${p.soalBenar}/${p.totalSoal}',
                    style: AppTypography.labelMedium.copyWith(
                      color: _getSkorColor(p.skor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Poin
                Row(
                  children: [
                    const Icon(Icons.stars_rounded,
                        color: AppColors.warning, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      '+${p.totalPoin}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Widget: Baris bintang ──────────────────────────────────────────────────
  Widget _buildBintangRow(int jumlah) {
    return Row(
      children: List.generate(3, (i) {
        final active = i < jumlah;
        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            active ? Icons.star_rounded : Icons.star_outline_rounded,
            color: active ? AppColors.warning : AppColors.outlineVariant,
            size: 16,
          ),
        );
      }),
    );
  }

  // ─── Widget: Empty State ────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Pencapaian',
            style: AppTypography.titleLarge
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Selesaikan kuis pertamamu dan mulai kumpulkan bintang serta poin!',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => context.push(AppConstants.routeKuis),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text(
              'Mulai Kuis Sekarang',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Widget: Error state ───────────────────────────────────────────────────
  Widget _buildErrorSliver() {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 72, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                _error ?? 'Terjadi kesalahan',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Widget: Shimmer Loading ────────────────────────────────────────────────
  Widget _buildShimmerSliver() {
    return SliverToBoxAdapter(
      child: Shimmer.fromColors(
        baseColor: AppColors.surfaceVariant,
        highlightColor: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Shimmer statistik card
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              // Shimmer list items
              ...List.generate(
                4,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────
  Color _getKategoriColor(String kategori) {
    switch (kategori) {
      case 'ruang':
        return AppColors.primary;
      case 'datar':
        return AppColors.secondary;
      case 'tka':
        return AppColors.error;
      default:
        return AppColors.accent;
    }
  }

  IconData _getKategoriIcon(String kategori) {
    switch (kategori) {
      case 'ruang':
        return Icons.view_in_ar_rounded;
      case 'datar':
        return Icons.shape_line_rounded;
      case 'tka':
        return Icons.psychology_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  Color _getSkorColor(double skor) {
    if (skor >= 80) return AppColors.success;
    if (skor >= 60) return AppColors.warning;
    return AppColors.error;
  }

  String _formatTanggal(DateTime dt) {
    const bulan = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${dt.day} ${bulan[dt.month]} ${dt.year}';
  }
}

// ─── StatItem Widget ──────────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall
              .copyWith(color: AppColors.textHint),
        ),
      ],
    );
  }
}
