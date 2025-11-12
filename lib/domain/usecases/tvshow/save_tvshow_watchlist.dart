import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvshow_detail.dart';
import 'package:ditonton/domain/repositories/tvshow_repository.dart';

class SaveTvshowWatchlist {
  final TvshowRepository repository;

  SaveTvshowWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvshowDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
