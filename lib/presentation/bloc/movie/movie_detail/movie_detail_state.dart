part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final RequestState movieState;
  final MovieDetail? movie;

  final RequestState recommendationState;
  final List<Movie> movieRecommendations;

  final bool isAddedToWatchlist;
  final String watchlistMessage;

  final String message;

  const MovieDetailState({
    this.movieState = RequestState.Empty,
    this.movie,
    this.recommendationState = RequestState.Empty,
    this.movieRecommendations = const [],
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
    this.message = '',
  });

  MovieDetailState copyWith({
    RequestState? movieState,
    MovieDetail? movie,
    RequestState? recommendationState,
    List<Movie>? movieRecommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? message,
  }) {
    return MovieDetailState(
      movieState: movieState ?? this.movieState,
      movie: movie ?? this.movie,
      recommendationState: recommendationState ?? this.recommendationState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? '',
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        movieState,
        movie,
        recommendationState,
        movieRecommendations,
        isAddedToWatchlist,
        watchlistMessage,
        message,
      ];
}
