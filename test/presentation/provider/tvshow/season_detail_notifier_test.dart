import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tvshow/get_season_detail.dart';
import 'package:ditonton/presentation/provider/tvshow/season_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'season_detail_notifier_test.mocks.dart';

@GenerateMocks([GetSeasonDetail])
void main() {
  late MockGetSeasonDetail mockGetSeasonDetail;
  late SeasonDetailNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetSeasonDetail = MockGetSeasonDetail();
    notifier = SeasonDetailNotifier(getSeasonEpisode: mockGetSeasonDetail)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetSeasonDetail.execute(1, 1))
        .thenAnswer((_) async => Right(testSeasonDetail));
    // act
    notifier.fetchSeasonDetailTvshow(1, 1);
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetSeasonDetail.execute(1, 1))
        .thenAnswer((_) async => Right(testSeasonDetail));
    // act
    await notifier.fetchSeasonDetailTvshow(1, 1);
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.seasonDetail, testSeasonDetail.episodes);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetSeasonDetail.execute(1, 1))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchSeasonDetailTvshow(1, 1);
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
