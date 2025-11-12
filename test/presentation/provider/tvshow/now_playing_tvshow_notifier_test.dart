import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvshow/get_now_playing_tvshow.dart';
import 'package:ditonton/presentation/provider/tvshow/now_playing_tvshow_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tvshow_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvshow])
void main() {
  late MockGetNowPlayingTvshow mockGetNowPlayingTvshow;
  late NowPlayingTvshowNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTvshow = MockGetNowPlayingTvshow();
    notifier = NowPlayingTvshowNotifier(getNowPlayingTvshow: mockGetNowPlayingTvshow)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetNowPlayingTvshow.execute())
        .thenAnswer((_) async => Right(testTvshowList));
    // act
    notifier.fetchNowPlayingTvshows();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetNowPlayingTvshow.execute())
        .thenAnswer((_) async => Right(testTvshowList));
    // act
    await notifier.fetchNowPlayingTvshows();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvshow, testTvshowList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetNowPlayingTvshow.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchNowPlayingTvshows();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
