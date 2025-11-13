part of 'watchlist_tv_show_bloc.dart';

abstract class WatchlistTvshowState extends Equatable {
  const WatchlistTvshowState();

  @override
  List<Object> get props => [];
}

class WatchlistTvshowEmpty extends WatchlistTvshowState {}

class WatchlistTvshowLoading extends WatchlistTvshowState {}

class WatchlistTvshowLoaded extends WatchlistTvshowState {
  final List<Tvshow> tvshows;

  const WatchlistTvshowLoaded(this.tvshows);

  @override
  List<Object> get props => [tvshows];
}

class WatchlistTvshowError extends WatchlistTvshowState {
  final String message;

  const WatchlistTvshowError(this.message);

  @override
  List<Object> get props => [message];
}