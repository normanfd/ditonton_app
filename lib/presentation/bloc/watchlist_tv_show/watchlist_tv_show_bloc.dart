import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_watchlist_tvshow.dart';

part 'watchlist_tv_show_event.dart';

part 'watchlist_tv_show_state.dart';

class WatchlistTvshowBloc extends Bloc<WatchlistTvshowEvent, WatchlistTvshowState> {
  final GetWatchlistTvshow getWatchlistTvshow;

  WatchlistTvshowBloc({required this.getWatchlistTvshow}) : super(WatchlistTvshowEmpty()) {
    on<FetchWatchlistTvshows>(_onFetchWatchlistTvshows);
  }

  Future<void> _onFetchWatchlistTvshows(
    FetchWatchlistTvshows event,
    Emitter<WatchlistTvshowState> emit,
  ) async {
    emit(WatchlistTvshowLoading());

    final result = await getWatchlistTvshow.execute();

    result.fold(
      (failure) {
        emit(WatchlistTvshowError(failure.message));
      },
      (tvshowsData) {
        emit(WatchlistTvshowLoaded(tvshowsData));
      },
    );
  }
}
