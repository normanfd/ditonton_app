import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/domain/usecases/tvshow/get_now_playing_tvshow.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTvshow usecase;
  late MockTvshowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvshowRepository();
    usecase = GetNowPlayingTvshow(mockRepository);
  });

  final tMovies = <Tvshow>[];

  test('should get list of tvshow from the repository', () async {
    // arrange
    when(mockRepository.getNowPlayingTvshows())
        .thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tMovies));
  });
}
