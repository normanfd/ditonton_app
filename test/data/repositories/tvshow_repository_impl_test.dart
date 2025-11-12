import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/tvshow/tvshow_detail_response.dart';
import 'package:ditonton/data/models/tvshow/tvshow_model.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/repositories/tvshow_repository_impl.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvshowRepositoryImpl repository;
  late MockTvshowRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvshowRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = TvshowRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tMovieModel = TvshowModel(
    backdropPath: "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
    firstAirDate: "2023-01-23",
    genreIds: [9648, 18],
    id: 202250,
    name: "Dirty Linen",
    originCountry: ["PH"],
    originalLanguage: "tl",
    originalName: "Dirty Linen",
    overview:
        "To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.",
    popularity: 2684.061,
    posterPath: "/ujlkQtHAVShWyWTloGU2Vh5Jbo9.jpg",
    voteAverage: 5,
    voteCount: 13,
  );

  final tMovie = Tvshow(
    backdropPath: "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
    firstAirDate: "2023-01-23",
    genreIds: [9648, 18],
    id: 202250,
    name: "Dirty Linen",
    originCountry: ["PH"],
    originalLanguage: "tl",
    originalName: "Dirty Linen",
    overview:
        "To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.",
    popularity: 2684.061,
    posterPath: "/ujlkQtHAVShWyWTloGU2Vh5Jbo9.jpg",
    voteAverage: 5,
    voteCount: 13,
  );

  final tMovieModelList = <TvshowModel>[tMovieModel];
  final tMovieList = <Tvshow>[tMovie];

  group('Now Playing Movies', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvshow())
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.getNowPlayingTvshows();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTvshow());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvshow())
          .thenThrow(ServerException());
      // act
      final result = await repository.getNowPlayingTvshows();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTvshow());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTvshow())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getNowPlayingTvshows();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTvshow());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular Movies', () {
    test('should return movie list when call to data source is success',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvshow())
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.getPopularTvshows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvshow())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTvshows();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvshow())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTvshows();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Movies', () {
    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvshow())
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.getTopRatedTvshows();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvshow())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTvshows();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvshow())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTvshows();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Movie Detail', () {
    final tId = 1;
    final tMovieResponse = TvshowDetailResponse(
      adult: false,
      backdropPath: "/2746UvsbkZINd873Yd3o3TxOwCP.jpg",
      createdBy: [
        CreatedByModel(
          id: 1113116,
          creditId: "682cac47989cf65c7edb32d8",
          name: "Andy Muschietti",
          gender: 2,
          profilePath: "/4ndnP2NNavhfGtJqihD4FVDsYMY.jpg",
        ),
      ],
      episodeRunTime: [],
      firstAirDate: "2025-10-26",
      genres: [
        GenreModel(id: 9648, name: "Mystery"),
        GenreModel(id: 18, name: "Drama"),
      ],
      homepage: "https://www.hbo.com/content/it-welcome-to-derry",
      id: 200875,
      inProduction: true,
      languages: ["en"],
      lastAirDate: "2025-11-02",
      lastEpisodeToAir: LastEpisodeToAirModel(
        id: 6548351,
        name: "The Thing in the Dark",
        overview:
            "While Charlotte and Will navigate their new life in Derry, Ronnie worries about her father's fate.",
        voteAverage: 5.328,
        voteCount: 32,
        airDate: "2025-11-02",
        episodeNumber: 2,
        productionCode: "",
        runtime: 66,
        seasonNumber: 1,
        showId: 200875,
        stillPath: "/xjlBmaPoYZkoJl7kiB6G1xenOFH.jpg",
      ),
      name: "IT: Welcome to Derry",
      nextEpisodeToAir: LastEpisodeToAirModel(
        id: 6548352,
        name: "Now You See It",
        overview:
            "When a major find yields few clues, General Shaw pushes ahead with his top-secret mission, ordering Leroy and Pauly to escort Dick Hallorann on an aerial search for a new dig site. Meanwhile, Rose attends a tribal meeting about the military presence in Derry, and Ronnie, Lilly, Will, and Rich attempt to get visual proof by conjuring an Orixá.",
        voteAverage: 0.0,
        voteCount: 0,
        airDate: "2025-11-09",
        episodeNumber: 3,
        productionCode: "",
        runtime: 60,
        seasonNumber: 1,
        showId: 200875,
        stillPath: "/nO6UoLrCHSBwmKFixzkYv5FCTZ6.jpg",
      ),
      networks: [
        NetworkModel(
          id: 49,
          logoPath: "/tuomPhY2UtuPTqqFnKMVHvSb724.png",
          name: "HBO",
          originCountry: "US",
        ),
      ],
      numberOfEpisodes: 8,
      numberOfSeasons: 1,
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "IT: Welcome to Derry",
      overview:
          "In 1962, a couple with their son move to Derry, Maine just as a young boy disappears. With their arrival, very bad things begin to happen in the town.",
      popularity: 324.6438,
      posterPath: "/nyy3BITeIjviv6PFIXtqvc8i6xi.jpg",
      productionCompanies: [
        ProductionCompanyModel(
          id: 1957,
          logoPath: "/pJJw98MtNFC9cHn3o15G7vaUnnX.png",
          name: "Warner Bros. Television",
          originCountry: "US",
        )
      ],
      productionCountries: [
        ProductionCountryModel(
          iso31661: "US",
          name: "United States of America",
        ),
      ],
      seasons: [
        SeasonModel(
          airDate: "2025-10-26",
          episodeCount: 8,
          id: 291792,
          name: "Season 1",
          overview: "",
          posterPath: "/IFi0kbnVAoEVReaBuhOSj6GBMH.jpg",
          seasonNumber: 1,
          voteAverage: 5.7,
        ),
      ],
      spokenLanguages: [
        SpokenLanguageModel(
          englishName: "English",
          iso6391: "en",
          name: "English",
        ),
      ],
      status: "Returning Series",
      tagline: "Go back to where IT all began.",
      type: "Scripted",
      voteAverage: 7.893,
      voteCount: 280,
    );

    test(
        'should return Movie data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvshowDetail(tId))
          .thenAnswer((_) async => tMovieResponse);
      // act
      final result = await repository.getTvshowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvshowDetail(tId));
      expect(result, equals(Right(testTvshowDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvshowDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvshowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvshowDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvshowDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvshowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvshowDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <TvshowModel>[];
    final tId = 1;

    test('should return data (movie list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvshowRecommendations(tId))
          .thenAnswer((_) async => tMovieList);
      // act
      final result = await repository.getTvshowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvshowRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvshowRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvshowRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getTvshowRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvshowRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvshowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvshowRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Tvshow', () {
    final tQuery = 'spiderman';

    test('should return tvshow list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvshow(tQuery))
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.searchTvshows(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvshow(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTvshows(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvshow(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTvshows(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvshowTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvshowDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvshowTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTvshowDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvshowTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTvshowDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvshowTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTvshowDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getDataById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistData('t'))
          .thenAnswer((_) async => [testTvshowTable]);
      // act
      final result = await repository.getWatchlistTvshows();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvshow]);
    });
  });
}
