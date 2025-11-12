import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/domain/repositories/tvshow_repository.dart';

class SearchTvshow {
  final TvshowRepository repository;

  SearchTvshow(this.repository);

  Future<Either<Failure, List<Tvshow>>> execute(String query) {
    return repository.searchTvshows(query);
  }
}
