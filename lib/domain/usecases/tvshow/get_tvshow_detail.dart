import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tvshow_detail.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/tvshow_repository.dart';

class GetTvshowDetail {
  final TvshowRepository repository;

  GetTvshowDetail(this.repository);

  Future<Either<Failure, TvshowDetail>> execute(int id) {
    return repository.getTvshowDetail(id);
  }
}
