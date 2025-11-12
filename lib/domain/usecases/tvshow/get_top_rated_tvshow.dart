import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import '../../entities/Tvshow.dart';
import '../../repositories/tvshow_repository.dart';

class GetTopRatedTvshow {
  final TvshowRepository repository;

  GetTopRatedTvshow(this.repository);

  Future<Either<Failure, List<Tvshow>>> execute() {
    return repository.getTopRatedTvshows();
  }
}
