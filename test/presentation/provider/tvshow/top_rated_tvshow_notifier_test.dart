import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvshow/get_top_rated_tvshow.dart';
import 'package:ditonton/presentation/provider/tvshow/top_rated_tvshow_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_tvshow_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTvshow])
void main() {
  late MockGetTopRatedTvshow mockGetTopRatedMovies;
  late TopRatedTvshowNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedMovies = MockGetTopRatedTvshow();
    notifier = TopRatedTvshowNotifier(getTopRatedTvshow: mockGetTopRatedMovies)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetTopRatedMovies.execute())
        .thenAnswer((_) async => Right(testTvshowList));
    // act
    notifier.fetchTopRatedTvshow();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetTopRatedMovies.execute())
        .thenAnswer((_) async => Right(testTvshowList));
    // act
    await notifier.fetchTopRatedTvshow();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvshow, testTvshowList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedMovies.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTopRatedTvshow();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
