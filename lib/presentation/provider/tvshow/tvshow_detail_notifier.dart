import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_detail.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_recommendations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/Tvshow.dart';
import '../../../domain/entities/tvshow_detail.dart';
import '../../../domain/usecases/tvshow/get_tvshow_watchlist_status.dart';
import '../../../domain/usecases/tvshow/remove_tvshow_watchlist.dart';
import '../../../domain/usecases/tvshow/save_tvshow_watchlist.dart';

class TvshowDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvshowDetail getTvshowDetail;
  final GetTvshowRecommendations getTvshowRecommendations;
  final GetTvshowWatchListStatus getWatchListStatus;
  final SaveTvshowWatchlist saveWatchlist;
  final RemoveTvshowWatchlist removeWatchlist;

  TvshowDetailNotifier({
    required this.getTvshowDetail,
    required this.getTvshowRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late TvshowDetail _tvshow;
  TvshowDetail get tvshow => _tvshow;

  RequestState _tvshowState = RequestState.Empty;
  RequestState get tvshowState => _tvshowState;

  List<Tvshow> _tvshowRecommendations = [];
  List<Tvshow> get tvshowRecommendations => _tvshowRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTvshowDetail(int id) async {
    _tvshowState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvshowDetail.execute(id);
    final recommendationResult = await getTvshowRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvshowState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvshow) {
        _recommendationState = RequestState.Loading;
        _tvshow = tvshow;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvshows) {
            _recommendationState = RequestState.Loaded;
            _tvshowRecommendations = tvshows;
          },
        );
        _tvshowState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TvshowDetail tvshow) async {
    final result = await saveWatchlist.execute(tvshow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvshow.id);
  }

  Future<void> removeFromWatchlist(TvshowDetail tvshow) async {
    final result = await removeWatchlist.execute(tvshow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvshow.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
