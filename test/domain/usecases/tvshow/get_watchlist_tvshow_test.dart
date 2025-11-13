import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tvshow/get_watchlist_tvshow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvshow usecase;
  late MockTvshowRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvshowRepository();
    usecase = GetWatchlistTvshow(mockMovieRepository);
  });

  test('should get list of tvshow from the repository', () async {
    // arrange
    when(mockMovieRepository.getWatchlistTvshows())
        .thenAnswer((_) async => Right(testTvshowList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvshowList));
  });
}
