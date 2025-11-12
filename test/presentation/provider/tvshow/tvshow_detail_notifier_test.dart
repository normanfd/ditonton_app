import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_detail.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_recommendations.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tvshow/remove_tvshow_watchlist.dart';
import 'package:ditonton/domain/usecases/tvshow/save_tvshow_watchlist.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tvshow/tvshow_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tvshow_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvshowDetail,
  GetTvshowRecommendations,
  GetTvshowWatchListStatus,
  SaveTvshowWatchlist,
  RemoveTvshowWatchlist,
])
void main() {
  late TvshowDetailNotifier provider;
  late MockGetTvshowDetail mockGetMovieDetail;
  late MockGetTvshowRecommendations mockGetMovieRecommendations;
  late MockGetTvshowWatchListStatus mockGetWatchlistStatus;
  late MockSaveTvshowWatchlist mockSaveWatchlist;
  late MockRemoveTvshowWatchlist mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetMovieDetail = MockGetTvshowDetail();
    mockGetMovieRecommendations = MockGetTvshowRecommendations();
    mockGetWatchlistStatus = MockGetTvshowWatchListStatus();
    mockSaveWatchlist = MockSaveTvshowWatchlist();
    mockRemoveWatchlist = MockRemoveTvshowWatchlist();
    provider = TvshowDetailNotifier(
      getTvshowDetail: mockGetMovieDetail,
      getTvshowRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  void arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvshowDetail));
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testTvshowList));
  }

  group('Get Tvshow Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchTvshowDetail(tId);
      // assert
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      arrangeUsecase();
      // act
      provider.fetchTvshowDetail(tId);
      // assert
      expect(provider.tvshowState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchTvshowDetail(tId);
      // assert
      expect(provider.tvshowState, RequestState.Loaded);
      expect(provider.tvshow, testTvshowDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation movies when data is gotten successfully',
        () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchTvshowDetail(tId);
      // assert
      expect(provider.tvshowState, RequestState.Loaded);
      expect(provider.tvshowRecommendations, testTvshowList);
    });
  });

  group('Get Tvshow Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchTvshowDetail(tId);
      // assert
      verify(mockGetMovieRecommendations.execute(tId));
      expect(provider.tvshowRecommendations, testTvshowList);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      arrangeUsecase();
      // act
      await provider.fetchTvshowDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvshowRecommendations, testTvshowList);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvshowDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvshowDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvshowDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testTvshowDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTvshowDetail);
      // assert
      verify(mockSaveWatchlist.execute(testTvshowDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testTvshowDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testTvshowDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testTvshowDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testTvshowDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvshowDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTvshowDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTvshowDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(testTvshowDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvshowDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTvshowDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testTvshowDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTvshowList));
      // act
      await provider.fetchTvshowDetail(tId);
      // assert
      expect(provider.tvshowState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
