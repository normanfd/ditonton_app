import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tvshow/get_watchlist_tvshow.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show/watchlist_tv_show_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tvshow_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvshow])
void main() {
  late WatchlistTvshowBloc watchlistTvshowBloc;
  late MockGetWatchlistTvshow mockGetWatchlistTvshow;

  setUp(() {
    mockGetWatchlistTvshow = MockGetWatchlistTvshow();
    watchlistTvshowBloc =
        WatchlistTvshowBloc(getWatchlistTvshow: mockGetWatchlistTvshow);
  });

  test('initial state should be Empty', () {
    expect(watchlistTvshowBloc.state, WatchlistTvshowEmpty());
  });

  blocTest<WatchlistTvshowBloc, WatchlistTvshowState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTvshow.execute())
          .thenAnswer((_) async => Right([testWatchlistTvshow]));
      return watchlistTvshowBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvshows()),
    expect: () => [
      WatchlistTvshowLoading(),
      WatchlistTvshowLoaded([testWatchlistTvshow]),
    ],
    verify: (_) {
      verify(mockGetWatchlistTvshow.execute());
    },
  );

  blocTest<WatchlistTvshowBloc, WatchlistTvshowState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockGetWatchlistTvshow.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return watchlistTvshowBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvshows()),
    expect: () => [
      WatchlistTvshowLoading(),
      WatchlistTvshowError("Can't get data"),
    ],
    verify: (_) {
      verify(mockGetWatchlistTvshow.execute());
    },
  );
}
