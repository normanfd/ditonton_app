import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_detail.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_recommendations.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tvshow/remove_tvshow_watchlist.dart';
import 'package:ditonton/domain/usecases/tvshow/save_tvshow_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail/tv_show_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tvshow_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvshowDetail,
  GetTvshowRecommendations,
  GetTvshowWatchListStatus,
  SaveTvshowWatchlist,
  RemoveTvshowWatchlist,
])
void main() {
  late MockGetTvshowDetail mockGetTvshowDetail;
  late MockGetTvshowRecommendations mockGetTvshowRecommendations;
  late MockGetTvshowWatchListStatus mockGetWatchlistStatus;
  late MockSaveTvshowWatchlist mockSaveWatchlist;
  late MockRemoveTvshowWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetTvshowDetail = MockGetTvshowDetail();
    mockGetTvshowRecommendations = MockGetTvshowRecommendations();
    mockGetWatchlistStatus = MockGetTvshowWatchListStatus();
    mockSaveWatchlist = MockSaveTvshowWatchlist();
    mockRemoveWatchlist = MockRemoveTvshowWatchlist();
  });

  final tId = 1;

  final tTvshowList = testTvshowList;

  const tState = TvshowDetailState();

  group('FetchTvshowDetail', () {
    blocTest<TvshowDetailBloc, TvshowDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTvshowDetail.execute(tId)).thenAnswer((_) async => Right(testTvshowDetail));
        when(mockGetTvshowRecommendations.execute(tId)).thenAnswer((_) async => Right(tTvshowList));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return TvshowDetailBloc(
          getTvshowDetail: mockGetTvshowDetail,
          getTvshowRecommendations: mockGetTvshowRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(FetchTvshowDetail(tId)),
      expect: () => [
        tState.copyWith(tvshowState: RequestState.Loading),
        tState.copyWith(
          tvshowState: RequestState.Loaded,
          tvshow: testTvshowDetail,
          recommendationState: RequestState.Loaded,
          tvshowRecommendations: tTvshowList,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockGetTvshowDetail.execute(tId));
        verify(mockGetTvshowRecommendations.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<TvshowDetailBloc, TvshowDetailState>(
      'should emit [Loading, Error] when GetTvshowDetail fails',
      build: () {
        when(mockGetTvshowDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        when(mockGetTvshowRecommendations.execute(tId)).thenAnswer((_) async => Right(tTvshowList));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return TvshowDetailBloc(
          getTvshowDetail: mockGetTvshowDetail,
          getTvshowRecommendations: mockGetTvshowRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(FetchTvshowDetail(tId)),
      expect: () => [
        tState.copyWith(tvshowState: RequestState.Loading),
        tState.copyWith(
          tvshowState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TvshowDetailBloc, TvshowDetailState>(
      'should emit [Loading, Loaded] with recommendation error when GetTvshowRecommendations fails',
      build: () {
        when(mockGetTvshowDetail.execute(tId)).thenAnswer((_) async => Right(testTvshowDetail));
        when(mockGetTvshowRecommendations.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return TvshowDetailBloc(
          getTvshowDetail: mockGetTvshowDetail,
          getTvshowRecommendations: mockGetTvshowRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(FetchTvshowDetail(tId)),
      expect: () => [
        tState.copyWith(tvshowState: RequestState.Loading),
        tState.copyWith(
          tvshowState: RequestState.Loaded,
          tvshow: testTvshowDetail,
          recommendationState: RequestState.Error,
          message: 'Failed',
          isAddedToWatchlist: true,
        ),
      ],
    );
  });

  group('Watchlist Actions', () {
    blocTest<TvshowDetailBloc, TvshowDetailState>(
      'should emit new state with success message when AddToWatchlist is successful',
      build: () {
        when(mockSaveWatchlist.execute(testTvshowDetail)).thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testTvshowDetail.id))
            .thenAnswer((_) async => true);
        return TvshowDetailBloc(
          getTvshowDetail: mockGetTvshowDetail,
          getTvshowRecommendations: mockGetTvshowRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvshowDetail)),
      expect: () => [
        tState.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testTvshowDetail));
        verify(mockGetWatchlistStatus.execute(testTvshowDetail.id));
      },
    );

    blocTest<TvshowDetailBloc, TvshowDetailState>(
      'should emit new state with failure message when AddToWatchlist fails',
      build: () {
        when(mockSaveWatchlist.execute(testTvshowDetail)).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testTvshowDetail.id)).thenAnswer((_) async => false);
        return TvshowDetailBloc(
          getTvshowDetail: mockGetTvshowDetail,
          getTvshowRecommendations: mockGetTvshowRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvshowDetail)),
      expect: () => [
        tState.copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      ],
    );

    blocTest<TvshowDetailBloc, TvshowDetailState>(
      'should emit new state with success message when RemoveFromWatchlist is successful',
      build: () {
        when(mockRemoveWatchlist.execute(testTvshowDetail)).thenAnswer((_) async => Right('Removed'));
        when(mockGetWatchlistStatus.execute(testTvshowDetail.id)).thenAnswer((_) async => false);
        return TvshowDetailBloc(
          getTvshowDetail: mockGetTvshowDetail,
          getTvshowRecommendations: mockGetTvshowRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTvshowDetail)),
      expect: () => [
        tState.copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed',
        ),
      ],
    );
  });
}
