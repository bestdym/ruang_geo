import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import '../widgets/widgets.dart';
import 'package:ruang_geo/core/services/supabase_service.dart';
import 'package:ruang_geo/features/profil/services/profil_service.dart';
import 'package:ruang_geo/features/profil/models/profile_model.dart';
import 'package:ruang_geo/features/pencapaian/services/pencapaian_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  ProfileModel? _profile;
  int _totalPoin = 0;

  final List<String> _funFacts = [
    'Tahukah Kamu? Bangun ruang dengan jumlah sisi paling banyak yang memiliki nama khusus adalah Rhombicosidodecahedron dengan 62 sisi!',
    'Tahukah Kamu? Bola adalah satu-satunya bangun ruang yang tidak memiliki titik sudut maupun rusuk.',
    'Tahukah Kamu? Segitiga sama sisi selalu memiliki sudut masing-masing tepat 60 derajat.',
    'Tahukah Kamu? Piramida di Mesir berbentuk limas segi empat yang merupakan salah satu bangun ruang dasar.',
    'Tahukah Kamu? Tabung tidak memiliki titik sudut, melainkan hanya 2 rusuk melengkung.',
  ];
  late final String _dailyFact;

  @override
  void initState() {
    super.initState();
    _dailyFact = _funFacts[Random().nextInt(_funFacts.length)];
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final profile = await ProfilService().getProfile(user.id);
      final listPencapaian = await PencapaianService().getPencapaianUser(user.id);
      final stats = PencapaianService().getStatistikUser(listPencapaian);
      if (mounted) {
        setState(() {
          _profile = profile;
          _totalPoin = stats.totalPoin;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          const Positioned.fill(child: FloatingDecorations()),
          SafeArea(
            child: FadeTransition(
              opacity: CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
                  CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
                ),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(AppConstants.spacingMD),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          HomeHeader(
                            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                          ),
                          const SizedBox(height: AppConstants.spacingLG),
                          
                          // 1. Sapaan & Poin
                          _buildGreetingSection(),
                          const SizedBox(height: AppConstants.spacingLG),

                          // 2. Tahukah Kamu? (Fun Fact)
                          _buildFunFactCard(),
                          const SizedBox(height: 28),

                          // 3. Materi Sorotan
                          Text(
                            'Materi Sorotan',
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 16),
                          _buildFeaturedMateri(),
                          const SizedBox(height: 28),

                          // 4. Aksi Cepat
                          Text(
                            'Aksi Cepat',
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildQuickActionCard(
                                  title: 'Tantangan Kuis',
                                  icon: Icons.sports_esports_rounded,
                                  color: AppColors.warning,
                                  onTap: () => context.push('/kuis'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildQuickActionCard(
                                  title: 'AR Kamera',
                                  icon: Icons.center_focus_strong_rounded,
                                  color: AppColors.primary,
                                  onTap: () => context.push('/ar'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection() {
    final nama = _profile?.fullName?.split(' ').first ?? 'Sobat Geo';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $nama! 👋',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Siap belajar geometri hari ini?',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (!_isLoading && supabase.auth.currentUser != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.warning.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.warning.withAlpha(80)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: AppColors.warning, size: 20),
                const SizedBox(width: 6),
                Text(
                  '$_totalPoin Poin',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFunFactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.bangunRuangGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(50),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _dailyFact,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedMateri() {
    return InkWell(
      onTap: () => context.push(AppConstants.routeBangunRuang),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.view_in_ar_rounded, color: AppColors.primary, size: 36),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bangun Ruang',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mari pelajari Kubus, Balok, dan lainnya.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(60), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(40),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
