import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';

part 'top_rated_movie_event.dart';

part 'top_rated_movie_state.dart';

class TopRatedMoviesBloc extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc({required this.getTopRatedMovies}) : super(TopRatedMoviesEmpty()) {
    on<FetchTopRatedMovies>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchTopRatedMovies(
    FetchTopRatedMovies event,
    Emitter<TopRatedMoviesState> emit,
  ) async {
    emit(TopRatedMoviesLoading());

    final result = await getTopRatedMovies.execute();

    result.fold(
      (failure) {
        emit(TopRatedMoviesError(failure.message));
      },
      (moviesData) {
        emit(TopRatedMoviesLoaded(moviesData));
      },
    );
  }
}
