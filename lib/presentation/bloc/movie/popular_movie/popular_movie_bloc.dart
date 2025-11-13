import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/movie/get_popular_movies.dart';

part 'popular_movie_event.dart';

part 'popular_movie_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(PopularMoviesEmpty()) {
    on<FetchPopularMovies>(_onFetchPopularMovies);
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMovies event,
    Emitter<PopularMoviesState> emit,
  ) async {
    emit(PopularMoviesLoading());

    final result = await getPopularMovies.execute();

    result.fold(
      (failure) {
        emit(PopularMoviesError(failure.message));
      },
      (moviesData) {
        emit(PopularMoviesLoaded(moviesData));
      },
    );
  }
}
