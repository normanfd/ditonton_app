import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/tvshow/get_now_playing_tvshow.dart';
import '../../../domain/usecases/tvshow/get_popular_tvshow.dart';
import '../../../domain/usecases/tvshow/get_top_rated_tvshow.dart';

part 'tv_show_list_event.dart';

part 'tv_show_list_state.dart';

class TvshowListBloc extends Bloc<TvshowListEvent, TvshowListState> {
  final GetNowPlayingTvshow getNowPlayingTvshows;
  final GetPopularTvshow getPopularTvshows;
  final GetTopRatedTvshow getTopRatedTvshows;

  TvshowListBloc(
      {required this.getNowPlayingTvshows, required this.getPopularTvshows, required this.getTopRatedTvshows})
      : super(const TvshowListState()) {
    on<FetchAllTvshowLists>(_onFetchAllTvshowLists);
  }

  Future<void> _onFetchAllTvshowLists(
    FetchAllTvshowLists event,
    Emitter<TvshowListState> emit,
  ) async {
    emit(state.copyWith(
      nowPlayingState: RequestState.Loading,
      popularTvshowsState: RequestState.Loading,
      topRatedTvshowsState: RequestState.Loading,
    ));

    final results = await Future.wait([
      getNowPlayingTvshows.execute(),
      getPopularTvshows.execute(),
      getTopRatedTvshows.execute(),
    ]);

    final nowPlayingResult = results[0];
    final popularResult = results[1];
    final topRatedResult = results[2];

    var newState = state;

    nowPlayingResult.fold(
      (failure) =>
          newState = newState.copyWith(nowPlayingState: RequestState.Error, nowPlayingMessage: failure.message),
      (data) => newState = newState.copyWith(nowPlayingState: RequestState.Loaded, nowPlayingTvshows: data),
    );

    popularResult.fold(
      (failure) =>
          newState = newState.copyWith(popularTvshowsState: RequestState.Error, popularMessage: failure.message),
      (data) => newState = newState.copyWith(popularTvshowsState: RequestState.Loaded, popularTvshows: data),
    );

    topRatedResult.fold(
      (failure) =>
          newState = newState.copyWith(topRatedTvshowsState: RequestState.Error, topRatedMessage: failure.message),
      (data) => newState = newState.copyWith(topRatedTvshowsState: RequestState.Loaded, topRatedTvshows: data),
    );

    emit(newState);
  }
}
