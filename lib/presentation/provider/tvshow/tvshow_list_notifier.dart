import 'package:ditonton/domain/usecases/tvshow/get_now_playing_tvshow.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/Tvshow.dart';
import '../../../domain/usecases/tvshow/get_popular_tvshow.dart';
import '../../../domain/usecases/tvshow/get_top_rated_tvshow.dart';

class TvshowListNotifier extends ChangeNotifier {
  var _nowPlayingTvshows = <Tvshow>[];
  List<Tvshow> get nowPlayingTvshows => _nowPlayingTvshows;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _popularTvshows = <Tvshow>[];
  List<Tvshow> get popularTvshows => _popularTvshows;

  RequestState _popularTvshowsState = RequestState.Empty;
  RequestState get popularTvshowsState => _popularTvshowsState;

  var _topRatedTvshows = <Tvshow>[];
  List<Tvshow> get topRatedTvshows => _topRatedTvshows;

  RequestState _topRatedTvshowsState = RequestState.Empty;
  RequestState get topRatedTvshowsState => _topRatedTvshowsState;

  String _message = '';
  String get message => _message;

  TvshowListNotifier({
    required this.getNowPlayingTvshows,
    required this.getPopularTvshows,
    required this.getTopRatedTvshows,
  });

  final GetNowPlayingTvshow getNowPlayingTvshows;
  final GetPopularTvshow getPopularTvshows;
  final GetTopRatedTvshow getTopRatedTvshows;

  Future<void> fetchNowPlayingTvshows() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTvshows.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvshowData) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlayingTvshows = tvshowData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvshows() async {
    _popularTvshowsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvshows.execute();
    result.fold(
      (failure) {
        _popularTvshowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvshowData) {
        _popularTvshowsState = RequestState.Loaded;
        _popularTvshows = tvshowData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvshows() async {
    _topRatedTvshowsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvshows.execute();
    result.fold(
      (failure) {
        _topRatedTvshowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvshowData) {
        _topRatedTvshowsState = RequestState.Loaded;
        _topRatedTvshows = tvshowData;
        notifyListeners();
      },
    );
  }
}
