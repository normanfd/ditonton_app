import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/datasources/local_data_source.dart';
import 'package:ditonton/data/datasources/tvshow/tvshow_remote_data_source.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/watchlist_table.dart';
import 'package:ditonton/domain/entities/season_detail.dart';

import '../../domain/entities/Tvshow.dart';
import '../../domain/entities/tvshow_detail.dart';
import '../../domain/repositories/tvshow_repository.dart';

class TvshowRepositoryImpl implements TvshowRepository {
  final TvshowRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  TvshowRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Tvshow>>> getNowPlayingTvshows() async {
    try {
      final result = await remoteDataSource.getNowPlayingTvshow();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TvshowDetail>> getTvshowDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvshowDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tvshow>>> getTvshowRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTvshowRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tvshow>>> getPopularTvshows() async {
    try {
      final result = await remoteDataSource.getPopularTvshow();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tvshow>>> getTopRatedTvshows() async {
    try {
      final result = await remoteDataSource.getTopRatedTvshow();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tvshow>>> searchTvshows(String query) async {
    try {
      final result = await remoteDataSource.searchTvshow(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvshowDetail movie) async {
    try {
      final result = await localDataSource
          .insertWatchlist(WatchlistTable.fromTvshowEntity(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvshowDetail movie) async {
    try {
      final result = await localDataSource
          .removeWatchlist(WatchlistTable.fromTvshowEntity(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getDataById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Tvshow>>> getWatchlistTvshows() async {
    final result = await localDataSource.getWatchlistData("t");
    return Right(result.map((data) => data.toTvshowEntity()).toList());
  }

  @override
  Future<Either<Failure, SeasonDetail>> getTvShowSeasonDetail(
      int seriesId, int seasonId) async {
    try {
      final result =
          await remoteDataSource.getTvshowSeasonDetail(seriesId, seasonId);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
