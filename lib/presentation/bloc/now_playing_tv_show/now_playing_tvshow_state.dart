part of 'now_playing_tvshow_bloc.dart';

abstract class NowPlayingTvshowState extends Equatable {
  const NowPlayingTvshowState();

  @override
  List<Object> get props => [];
}

class NowPlayingTvshowEmpty extends NowPlayingTvshowState {}

class NowPlayingTvshowLoading extends NowPlayingTvshowState {}

class NowPlayingTvshowLoaded extends NowPlayingTvshowState {
  final List<Tvshow> tvshows;

  const NowPlayingTvshowLoaded(this.tvshows);

  @override
  List<Object> get props => [tvshows];
}

class NowPlayingTvshowError extends NowPlayingTvshowState {
  final String message;

  const NowPlayingTvshowError(this.message);

  @override
  List<Object> get props => [message];
}
