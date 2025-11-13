import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvshowDetail usecase;
  late MockTvshowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvshowRepository();
    usecase = GetTvshowDetail(mockRepository);
  });

  final tId = 1;

  test('should get tv show detail from the repository', () async {
    // arrange
    when(mockRepository.getTvshowDetail(tId))
        .thenAnswer((_) async => Right(testTvshowDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testTvshowDetail));
  });
}
