import '../../../models/soal_model.dart';

class KuisScoringResult {
  final int poinSoal;
  final bool isBenarSoal;
  final int jawabanDipilih;

  KuisScoringResult({
    required this.poinSoal,
    required this.isBenarSoal,
    required this.jawabanDipilih,
  });
}

class KuisScoring {
  static KuisScoringResult hitung({
    required SoalModel soal,
    required int? selectedSingleIndex,
    required Set<int> selectedMultiIndices,
    required Map<int, bool> pernyataanJawaban,
  }) {
    int poinSoal = 0;
    bool isBenarSoal = false;
    int jawabanDipilih = 0;

    if (soal.tipe == TipeSoal.pilihanGanda && soal.jawabanBenarMulti == null) {
      isBenarSoal = selectedSingleIndex == soal.jawabanBenar;
      poinSoal = isBenarSoal ? soal.poin : 0;
      jawabanDipilih = selectedSingleIndex ?? -1;
    } else if (soal.tipe == TipeSoal.pilihanGanda && soal.jawabanBenarMulti != null) {
      final jbMulti = soal.jawabanBenarMulti ?? [];
      int correctSelected = selectedMultiIndices.where((idx) => jbMulti.contains(idx)).length;
      int wrongSelected = selectedMultiIndices.where((idx) => !jbMulti.contains(idx)).length;
      int netCorrect = correctSelected - wrongSelected;
      if (netCorrect < 0) netCorrect = 0;
      poinSoal = jbMulti.isNotEmpty ? (netCorrect / jbMulti.length * soal.poin).floor() : 0;
      isBenarSoal = jbMulti.isNotEmpty && netCorrect == jbMulti.length;
    } else if (soal.tipe == TipeSoal.benarSalah) {
      isBenarSoal = selectedSingleIndex == soal.jawabanBenar;
      poinSoal = isBenarSoal ? soal.poin : 0;
      jawabanDipilih = selectedSingleIndex ?? -1;
    } else if (soal.tipe == TipeSoal.pernyataanBS) {
      int correctSelected = 0;
      for (int i = 0; i < soal.pilihan.length; i++) {
        bool isBenar = soal.jawabanBenarMulti?.contains(i) ?? false;
        if (pernyataanJawaban[i] == isBenar) {
          correctSelected++;
        }
      }
      poinSoal = (correctSelected / soal.pilihan.length * soal.poin).floor();
      isBenarSoal = correctSelected == soal.pilihan.length;
    }

    return KuisScoringResult(
      poinSoal: poinSoal,
      isBenarSoal: isBenarSoal,
      jawabanDipilih: jawabanDipilih,
    );
  }
}
