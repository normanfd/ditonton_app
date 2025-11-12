import 'package:ditonton/domain/repositories/tvshow_repository.dart';

class GetTvshowWatchListStatus {
  final TvshowRepository repository;

  GetTvshowWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
