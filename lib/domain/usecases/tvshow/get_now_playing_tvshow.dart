import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/common/failure.dart';

import '../../repositories/tvshow_repository.dart';

class GetNowPlayingTvshow {
  final TvshowRepository repository;

  GetNowPlayingTvshow(this.repository);

  Future<Either<Failure, List<Tvshow>>> execute() {
    return repository.getNowPlayingTvshows();
  }
}
