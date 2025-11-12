import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvshow/get_watchlist_tvshow.dart';
import 'package:ditonton/presentation/provider/tvshow/watchlist_tvshow_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tvshow_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTvshow])
void main() {
  late WatchlistTvshowNotifier provider;
  late MockGetWatchlistTvshow mockGetWatchlistMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistMovies = MockGetWatchlistTvshow();
    provider = WatchlistTvshowNotifier(
      getWatchlistTvshow: mockGetWatchlistMovies,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Right([testWatchlistTvshow]));
    // act
    await provider.fetchWatchlistTvshow();
    // assert
    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlistTvshow, [testWatchlistTvshow]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlistTvshow();
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
