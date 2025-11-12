import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvshow/search_tvshow.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/Tvshow.dart';

class TvshowSearchNotifier extends ChangeNotifier {
  final SearchTvshow searchTvshow;

  TvshowSearchNotifier({required this.searchTvshow});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tvshow> _searchResult = [];
  List<Tvshow> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvshowSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTvshow.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
