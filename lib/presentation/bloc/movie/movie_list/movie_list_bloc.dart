import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';


part 'movie_list_event.dart';

part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListState()) {
    on<FetchAllMovieLists>(_onFetchAllMovieLists);
  }

  Future<void> _onFetchAllMovieLists(
    FetchAllMovieLists event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(
      nowPlayingState: RequestState.Loading,
      popularMoviesState: RequestState.Loading,
      topRatedMoviesState: RequestState.Loading,
    ));

    final results = await Future.wait([
      getNowPlayingMovies.execute(),
      getPopularMovies.execute(),
      getTopRatedMovies.execute(),
    ]);

    final nowPlayingResult = results[0];
    final popularResult = results[1];
    final topRatedResult = results[2];

    var newState = state;

    nowPlayingResult.fold(
      (failure) =>
          newState = newState.copyWith(nowPlayingState: RequestState.Error, nowPlayingMessage: failure.message),
      (data) => newState = newState.copyWith(nowPlayingState: RequestState.Loaded, nowPlayingMovies: data),
    );

    popularResult.fold(
      (failure) =>
          newState = newState.copyWith(popularMoviesState: RequestState.Error, popularMessage: failure.message),
      (data) => newState = newState.copyWith(popularMoviesState: RequestState.Loaded, popularMovies: data),
    );

    topRatedResult.fold(
      (failure) =>
          newState = newState.copyWith(topRatedMoviesState: RequestState.Error, topRatedMessage: failure.message),
      (data) => newState = newState.copyWith(topRatedMoviesState: RequestState.Loaded, topRatedMovies: data),
    );

    emit(newState);
  }
}
