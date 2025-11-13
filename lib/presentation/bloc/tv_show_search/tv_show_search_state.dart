part of 'tv_show_search_bloc.dart';

abstract class TvshowSearchState extends Equatable {
  const TvshowSearchState();

  @override
  List<Object> get props => [];
}

class TvshowSearchEmpty extends TvshowSearchState {}

class TvshowSearchLoading extends TvshowSearchState {}

class TvshowSearchLoaded extends TvshowSearchState {
  final List<Tvshow> result;

  const TvshowSearchLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TvshowSearchError extends TvshowSearchState {
  final String message;

  const TvshowSearchError(this.message);

  @override
  List<Object> get props => [message];
}
