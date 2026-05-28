import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class BangunDatarEvent extends Equatable {
  const BangunDatarEvent();
  @override
  List<Object?> get props => [];
}

class BangunDatarLoad extends BangunDatarEvent {
  const BangunDatarLoad();
}

class BangunDatarSearch extends BangunDatarEvent {
  const BangunDatarSearch(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class BangunDatarFilterTingkat extends BangunDatarEvent {
  const BangunDatarFilterTingkat(this.tingkat);
  final TingkatKesulitan? tingkat;
  @override
  List<Object?> get props => [tingkat];
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class BangunDatarState extends Equatable {
  const BangunDatarState();
  @override
  List<Object?> get props => [];
}

class BangunDatarInitial extends BangunDatarState {
  const BangunDatarInitial();
}

class BangunDatarLoading extends BangunDatarState {
  const BangunDatarLoading();
}

class BangunDatarLoaded extends BangunDatarState {
  const BangunDatarLoaded({
    required this.semuaBangun,
    required this.filteredBangun,
    this.searchQuery = '',
    this.filterTingkat,
  });

  final List<BangunModel> semuaBangun;
  final List<BangunModel> filteredBangun;
  final String searchQuery;
  final TingkatKesulitan? filterTingkat;

  BangunDatarLoaded copyWith({
    List<BangunModel>? semuaBangun,
    List<BangunModel>? filteredBangun,
    String? searchQuery,
    TingkatKesulitan? filterTingkat,
  }) {
    return BangunDatarLoaded(
      semuaBangun: semuaBangun ?? this.semuaBangun,
      filteredBangun: filteredBangun ?? this.filteredBangun,
      searchQuery: searchQuery ?? this.searchQuery,
      filterTingkat: filterTingkat ?? this.filterTingkat,
    );
  }

  @override
  List<Object?> get props =>
      [semuaBangun, filteredBangun, searchQuery, filterTingkat];
}

class BangunDatarError extends BangunDatarState {
  const BangunDatarError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
