part of 'top_rated_tv_show_bloc.dart';

abstract class TopRatedTvshowState extends Equatable {
  const TopRatedTvshowState();

  @override
  List<Object> get props => [];
}

class TopRatedTvshowEmpty extends TopRatedTvshowState {}

class TopRatedTvshowLoading extends TopRatedTvshowState {}

class TopRatedTvshowLoaded extends TopRatedTvshowState {
  final List<Tvshow> tvshows;

  const TopRatedTvshowLoaded(this.tvshows);

  @override
  List<Object> get props => [tvshows];
}

class TopRatedTvshowError extends TopRatedTvshowState {
  final String message;

  const TopRatedTvshowError(this.message);

  @override
  List<Object> get props => [message];
}
