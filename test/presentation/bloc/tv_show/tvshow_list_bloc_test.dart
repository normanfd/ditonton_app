import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvshow/get_now_playing_tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_popular_tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_top_rated_tvshow.dart';
import 'package:ditonton/presentation/bloc/tv_show_list/tv_show_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tvshow_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvshow, GetPopularTvshow, GetTopRatedTvshow])
void main() {
  late TvshowListBloc tvshowListBloc;
  late MockGetNowPlayingTvshow mockGetNowPlayingTvshows; // Ganti nama mock
  late MockGetPopularTvshow mockGetPopularTvshows;
  late MockGetTopRatedTvshow mockGetTopRatedTvshows;

  setUp(() {
    mockGetNowPlayingTvshows = MockGetNowPlayingTvshow();
    mockGetPopularTvshows = MockGetPopularTvshow();
    mockGetTopRatedTvshows = MockGetTopRatedTvshow();
  });

  // Data dummy (testTvshowList dari dummy_objects.dart)

  // State awal
  const tState = TvshowListState();

  test('initial state should be correct (all empty)', () {
    tvshowListBloc = TvshowListBloc(
      getNowPlayingTvshows: mockGetNowPlayingTvshows,
      getPopularTvshows: mockGetPopularTvshows,
      getTopRatedTvshows: mockGetTopRatedTvshows,
    );
    expect(tvshowListBloc.state, tState);
  });

  group('FetchAllTvshowLists', () {
    blocTest<TvshowListBloc, TvshowListState>(
      'should emit [Loading, Loaded] when all usecases are successful',
      build: () {
        when(mockGetNowPlayingTvshows.execute()).thenAnswer((_) async => Right(testTvshowList));
        when(mockGetPopularTvshows.execute()).thenAnswer((_) async => Right(testTvshowList));
        when(mockGetTopRatedTvshows.execute()).thenAnswer((_) async => Right(testTvshowList));

        return TvshowListBloc(
          getNowPlayingTvshows: mockGetNowPlayingTvshows,
          getPopularTvshows: mockGetPopularTvshows,
          getTopRatedTvshows: mockGetTopRatedTvshows,
        );
      },
      act: (bloc) => bloc.add(FetchAllTvshowLists()),
      expect: () => [
        // 1. State Loading
        tState.copyWith(
          nowPlayingState: RequestState.Loading,
          popularTvshowsState: RequestState.Loading,
          topRatedTvshowsState: RequestState.Loading,
        ),
        // 2. State Final (Loaded)
        tState.copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingTvshows: testTvshowList,
          popularTvshowsState: RequestState.Loaded,
          popularTvshows: testTvshowList,
          topRatedTvshowsState: RequestState.Loaded,
          topRatedTvshows: testTvshowList,
        ),
      ],
      verify: (_) {
        verify(mockGetNowPlayingTvshows.execute());
        verify(mockGetPopularTvshows.execute());
        verify(mockGetTopRatedTvshows.execute());
      },
    );

    blocTest<TvshowListBloc, TvshowListState>(
      'should emit [Loading, State] with one Error when NowPlaying fails',
      build: () {
        when(mockGetNowPlayingTvshows.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetPopularTvshows.execute()).thenAnswer((_) async => Right(testTvshowList));
        when(mockGetTopRatedTvshows.execute()).thenAnswer((_) async => Right(testTvshowList));

        return TvshowListBloc(
          getNowPlayingTvshows: mockGetNowPlayingTvshows,
          getPopularTvshows: mockGetPopularTvshows,
          getTopRatedTvshows: mockGetTopRatedTvshows,
        );
      },
      act: (bloc) => bloc.add(FetchAllTvshowLists()),
      expect: () => [
        tState.copyWith(
          nowPlayingState: RequestState.Loading,
          popularTvshowsState: RequestState.Loading,
          topRatedTvshowsState: RequestState.Loading,
        ),
        tState.copyWith(
          nowPlayingState: RequestState.Error,
          nowPlayingMessage: 'Server Failure',
          popularTvshowsState: RequestState.Loaded,
          popularTvshows: testTvshowList,
          topRatedTvshowsState: RequestState.Loaded,
          topRatedTvshows: testTvshowList,
        ),
      ],
    );
  });
}
