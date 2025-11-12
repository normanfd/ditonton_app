import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvshowRecommendations usecase;
  late MockTvshowRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvshowRepository();
    usecase = GetTvshowRecommendations(mockMovieRepository);
  });

  final tId = 1;
  final tTv = <Tvshow>[];

  test('should get list of tvshow recommendations from the repository',
      () async {
    // arrange
    when(mockMovieRepository.getTvshowRecommendations(tId))
        .thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTv));
  });
}
