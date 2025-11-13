part of 'watchlist_tv_show_bloc.dart';

abstract class WatchlistTvshowEvent extends Equatable {
  const WatchlistTvshowEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTvshows extends WatchlistTvshowEvent {}