import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import '../entities/Tvshow.dart';
import '../entities/season_detail.dart';
import '../entities/tvshow_detail.dart';

abstract class TvshowRepository {
  Future<Either<Failure, List<Tvshow>>> getNowPlayingTvshows();
  Future<Either<Failure, List<Tvshow>>> getPopularTvshows();
  Future<Either<Failure, List<Tvshow>>> getTopRatedTvshows();
  Future<Either<Failure, TvshowDetail>> getTvshowDetail(int id);
  Future<Either<Failure, List<Tvshow>>> getTvshowRecommendations(int id);
  Future<Either<Failure, List<Tvshow>>> searchTvshows(String query);
  Future<Either<Failure, String>> saveWatchlist(TvshowDetail movie);
  Future<Either<Failure, String>> removeWatchlist(TvshowDetail movie);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tvshow>>> getWatchlistTvshows();
  Future<Either<Failure, SeasonDetail>> getTvShowSeasonDetail(
      int seriesId, int seasonId);
}
