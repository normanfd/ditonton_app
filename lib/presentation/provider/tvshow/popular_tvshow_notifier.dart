import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvshow/get_popular_tvshow.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/Tvshow.dart';

class PopularTvshowNotifier extends ChangeNotifier {
  final GetPopularTvshow getPopularTvshow;

  PopularTvshowNotifier(this.getPopularTvshow);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tvshow> _tvshow = [];
  List<Tvshow> get tvshow => _tvshow;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTvshows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvshow.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (moviesData) {
        _tvshow = moviesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
