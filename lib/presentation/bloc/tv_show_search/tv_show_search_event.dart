part of 'tv_show_search_bloc.dart';

abstract class TvshowSearchEvent extends Equatable {
  const TvshowSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends TvshowSearchEvent {
  final String query;

  const OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
