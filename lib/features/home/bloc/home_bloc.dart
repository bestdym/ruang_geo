import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeLoadData extends HomeEvent {
  const HomeLoadData();
}

class HomeRefresh extends HomeEvent {
  const HomeRefresh();
}

class HomeSearchChanged extends HomeEvent {
  const HomeSearchChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.bangunRuangTerbaru,
    required this.bangunDatarTerbaru,
    required this.totalBangunRuang,
    required this.totalBangunDatar,
  });

  final List<BangunModel> bangunRuangTerbaru;
  final List<BangunModel> bangunDatarTerbaru;
  final int totalBangunRuang;
  final int totalBangunDatar;

  @override
  List<Object?> get props => [
        bangunRuangTerbaru,
        bangunDatarTerbaru,
        totalBangunRuang,
        totalBangunDatar,
      ];
}

class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
