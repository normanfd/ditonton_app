import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tvshow/remove_tvshow_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvshowWatchlist usecase;
  late MockTvshowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvshowRepository();
    usecase = RemoveTvshowWatchlist(mockRepository);
  });

  test('should remove watchlist tvshow from repository', () async {
    // arrange
    when(mockRepository.removeWatchlist(testTvshowDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvshowDetail);
    // assert
    verify(mockRepository.removeWatchlist(testTvshowDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
