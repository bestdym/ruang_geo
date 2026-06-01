import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';

/// Halaman bermain kuis
class KuisPlayPage extends StatefulWidget {
  const KuisPlayPage({super.key, required this.kategori});

  final String kategori; // 'ruang', 'datar', atau 'campuran'

  @override
  State<KuisPlayPage> createState() => _KuisPlayPageState();
}

class _KuisPlayPageState extends State<KuisPlayPage> {
  late final List<SoalModel> _soalList;
  int _currentIndex = 0;
  int _score = 0;
  int _poinDidapat = 0;

  // Timer
  Timer? _timer;
  int _timeLeft = 30; // 30 detik per soal

  // State Jawaban
  int? _selectedAnswerIndex;
  bool _isAnswerRevealed = false;

  @override
  void initState() {
    super.initState();
    _initSoal();
    _startTimer();
  }

  void _initSoal() {
    // Filter soal berdasarkan kategori
    final allSoal = List<SoalModel>.from(DummyData.soalKuisList);
    allSoal.shuffle(); // Acak urutan soal

    if (widget.kategori == 'ruang') {
      _soalList = allSoal.where((s) => s.bangunId.startsWith('br_')).take(10).toList();
    } else if (widget.kategori == 'datar') {
      _soalList = allSoal.where((s) => s.bangunId.startsWith('bd_')).take(10).toList();
    } else {
      _soalList = allSoal.take(10).toList();
    }
  }

  void _startTimer() {
    _timeLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        // Waktu habis
        _timer?.cancel();
        if (!_isAnswerRevealed) {
          _handleAnswerTimeout();
        }
      }
    });
  }

  void _handleAnswerTimeout() {
    setState(() {
      _isAnswerRevealed = true;
      _selectedAnswerIndex = -1; // -1 berarti tidak menjawab
    });
  }

  void _handleAnswerSelect(int index) {
    if (_isAnswerRevealed) return; // Tidak bisa pilih lagi jika sudah terjawab
    
    setState(() {
      _selectedAnswerIndex = index;
      _isAnswerRevealed = true;
      _timer?.cancel();

      // Cek benar/salah
      final currentSoal = _soalList[_currentIndex];
      if (index == currentSoal.jawabanBenar) {
        _score++;
        _poinDidapat += currentSoal.poin;
      }
    });
  }

  void _nextSoal() {
    if (_currentIndex < _soalList.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _isAnswerRevealed = false;
        _startTimer();
      });
    } else {
      // Selesai, ke halaman hasil
      context.pushReplacement(
        '/kuis/${widget.kategori}/hasil',
        extra: {'score': _score, 'total': _soalList.length, 'poin': _poinDidapat},
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_soalList.isEmpty) {
      return const Scaffold(body: Center(child: Text('Tidak ada soal.')));
    }

    final soal = _soalList[_currentIndex];
    final progress = (_currentIndex + 1) / _soalList.length;
    final isLastSoal = _currentIndex == _soalList.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarCustom(
        onBack: () {
          _timer?.cancel();
          context.pop();
        },
        title: 'Soal ${_currentIndex + 1} dari ${_soalList.length}',
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.warning.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, color: AppColors.warning, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$_poinDidapat',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.outlineVariant,
            color: AppColors.primary,
            minHeight: 4,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Timer & Kategori ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.kategori.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: _timeLeft <= 10 ? AppColors.error : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '00:${_timeLeft.toString().padLeft(2, '0')}',
                        style: AppTypography.labelMedium.copyWith(
                          color: _timeLeft <= 10 ? AppColors.error : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Pertanyaan ───────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      soal.pertanyaan,
                      style: AppTypography.titleLarge.copyWith(height: 1.4),
                    ),
                    if (soal.rumusHint != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.secondary.withAlpha(50)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_outline_rounded, color: AppColors.secondary, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Hint: ${soal.rumusHint}',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.secondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),

                    // ─── Pilihan Jawaban ───────────────────────────────────
                    ...List.generate(soal.pilihan.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _JawabanCard(
                          abjad: String.fromCharCode(65 + index), // A, B, C, D
                          teks: soal.pilihan[index],
                          isRevealed: _isAnswerRevealed,
                          isSelected: _selectedAnswerIndex == index,
                          isCorrect: index == soal.jawabanBenar,
                          onTap: () => _handleAnswerSelect(index),
                        ),
                      );
                    }),

                    // ─── Penjelasan (Muncul setelah jawab) ─────────────────
                    if (_isAnswerRevealed) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Penjelasan:',
                              style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              soal.penjelasan,
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 100), // padding untuk button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // ─── Tombol Selanjutnya ───────────────────────────────────────────
      bottomSheet: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _isAnswerRevealed ? _nextSoal : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: Text(isLastSoal ? 'Selesai & Lihat Hasil' : 'Selanjutnya'),
        ),
      ),
    );
  }
}

class _JawabanCard extends StatelessWidget {
  const _JawabanCard({
    required this.abjad,
    required this.teks,
    required this.isRevealed,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  });

  final String abjad;
  final String teks;
  final bool isRevealed;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color getBorderColor() {
      if (!isRevealed) return isSelected ? AppColors.secondary : AppColors.outlineVariant;
      if (isCorrect) return AppColors.success;
      if (isSelected && !isCorrect) return AppColors.error;
      return AppColors.outlineVariant;
    }

    Color getBgColor() {
      if (!isRevealed) return isSelected ? AppColors.secondary.withAlpha(20) : AppColors.surface;
      if (isCorrect) return AppColors.success.withAlpha(20);
      if (isSelected && !isCorrect) return AppColors.error.withAlpha(20);
      return AppColors.surface;
    }

    IconData? getIcon() {
      if (!isRevealed) return null;
      if (isCorrect) return Icons.check_circle_rounded;
      if (isSelected && !isCorrect) return Icons.cancel_rounded;
      return null;
    }

    Color getIconColor() {
      if (isCorrect) return AppColors.success;
      return AppColors.error;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: getBgColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: getBorderColor(), width: isSelected || (isRevealed && isCorrect) ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isRevealed && isCorrect
                    ? AppColors.success
                    : (isSelected && !isRevealed ? AppColors.secondary : AppColors.surfaceVariant),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  abjad,
                  style: AppTypography.titleSmall.copyWith(
                    color: (isRevealed && isCorrect) || (isSelected && !isRevealed)
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                teks,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (getIcon() != null) ...[
              const SizedBox(width: 12),
              Icon(getIcon(), color: getIconColor()),
            ],
          ],
        ),
      ),
    );
  }
}
