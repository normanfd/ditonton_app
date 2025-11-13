part of 'popular_tv_show_bloc.dart';

abstract class PopularTvshowState extends Equatable {
  const PopularTvshowState();

  @override
  List<Object> get props => [];
}

class PopularTvshowEmpty extends PopularTvshowState {}

class PopularTvshowLoading extends PopularTvshowState {}

class PopularTvshowLoaded extends PopularTvshowState {
  final List<Tvshow> tvshows;

  const PopularTvshowLoaded(this.tvshows);

  @override
  List<Object> get props => [tvshows];
}

class PopularTvshowError extends PopularTvshowState {
  final String message;

  const PopularTvshowError(this.message);

  @override
  List<Object> get props => [message];
}
