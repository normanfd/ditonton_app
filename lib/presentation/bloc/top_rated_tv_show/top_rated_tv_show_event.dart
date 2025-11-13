part of 'top_rated_tv_show_bloc.dart';

abstract class TopRatedTvshowEvent extends Equatable {
  const TopRatedTvshowEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTvshows extends TopRatedTvshowEvent {}