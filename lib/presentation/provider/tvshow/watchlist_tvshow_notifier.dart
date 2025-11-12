import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_watchlist_tvshow.dart';
import 'package:flutter/foundation.dart';

class WatchlistTvshowNotifier extends ChangeNotifier {
  var _watchlistTvshow = <Tvshow>[];
  List<Tvshow> get watchlistTvshow => _watchlistTvshow;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTvshowNotifier({required this.getWatchlistTvshow});

  final GetWatchlistTvshow getWatchlistTvshow;

  Future<void> fetchWatchlistTvshow() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvshow.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvshow) {
        _watchlistState = RequestState.Loaded;
        _watchlistTvshow = tvshow;
        notifyListeners();
      },
    );
  }
}
