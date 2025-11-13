part of 'tv_show_list_bloc.dart';

class TvshowListState extends Equatable {
  // --- State untuk Now Playing ---
  final List<Tvshow> nowPlayingTvshows;
  final RequestState nowPlayingState;
  final String nowPlayingMessage;

  // --- State untuk Popular ---
  final List<Tvshow> popularTvshows;
  final RequestState popularTvshowsState;
  final String popularMessage;

  // --- State untuk Top Rated ---
  final List<Tvshow> topRatedTvshows;
  final RequestState topRatedTvshowsState;
  final String topRatedMessage;

  // Konstruktor dengan nilai default
  const TvshowListState({
    this.nowPlayingTvshows = const [],
    this.nowPlayingState = RequestState.Empty,
    this.nowPlayingMessage = '',
    this.popularTvshows = const [],
    this.popularTvshowsState = RequestState.Empty,
    this.popularMessage = '',
    this.topRatedTvshows = const [],
    this.topRatedTvshowsState = RequestState.Empty,
    this.topRatedMessage = '',
  });

  // Method copyWith untuk membuat state baru
  TvshowListState copyWith({
    List<Tvshow>? nowPlayingTvshows,
    RequestState? nowPlayingState,
    String? nowPlayingMessage,
    List<Tvshow>? popularTvshows,
    RequestState? popularTvshowsState,
    String? popularMessage,
    List<Tvshow>? topRatedTvshows,
    RequestState? topRatedTvshowsState,
    String? topRatedMessage,
  }) {
    return TvshowListState(
      nowPlayingTvshows: nowPlayingTvshows ?? this.nowPlayingTvshows,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      nowPlayingMessage: nowPlayingMessage ?? this.nowPlayingMessage,
      popularTvshows: popularTvshows ?? this.popularTvshows,
      popularTvshowsState: popularTvshowsState ?? this.popularTvshowsState,
      popularMessage: popularMessage ?? this.popularMessage,
      topRatedTvshows: topRatedTvshows ?? this.topRatedTvshows,
      topRatedTvshowsState: topRatedTvshowsState ?? this.topRatedTvshowsState,
      topRatedMessage: topRatedMessage ?? this.topRatedMessage,
    );
  }

  @override
  List<Object> get props => [
    nowPlayingTvshows,
    nowPlayingState,
    nowPlayingMessage,
    popularTvshows,
    popularTvshowsState,
    popularMessage,
    topRatedTvshows,
    topRatedTvshowsState,
    topRatedMessage,
  ];
}