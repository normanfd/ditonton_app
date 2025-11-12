import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';

import '../../repositories/tvshow_repository.dart';

class GetPopularTvshow {
  final TvshowRepository repository;

  GetPopularTvshow(this.repository);

  Future<Either<Failure, List<Tvshow>>> execute() {
    return repository.getPopularTvshows();
  }
}
