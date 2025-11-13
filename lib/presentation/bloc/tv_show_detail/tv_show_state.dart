part of 'tv_show_detail_bloc.dart';

class TvshowDetailState extends Equatable {
  // --- State untuk Detail TV Show Utama ---
  final RequestState tvshowState;
  final TvshowDetail? tvshow;

  // --- State untuk Rekomendasi ---
  final RequestState recommendationState;
  final List<Tvshow> tvshowRecommendations;

  // --- State untuk Watchlist ---
  final bool isAddedToWatchlist;

  final String watchlistMessage;
  final String message;

  const TvshowDetailState({
    this.tvshowState = RequestState.Empty,
    this.tvshow,
    this.recommendationState = RequestState.Empty,
    this.tvshowRecommendations = const [],
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
    this.message = '',
  });

  TvshowDetailState copyWith({
    RequestState? tvshowState,
    TvshowDetail? tvshow,
    RequestState? recommendationState,
    List<Tvshow>? tvshowRecommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? message,
  }) {
    return TvshowDetailState(
      tvshowState: tvshowState ?? this.tvshowState,
      tvshow: tvshow ?? this.tvshow,
      recommendationState: recommendationState ?? this.recommendationState,
      tvshowRecommendations:
          tvshowRecommendations ?? this.tvshowRecommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? '',
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        tvshowState,
        tvshow,
        recommendationState,
        tvshowRecommendations,
        isAddedToWatchlist,
        watchlistMessage,
        message,
      ];
}
