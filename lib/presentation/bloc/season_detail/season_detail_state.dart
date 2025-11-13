part of 'season_detail_bloc.dart';

abstract class SeasonDetailState extends Equatable {
  const SeasonDetailState();

  @override
  List<Object> get props => [];
}

// State Awal / Kosong
class SeasonDetailEmpty extends SeasonDetailState {}

// State Memuat
class SeasonDetailLoading extends SeasonDetailState {}

// State Sukses (membawa data episode)
class SeasonDetailLoaded extends SeasonDetailState {
  // Menggantikan _seasonDetail
  final List<SeasonEpisode> episodes;

  const SeasonDetailLoaded(this.episodes);

  @override
  List<Object> get props => [episodes];
}

// State Gagal (membawa pesan error)
class SeasonDetailError extends SeasonDetailState {
  // Menggantikan _message
  final String message;

  const SeasonDetailError(this.message);

  @override
  List<Object> get props => [message];
}
