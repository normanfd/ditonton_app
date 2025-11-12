import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/season_detail.dart';

import '../../repositories/tvshow_repository.dart';

class GetSeasonDetail {
  final TvshowRepository repository;

  GetSeasonDetail(this.repository);

  Future<Either<Failure, SeasonDetail>> execute(int seriesId, int seasonId) {
    return repository.getTvShowSeasonDetail(seriesId, seasonId);
  }
}
