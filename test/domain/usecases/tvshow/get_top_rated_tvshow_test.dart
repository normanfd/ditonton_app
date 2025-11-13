import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_top_rated_tvshow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvshow usecase;
  late MockTvshowRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvshowRepository();
    usecase = GetTopRatedTvshow(mockMovieRepository);
  });

  final tMovies = <Tvshow>[];

  test('should get list of tvshow from repository', () async {
    // arrange
    when(mockMovieRepository.getTopRatedTvshows())
        .thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tMovies));
  });
}
