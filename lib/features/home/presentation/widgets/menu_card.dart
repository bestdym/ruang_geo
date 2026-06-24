import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ruang_geo/core/core.dart';

/// Widget menu card yang reusable dengan scale animation
///
/// Digunakan di Home Screen untuk navigasi ke:
/// Bangun Ruang, Bangun Datar, AR, Kuis
class MenuCard extends StatefulWidget {
  const MenuCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.badge,
    this.badgeColor,
    this.heroTag,
  });

  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  /// Teks badge (misal: "AR", "NEW", "HOT")
  final String? badge;
  final Color? badgeColor;

  /// Untuk Hero animation antar halaman
  final String? heroTag;

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    setState(() => _isHovered = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isHovered = false);
    _controller.reverse();
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isHovered = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final card = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            transform: Matrix4.identity()
              ..scale(_isHovered ? 1.02 : 1.0)
              ..translate(0.0, _isHovered ? -4.0 : 0.0),
            height: 72,
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _extractShadowColor(widget.gradient).withAlpha(_isHovered ? 150 : 100),
                  blurRadius: _isHovered ? 24 : 16,
                  offset: Offset(0, _isHovered ? 8 : 6),
                  spreadRadius: _isHovered ? 0 : -2,
                ),
              ],
            ),
            child: Stack(
            children: [
              // ─── Dekorasi lingkaran di sudut kanan ─────────────────────────
              Positioned(
                right: -12,
                top: -18,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(20),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: -24,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(15),
                  ),
                ),
              ),

              // ─── Konten utama ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // ikon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(35),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // teks
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: AppTypography.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.description,
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withAlpha(200),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // panah
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white.withAlpha(180),
                      size: 16,
                    ),
                  ],
                ),
              ),

              // ─── Badge (opsional) ───────────────────────────────────────────
              if (widget.badge != null)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: widget.badgeColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      widget.badge!,
                      style: AppTypography.badge.copyWith(
                        color: widget.badgeColor != null
                            ? Colors.white
                            : AppColors.accent,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ));

    if (widget.heroTag != null) {
      return Hero(tag: widget.heroTag!, child: card);
    }
    return card;
  }

  /// Ekstrak warna shadow dari gradient pertama
  Color _extractShadowColor(Gradient gradient) {
    if (gradient is LinearGradient && gradient.colors.isNotEmpty) {
      return gradient.colors.first.withAlpha(100);
    }
    return Colors.black.withAlpha(50);
  }
}
