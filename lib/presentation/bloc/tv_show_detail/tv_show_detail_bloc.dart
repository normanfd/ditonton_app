import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/failure.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entities/Tvshow.dart';
import '../../../domain/entities/tvshow_detail.dart';
import '../../../domain/usecases/tvshow/get_tvshow_detail.dart';
import '../../../domain/usecases/tvshow/get_tvshow_recommendations.dart';
import '../../../domain/usecases/tvshow/get_tvshow_watchlist_status.dart';
import '../../../domain/usecases/tvshow/remove_tvshow_watchlist.dart';
import '../../../domain/usecases/tvshow/save_tvshow_watchlist.dart';

part 'tv_show_state.dart';

part 'tv_show_detail_event.dart';

class TvshowDetailBloc extends Bloc<TvshowDetailEvent, TvshowDetailState> {
  final GetTvshowDetail getTvshowDetail;
  final GetTvshowRecommendations getTvshowRecommendations;
  final GetTvshowWatchListStatus getWatchListStatus;
  final SaveTvshowWatchlist saveWatchlist;
  final RemoveTvshowWatchlist removeWatchlist;

  TvshowDetailBloc({
    required this.getTvshowDetail,
    required this.getTvshowRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvshowDetailState()) {
    on<FetchTvshowDetail>(_onFetchTvshowDetail);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
  }

  Future<void> _onFetchTvshowDetail(
    FetchTvshowDetail event,
    Emitter<TvshowDetailState> emit,
  ) async {
    emit(state.copyWith(tvshowState: RequestState.Loading));

    final results = await Future.wait([
      getTvshowDetail.execute(event.id),
      getTvshowRecommendations.execute(event.id),
      getWatchListStatus.execute(event.id),
    ]);

    final detailResult = results[0] as Either<Failure, TvshowDetail>;
    final recommendationResult = results[1] as Either<Failure, List<Tvshow>>;
    final watchlistStatusResult = results[2] as bool;

    detailResult.fold(
      (failure) {
        // Gagal fetch detail
        emit(state.copyWith(
          tvshowState: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvshow) {
        // Sukses fetch detail, sekarang proses hasil Rekomendasi
        recommendationResult.fold(
          (failure) {
            // Sukses detail, TAPI GAGAL rekomendasi
            emit(state.copyWith(
              tvshowState: RequestState.Loaded,
              tvshow: tvshow,
              recommendationState: RequestState.Error,
              message: failure.message,
              isAddedToWatchlist: watchlistStatusResult, // Set status
            ));
          },
          (tvshows) {
            // Sukses detail DAN Sukses rekomendasi
            emit(state.copyWith(
              tvshowState: RequestState.Loaded,
              tvshow: tvshow,
              recommendationState: RequestState.Loaded,
              tvshowRecommendations: tvshows,
              isAddedToWatchlist: watchlistStatusResult, // Set status
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<TvshowDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> _onAddToWatchlist(AddToWatchlist event, Emitter<TvshowDetailState> emit) async {
    final result = await saveWatchlist.execute(event.tvshow);

    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );

    final newStatus = await getWatchListStatus.execute(event.tvshow.id);

    emit(state.copyWith(
      isAddedToWatchlist: newStatus,
      watchlistMessage: message,
    ));
  }

  Future<void> _onRemoveFromWatchlist(RemoveFromWatchlist event, Emitter<TvshowDetailState> emit) async {
    final result = await removeWatchlist.execute(event.tvshow);

    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );

    final newStatus = await getWatchListStatus.execute(event.tvshow.id);

    emit(state.copyWith(
      isAddedToWatchlist: newStatus,
      watchlistMessage: message,
    ));
  }
}
