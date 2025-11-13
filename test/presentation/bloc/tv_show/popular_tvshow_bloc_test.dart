import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tvshow/get_popular_tvshow.dart';
import 'package:ditonton/presentation/bloc/popular_tv_show/popular_tv_show_bloc.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_tvshow_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvshow])
void main() {
  late MockGetPopularTvshow mockGetPopularTvshow; // Ganti nama mock
  late PopularTvshowBloc popularTvshowBloc;

  setUp(() {
    mockGetPopularTvshow = MockGetPopularTvshow();
    popularTvshowBloc =
        PopularTvshowBloc(getPopularTvshow: mockGetPopularTvshow);
  });

  test('initial state should be Empty', () {
    expect(popularTvshowBloc.state, PopularTvshowEmpty());
  });

  blocTest<PopularTvshowBloc, PopularTvshowState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetPopularTvshow.execute())
          .thenAnswer((_) async => Right(testTvshowList));
      return popularTvshowBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvshows()),
    expect: () => [
      PopularTvshowLoading(),
      PopularTvshowLoaded(testTvshowList),
    ],
    verify: (_) {
      verify(mockGetPopularTvshow.execute());
    },
  );

  blocTest<PopularTvshowBloc, PopularTvshowState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockGetPopularTvshow.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvshowBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvshows()),
    expect: () => [
      PopularTvshowLoading(),
      PopularTvshowError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetPopularTvshow.execute());
    },
  );
}