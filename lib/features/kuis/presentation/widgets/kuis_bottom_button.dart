import 'package:flutter/material.dart';
import 'package:ruang_geo/core/core.dart';

class KuisBottomButton extends StatelessWidget {
  const KuisBottomButton({
    super.key,
    required this.isAnswerRevealed,
    required this.isLastSoal,
    required this.needsSubmitButton,
    required this.onNext,
    required this.onSubmit,
  });

  final bool isAnswerRevealed;
  final bool isLastSoal;
  final bool needsSubmitButton;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: isAnswerRevealed 
          ? onNext 
          : (needsSubmitButton ? onSubmit : null),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
        ),
        child: Text(isAnswerRevealed ? (isLastSoal ? 'Selesai & Lihat Hasil' : 'Selanjutnya') : 'Submit Jawaban'),
      ),
    );
  }
}
