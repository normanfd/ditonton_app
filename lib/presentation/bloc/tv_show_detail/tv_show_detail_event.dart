part of 'tv_show_detail_bloc.dart';

abstract class TvshowDetailEvent extends Equatable {
  const TvshowDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvshowDetail extends TvshowDetailEvent {
  final int id;

  const FetchTvshowDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends TvshowDetailEvent {
  final TvshowDetail tvshow;

  const AddToWatchlist(this.tvshow);

  @override
  List<Object> get props => [tvshow];
}

class RemoveFromWatchlist extends TvshowDetailEvent {
  final TvshowDetail tvshow;

  const RemoveFromWatchlist(this.tvshow);

  @override
  List<Object> get props => [tvshow];
}

class LoadWatchlistStatus extends TvshowDetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
