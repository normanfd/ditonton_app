part of 'popular_tv_show_bloc.dart';

abstract class PopularTvshowEvent extends Equatable {
  const PopularTvshowEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTvshows extends PopularTvshowEvent {}