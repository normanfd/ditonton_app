import 'package:ditonton/domain/usecases/tvshow/get_tvshow_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvshowWatchListStatus usecase;
  late MockTvshowRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvshowRepository();
    usecase = GetTvshowWatchListStatus(mockMovieRepository);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(mockMovieRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
