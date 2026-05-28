import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class BangunRuangEvent extends Equatable {
  const BangunRuangEvent();
  @override
  List<Object?> get props => [];
}

class BangunRuangLoad extends BangunRuangEvent {
  const BangunRuangLoad();
}

class BangunRuangSearch extends BangunRuangEvent {
  const BangunRuangSearch(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class BangunRuangFilterTingkat extends BangunRuangEvent {
  const BangunRuangFilterTingkat(this.tingkat);
  final TingkatKesulitan? tingkat;
  @override
  List<Object?> get props => [tingkat];
}

class BangunRuangSelectDetail extends BangunRuangEvent {
  const BangunRuangSelectDetail(this.bangunId);
  final String bangunId;
  @override
  List<Object?> get props => [bangunId];
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class BangunRuangState extends Equatable {
  const BangunRuangState();
  @override
  List<Object?> get props => [];
}

class BangunRuangInitial extends BangunRuangState {
  const BangunRuangInitial();
}

class BangunRuangLoading extends BangunRuangState {
  const BangunRuangLoading();
}

class BangunRuangLoaded extends BangunRuangState {
  const BangunRuangLoaded({
    required this.semuaBangun,
    required this.filteredBangun,
    this.searchQuery = '',
    this.filterTingkat,
  });

  final List<BangunModel> semuaBangun;
  final List<BangunModel> filteredBangun;
  final String searchQuery;
  final TingkatKesulitan? filterTingkat;

  BangunRuangLoaded copyWith({
    List<BangunModel>? semuaBangun,
    List<BangunModel>? filteredBangun,
    String? searchQuery,
    TingkatKesulitan? filterTingkat,
  }) {
    return BangunRuangLoaded(
      semuaBangun: semuaBangun ?? this.semuaBangun,
      filteredBangun: filteredBangun ?? this.filteredBangun,
      searchQuery: searchQuery ?? this.searchQuery,
      filterTingkat: filterTingkat ?? this.filterTingkat,
    );
  }

  @override
  List<Object?> get props => [
        semuaBangun,
        filteredBangun,
        searchQuery,
        filterTingkat,
      ];
}

class BangunRuangDetailLoaded extends BangunRuangState {
  const BangunRuangDetailLoaded(this.bangun);
  final BangunModel bangun;
  @override
  List<Object?> get props => [bangun];
}

class BangunRuangError extends BangunRuangState {
  const BangunRuangError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
