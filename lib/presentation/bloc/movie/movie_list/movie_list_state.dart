part of 'movie_list_bloc.dart';

class MovieListState extends Equatable {
  final List<Movie> nowPlayingMovies;
  final RequestState nowPlayingState;
  final String nowPlayingMessage;

  final List<Movie> popularMovies;
  final RequestState popularMoviesState;
  final String popularMessage;

  final List<Movie> topRatedMovies;
  final RequestState topRatedMoviesState;
  final String topRatedMessage;

  const MovieListState({
    this.nowPlayingMovies = const [],
    this.nowPlayingState = RequestState.Empty,
    this.nowPlayingMessage = '',
    this.popularMovies = const [],
    this.popularMoviesState = RequestState.Empty,
    this.popularMessage = '',
    this.topRatedMovies = const [],
    this.topRatedMoviesState = RequestState.Empty,
    this.topRatedMessage = '',
  });

  MovieListState copyWith({
    List<Movie>? nowPlayingMovies,
    RequestState? nowPlayingState,
    String? nowPlayingMessage,
    List<Movie>? popularMovies,
    RequestState? popularMoviesState,
    String? popularMessage,
    List<Movie>? topRatedMovies,
    RequestState? topRatedMoviesState,
    String? topRatedMessage,
  }) {
    return MovieListState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      nowPlayingMessage: nowPlayingMessage ?? this.nowPlayingMessage,
      popularMovies: popularMovies ?? this.popularMovies,
      popularMoviesState: popularMoviesState ?? this.popularMoviesState,
      popularMessage: popularMessage ?? this.popularMessage,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedMoviesState: topRatedMoviesState ?? this.topRatedMoviesState,
      topRatedMessage: topRatedMessage ?? this.topRatedMessage,
    );
  }

  @override
  List<Object> get props => [
        nowPlayingMovies,
        nowPlayingState,
        nowPlayingMessage,
        popularMovies,
        popularMoviesState,
        popularMessage,
        topRatedMovies,
        topRatedMoviesState,
        topRatedMessage,
      ];
}
