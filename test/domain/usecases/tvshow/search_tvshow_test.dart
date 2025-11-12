import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/search_tvshow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvshow usecase;
  late MockTvshowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvshowRepository();
    usecase = SearchTvshow(mockRepository);
  });

  final tMovies = <Tvshow>[];
  final tQuery = 'Spiderman';

  test('should get list of tvshow from the repository', () async {
    // arrange
    when(mockRepository.searchTvshows(tQuery))
        .thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tMovies));
  });
}
