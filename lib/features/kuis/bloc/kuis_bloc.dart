import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class KuisEvent extends Equatable {
  const KuisEvent();
  @override
  List<Object?> get props => [];
}

class KuisLoad extends KuisEvent {
  const KuisLoad({required this.kategori});
  final String kategori;
  @override
  List<Object?> get props => [kategori];
}

class KuisJawab extends KuisEvent {
  const KuisJawab({required this.indexJawaban});
  final int indexJawaban;
  @override
  List<Object?> get props => [indexJawaban];
}

class KuisSkip extends KuisEvent {
  const KuisSkip();
}

class KuisTimerTick extends KuisEvent {
  const KuisTimerTick();
}

class KuisJeda extends KuisEvent {
  const KuisJeda();
}

class KuisLanjut extends KuisEvent {
  const KuisLanjut();
}

class KuisSelesai extends KuisEvent {
  const KuisSelesai();
}

class KuisReset extends KuisEvent {
  const KuisReset();
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class KuisState extends Equatable {
  const KuisState();
  @override
  List<Object?> get props => [];
}

class KuisInitial extends KuisState {
  const KuisInitial();
}

class KuisLoading extends KuisState {
  const KuisLoading();
}

class KuisBerjalan extends KuisState {
  const KuisBerjalan({required this.sesi});
  final KuisSesiModel sesi;
  @override
  List<Object?> get props => [sesi];
}

/// State setelah menjawab - menampilkan feedback benar/salah
class KuisFeedback extends KuisState {
  const KuisFeedback({
    required this.sesi,
    required this.isBenar,
    required this.indexDipilih,
  });

  final KuisSesiModel sesi;
  final bool isBenar;
  final int indexDipilih;

  @override
  List<Object?> get props => [sesi, isBenar, indexDipilih];
}

class KuisJeda2 extends KuisState {
  const KuisJeda2({required this.sesi});
  final KuisSesiModel sesi;
  @override
  List<Object?> get props => [sesi];
}

class KuisSelesai2 extends KuisState {
  const KuisSelesai2({required this.hasil});
  final HasilKuisModel hasil;
  @override
  List<Object?> get props => [hasil];
}

class KuisError extends KuisState {
  const KuisError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
