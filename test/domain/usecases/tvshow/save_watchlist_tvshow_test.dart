import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tvshow/save_tvshow_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvshowWatchlist usecase;
  late MockTvshowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvshowRepository();
    usecase = SaveTvshowWatchlist(mockRepository);
  });

  test('should save tvshow to the repository', () async {
    // arrange
    when(mockRepository.saveWatchlist(testTvshowDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvshowDetail);
    // assert
    verify(mockRepository.saveWatchlist(testTvshowDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
