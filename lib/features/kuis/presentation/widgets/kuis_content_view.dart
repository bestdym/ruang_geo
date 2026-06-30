import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';
import 'package:ruang_geo/models/models.dart';
import 'widgets.dart'; 

class KuisContentView extends StatelessWidget {
  const KuisContentView({
    super.key,
    required this.soal,
    required this.isAnswerRevealed,
    required this.selectedSingleIndex,
    required this.selectedMultiIndices,
    required this.pernyataanJawaban,
    required this.onSingleSelect,
    required this.onMultiSelect,
    required this.onPernyataanBS,
  });

  final SoalModel soal;
  final bool isAnswerRevealed;
  final int? selectedSingleIndex;
  final Set<int> selectedMultiIndices;
  final Map<int, bool> pernyataanJawaban;

  final ValueChanged<int> onSingleSelect;
  final ValueChanged<int> onMultiSelect;
  final void Function(int, bool) onPernyataanBS;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KuisGambar(url: soal.gambarUrl),
            Text(
              soal.pertanyaan,
              style: AppTypography.titleLarge.copyWith(height: 1.4),
            ),
            if (soal.rumusHint != null && soal.rumusHint!.isNotEmpty) ...[
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

            // Pilihan Jawaban
            if (soal.tipe == TipeSoal.pilihanGanda && soal.jawabanBenarMulti == null) 
              ...List.generate(soal.pilihan.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: JawabanCard(
                    abjad: String.fromCharCode(65 + index),
                    teks: soal.pilihan[index],
                    isRevealed: isAnswerRevealed,
                    isSelected: selectedSingleIndex == index,
                    isCorrect: index == soal.jawabanBenar,
                    onTap: () => onSingleSelect(index),
                  ),
                );
              }),
              
            if (soal.tipe == TipeSoal.pilihanGanda && soal.jawabanBenarMulti != null)
              ...List.generate(soal.pilihan.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: JawabanCard(
                    abjad: String.fromCharCode(65 + index),
                    teks: soal.pilihan[index],
                    isRevealed: isAnswerRevealed,
                    isSelected: selectedMultiIndices.contains(index),
                    isCorrect: soal.jawabanBenarMulti!.contains(index),
                    onTap: () => onMultiSelect(index),
                  ),
                );
              }),
              
            if (soal.tipe == TipeSoal.benarSalah)
              ...List.generate(soal.pilihan.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: JawabanCard(
                    abjad: index == 0 ? 'B' : 'S',
                    teks: soal.pilihan[index],
                    isRevealed: isAnswerRevealed,
                    isSelected: selectedSingleIndex == index,
                    isCorrect: index == soal.jawabanBenar,
                    onTap: () => onSingleSelect(index),
                  ),
                );
              }),
              
            if (soal.tipe == TipeSoal.pernyataanBS)
              ...List.generate(soal.pilihan.length, (index) {
                bool isBenar = soal.jawabanBenarMulti?.contains(index) ?? false;
                bool? userJawaban = pernyataanJawaban[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PernyataanCard(
                    teks: soal.pilihan[index],
                    isRevealed: isAnswerRevealed,
                    userJawaban: userJawaban,
                    isCorrect: isBenar,
                    onBenar: () => onPernyataanBS(index, true),
                    onSalah: () => onPernyataanBS(index, false),
                  ),
                );
              }),

            // Penjelasan
            if (isAnswerRevealed && ((soal.penjelasan != null && soal.penjelasan!.isNotEmpty) || (soal.penjelasanGambarUrl != null && soal.penjelasanGambarUrl!.isNotEmpty))) ...[
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
                    if (soal.penjelasanGambarUrl != null && soal.penjelasanGambarUrl!.isNotEmpty)
                       KuisGambar(url: soal.penjelasanGambarUrl),
                    if (soal.penjelasan != null && soal.penjelasan!.isNotEmpty)
                      Text(soal.penjelasan!, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
