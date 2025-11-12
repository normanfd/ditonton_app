import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/tvshow_repository.dart';

class GetWatchlistTvshow {
  final TvshowRepository _repository;

  GetWatchlistTvshow(this._repository);

  Future<Either<Failure, List<Tvshow>>> execute() {
    return _repository.getWatchlistTvshows();
  }
}
