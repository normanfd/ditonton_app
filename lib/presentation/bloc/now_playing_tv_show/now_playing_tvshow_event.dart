part of 'now_playing_tvshow_bloc.dart';

abstract class NowPlayingTvshowEvent extends Equatable {
  const NowPlayingTvshowEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTvshows extends NowPlayingTvshowEvent {}
