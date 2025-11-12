import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/domain/usecases/tvshow/get_season_detail.dart';
import 'package:flutter/foundation.dart';

class SeasonDetailNotifier extends ChangeNotifier {
  final GetSeasonDetail getSeasonEpisode;

  SeasonDetailNotifier({required this.getSeasonEpisode});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<SeasonEpisode> _seasonDetail = [];

  List<SeasonEpisode> get seasonDetail => _seasonDetail;

  String _message = '';

  String get message => _message;

  Future<void> fetchSeasonDetailTvshow(int seriesId, int seasonId) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getSeasonEpisode.execute(seriesId, seasonId);

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (moviesData) {
        _seasonDetail = moviesData.episodes;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
