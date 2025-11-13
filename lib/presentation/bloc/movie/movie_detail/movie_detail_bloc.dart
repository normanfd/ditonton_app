import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';

import '../../../../common/failure.dart';

part 'movie_detail_event.dart';

part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddMovieToWatchlist>(_onAddToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveFromWatchlist);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(movieState: RequestState.Loading));

    final results = await Future.wait([
      getMovieDetail.execute(event.id),
      getMovieRecommendations.execute(event.id),
      getWatchListStatus.execute(event.id),
    ]);

    final detailResult = results[0] as Either<Failure, MovieDetail>;
    final recommendationResult = results[1] as Either<Failure, List<Movie>>;
    final watchlistStatusResult = results[2] as bool;

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          movieState: RequestState.Error,
          message: failure.message,
        ));
      },
      (movie) {
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              movieState: RequestState.Loaded,
              movie: movie,
              recommendationState: RequestState.Error,
              message: failure.message,
              isAddedToWatchlist: watchlistStatusResult,
            ));
          },
          (movies) {
            emit(state.copyWith(
              movieState: RequestState.Loaded,
              movie: movie,
              recommendationState: RequestState.Loaded,
              movieRecommendations: movies,
              isAddedToWatchlist: watchlistStatusResult,
            ));
          },
        );
      },
    );
  }

  Future<void> _onAddToWatchlist(
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);

    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );

    final newStatus = await getWatchListStatus.execute(event.movie.id);

    emit(state.copyWith(
      isAddedToWatchlist: newStatus,
      watchlistMessage: message,
    ));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);

    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );

    final newStatus = await getWatchListStatus.execute(event.movie.id);

    emit(state.copyWith(
      isAddedToWatchlist: newStatus,
      watchlistMessage: message,
    ));
  }
}
