import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';

part 'movie_search_event.dart';

part 'movie_search_state.dart';

const _duration = Duration(milliseconds: 500);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies}) : super(MovieSearchEmpty()) {
    on<OnMovieQueryChanged>(
      _onQueryChanged,
      transformer: debounce(_duration),
    );
  }

  Future<void> _onQueryChanged(
    OnMovieQueryChanged event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query;
    if (query.isEmpty) {
      emit(MovieSearchEmpty());
      return;
    }

    emit(MovieSearchLoading());

    final result = await searchMovies.execute(query);

    result.fold(
      (failure) {
        emit(MovieSearchError(failure.message));
      },
      (data) {
        emit(MovieSearchLoaded(data));
      },
    );
  }
}
