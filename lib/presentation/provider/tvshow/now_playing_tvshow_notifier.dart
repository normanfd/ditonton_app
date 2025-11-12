import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvshow/get_now_playing_tvshow.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/Tvshow.dart';

class NowPlayingTvshowNotifier extends ChangeNotifier {
  final GetNowPlayingTvshow getNowPlayingTvshow;

  NowPlayingTvshowNotifier({required this.getNowPlayingTvshow});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tvshow> _tvshow = [];

  List<Tvshow> get tvshow => _tvshow;

  String _message = '';

  String get message => _message;

  Future<void> fetchNowPlayingTvshows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTvshow.execute();

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
