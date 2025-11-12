import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_popular_tvshow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvshow usecase;
  late MockTvshowRepository mockMovieRpository;

  setUp(() {
    mockMovieRpository = MockTvshowRepository();
    usecase = GetPopularTvshow(mockMovieRpository);
  });

  final tMovies = <Tvshow>[];

  group('GetPopularTvshow Tests', () {
    group('execute', () {
      test(
          'should get list of tvshow from the repository when execute function is called',
          () async {
        // arrange
        when(mockMovieRpository.getPopularTvshows())
            .thenAnswer((_) async => Right(tMovies));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tMovies));
      });
    });
  });
}
