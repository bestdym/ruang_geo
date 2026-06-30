import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';
import 'package:ruang_geo/models/models.dart';
import 'package:ruang_geo/features/kuis/services/kuis_service.dart';
import 'package:ruang_geo/features/kuis/presentation/widgets/widgets.dart';
import 'package:ruang_geo/core/services/supabase_service.dart';

/// Halaman bermain kuis - data dari Supabase
class KuisPlayPage extends StatefulWidget {
  const KuisPlayPage({super.key, required this.kategori});

  final String kategori; // 'ruang', 'datar', atau 'campuran'

  @override
  State<KuisPlayPage> createState() => _KuisPlayPageState();
}

class _KuisPlayPageState extends State<KuisPlayPage> {
  final _kuisService = KuisService();

  List<SoalModel> _soalList = [];
  int _currentIndex = 0;
  int _score = 0; // Soal benar sepenuhnya
  int _poinDidapat = 0;
  String? _sesiId;
  int _totalDurasi = 0;

  // Loading & Error state
  bool _isLoading = true;
  String? _errorMessage;

  // Timer
  Timer? _timer;
  Timer? _durasiTimer;
  int _timeLeft = 60;

  // State Jawaban
  int? _selectedSingleIndex;
  Set<int> _selectedMultiIndices = {};
  Map<int, bool> _pernyataanJawaban = {};
  bool _isAnswerRevealed = false;

  @override
  void initState() {
    super.initState();
    _loadSoal();
  }

  Future<void> _loadSoal() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final soalList = await _kuisService.getSoalByKategori(widget.kategori);

      if (soalList.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Belum ada soal untuk kategori ini.\nCek kembali nanti ya!';
        });
        return;
      }

      soalList.shuffle();
      final userId = supabase.auth.currentUser?.id;
      String? sesiId;
      if (userId != null) {
        sesiId = await _kuisService.mulaiSesi(userId, widget.kategori, soalList.length);
      }

      setState(() {
        _soalList = soalList;
        _sesiId = sesiId;
        _isLoading = false;
      });

      _startTimer();
      _startDurasiTimer();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat soal. Periksa koneksi internet Anda.';
      });
    }
  }

  void _startTimer() {
    _timeLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
        if (!_isAnswerRevealed) _handleSubmit();
      }
    });
  }

  void _startDurasiTimer() {
    _durasiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _totalDurasi++;
    });
  }

  void _handleSingleSelect(int index) {
    if (_isAnswerRevealed) return;
    setState(() {
      _selectedSingleIndex = index;
    });
    final soal = _soalList[_currentIndex];
    // Jika pilihan ganda tunggal atau benar-salah, langsung submit
    if (soal.tipe == TipeSoal.pilihanGanda || soal.tipe == TipeSoal.benarSalah) {
      _handleSubmit();
    }
  }

  void _toggleMultiSelect(int index) {
    if (_isAnswerRevealed) return;
    setState(() {
      if (_selectedMultiIndices.contains(index)) {
        _selectedMultiIndices.remove(index);
      } else {
        _selectedMultiIndices.add(index);
      }
    });
  }

  void _setPernyataanBS(int index, bool isBenar) {
    if (_isAnswerRevealed) return;
    setState(() {
      _pernyataanJawaban[index] = isBenar;
    });
  }

  void _handleSubmit() {
    if (_isAnswerRevealed) return;

    final soal = _soalList[_currentIndex];
    int poinSoal = 0;
    bool isBenarSoal = false;
    
    int jawabanDipilih = 0;

    if (soal.tipe == TipeSoal.pilihanGanda && soal.jawabanBenarMulti == null) {
      isBenarSoal = _selectedSingleIndex == soal.jawabanBenar;
      poinSoal = isBenarSoal ? soal.poin : 0;
      jawabanDipilih = _selectedSingleIndex ?? -1;
    } else if (soal.tipe == TipeSoal.pilihanGanda && soal.jawabanBenarMulti != null) {
      int correctSelected = _selectedMultiIndices.where((idx) => soal.jawabanBenarMulti!.contains(idx)).length;
      int wrongSelected = _selectedMultiIndices.where((idx) => !soal.jawabanBenarMulti!.contains(idx)).length;
      int netCorrect = correctSelected - wrongSelected;
      if (netCorrect < 0) netCorrect = 0;
      poinSoal = (netCorrect / soal.jawabanBenarMulti!.length * soal.poin).floor();
      isBenarSoal = netCorrect == soal.jawabanBenarMulti!.length;
    } else if (soal.tipe == TipeSoal.benarSalah) {
      isBenarSoal = _selectedSingleIndex == soal.jawabanBenar;
      poinSoal = isBenarSoal ? soal.poin : 0;
      jawabanDipilih = _selectedSingleIndex ?? -1;
    } else if (soal.tipe == TipeSoal.pernyataanBS) {
      int correctSelected = 0;
      for (int i = 0; i < soal.pilihan.length; i++) {
        bool isBenar = soal.jawabanBenarMulti?.contains(i) ?? false;
        if (_pernyataanJawaban[i] == isBenar) {
          correctSelected++;
        }
      }
      poinSoal = (correctSelected / soal.pilihan.length * soal.poin).floor();
      isBenarSoal = correctSelected == soal.pilihan.length;
    }

    setState(() {
      _isAnswerRevealed = true;
      _timer?.cancel();
      if (isBenarSoal) {
        _score++;
      }
      _poinDidapat += poinSoal;
    });

    if (_sesiId != null) {
      _kuisService.simpanJawaban(
        sesiId: _sesiId!,
        soalId: soal.id,
        jawabanDipilih: jawabanDipilih,
        isBenar: isBenarSoal,
        poin: poinSoal,
      );
    }
  }

  Future<void> _nextSoal() async {
    if (_currentIndex < _soalList.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedSingleIndex = null;
        _selectedMultiIndices.clear();
        _pernyataanJawaban.clear();
        _isAnswerRevealed = false;
        _startTimer();
      });
    } else {
      _timer?.cancel();
      _durasiTimer?.cancel();

      final userId = supabase.auth.currentUser?.id;
      if (_sesiId != null && userId != null) {
        await _kuisService.selesaikanSesi(
          sesiId: _sesiId!,
          userId: userId,
          kategori: widget.kategori,
          soalBenar: _score,
          totalSoal: _soalList.length,
          totalPoin: _poinDidapat,
          durasiDetik: _totalDurasi,
        );
      }

      if (mounted) {
        context.pushReplacement(
          '/kuis/${widget.kategori}/hasil',
          extra: {
            'score': _score,
            'total': _soalList.length,
            'poin': _poinDidapat,
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _durasiTimer?.cancel();
    super.dispose();
  }
  
  Widget _buildGambar(String? url) {
    if (url == null || url.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const KuisLoadingView();
    if (_errorMessage != null) return KuisErrorView(errorMessage: _errorMessage, onRetry: _loadSoal);
    if (_soalList.isEmpty) {
      return const Scaffold(body: Center(child: Text('Tidak ada soal.')));
    }

    final soal = _soalList[_currentIndex];
    final progress = (_currentIndex + 1) / _soalList.length;
    final isLastSoal = _currentIndex == _soalList.length - 1;

    bool needsSubmitButton = (soal.tipe == TipeSoal.pilihanGanda && soal.jawabanBenarMulti != null) || 
                             soal.tipe == TipeSoal.pernyataanBS;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarCustom(
        onBack: () {
          _timer?.cancel();
          _durasiTimer?.cancel();
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
            KuisHeader(kategori: widget.kategori, timeLeft: _timeLeft),

            // Pertanyaan
            KuisContentView(
              soal: soal,
              isAnswerRevealed: _isAnswerRevealed,
              selectedSingleIndex: _selectedSingleIndex,
              selectedMultiIndices: _selectedMultiIndices,
              pernyataanJawaban: _pernyataanJawaban,
              onSingleSelect: _handleSingleSelect,
              onMultiSelect: _toggleMultiSelect,
              onPernyataanBS: _setPernyataanBS,
            ),
          ],
        ),
      ),
      bottomSheet: KuisBottomButton(
        isAnswerRevealed: _isAnswerRevealed,
        isLastSoal: isLastSoal,
        needsSubmitButton: needsSubmitButton,
        onNext: _nextSoal,
        onSubmit: _handleSubmit,
      ),
    );
  }


}
