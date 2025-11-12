import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tvshow/get_now_playing_tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_popular_tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_top_rated_tvshow.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tvshow/tvshow_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tvshow_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvshow, GetPopularTvshow, GetTopRatedTvshow])
void main() {
  late TvshowListNotifier provider;
  late MockGetNowPlayingTvshow mockGetNowPlayingMovies;
  late MockGetPopularTvshow mockGetPopularMovies;
  late MockGetTopRatedTvshow mockGetTopRatedMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingMovies = MockGetNowPlayingTvshow();
    mockGetPopularMovies = MockGetPopularTvshow();
    mockGetTopRatedMovies = MockGetTopRatedTvshow();
    provider = TvshowListNotifier(
      getNowPlayingTvshows: mockGetNowPlayingMovies,
      getPopularTvshows: mockGetPopularMovies,
      getTopRatedTvshows: mockGetTopRatedMovies,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('now playing tvshow', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testTvshowList));
      // act
      provider.fetchNowPlayingTvshows();
      // assert
      verify(mockGetNowPlayingMovies.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testTvshowList));
      // act
      provider.fetchNowPlayingTvshows();
      // assert
      expect(provider.nowPlayingState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testTvshowList));
      // act
      await provider.fetchNowPlayingTvshows();
      // assert
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlayingTvshows, testTvshowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlayingTvshows();
      // assert
      expect(provider.nowPlayingState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tvshow', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testTvshowList));
      // act
      provider.fetchPopularTvshows();
      // assert
      expect(provider.popularTvshowsState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testTvshowList));
      // act
      await provider.fetchPopularTvshows();
      // assert
      expect(provider.popularTvshowsState, RequestState.Loaded);
      expect(provider.popularTvshows, testTvshowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTvshows();
      // assert
      expect(provider.popularTvshowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testTvshowList));
      // act
      provider.fetchTopRatedTvshows();
      // assert
      expect(provider.topRatedTvshowsState, RequestState.Loading);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testTvshowList));
      // act
      await provider.fetchTopRatedTvshows();
      // assert
      expect(provider.topRatedTvshowsState, RequestState.Loaded);
      expect(provider.topRatedTvshows, testTvshowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTvshows();
      // assert
      expect(provider.topRatedTvshowsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
