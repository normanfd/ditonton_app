import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_top_rated_tvshow.dart';
import 'package:flutter/foundation.dart';

class TopRatedTvshowNotifier extends ChangeNotifier {
  final GetTopRatedTvshow getTopRatedTvshow;

  TopRatedTvshowNotifier({required this.getTopRatedTvshow});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tvshow> _tvshow = [];
  List<Tvshow> get tvshow => _tvshow;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTvshow() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvshow.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvshowData) {
        _tvshow = tvshowData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
