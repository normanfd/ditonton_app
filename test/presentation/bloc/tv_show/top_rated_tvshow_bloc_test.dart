import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tvshow/get_top_rated_tvshow.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_show/top_rated_tv_show_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tvshow_list_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvshow])
void main() {
  late MockGetTopRatedTvshow mockGetTopRatedTvshow; // Ganti nama mock
  late TopRatedTvshowBloc topRatedTvshowBloc;

  setUp(() {
    mockGetTopRatedTvshow = MockGetTopRatedTvshow();
    topRatedTvshowBloc =
        TopRatedTvshowBloc(getTopRatedTvshow: mockGetTopRatedTvshow);
  });

  test('initial state should be Empty', () {
    expect(topRatedTvshowBloc.state, TopRatedTvshowEmpty());
  });

  blocTest<TopRatedTvshowBloc, TopRatedTvshowState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvshow.execute())
          .thenAnswer((_) async => Right(testTvshowList));
      return topRatedTvshowBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvshows()),
    expect: () => [
      TopRatedTvshowLoading(),
      TopRatedTvshowLoaded(testTvshowList),
    ],
    verify: (_) {
      verify(mockGetTopRatedTvshow.execute());
    },
  );

  blocTest<TopRatedTvshowBloc, TopRatedTvshowState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockGetTopRatedTvshow.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvshowBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvshows()),
    expect: () => [
      TopRatedTvshowLoading(),
      TopRatedTvshowError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTopRatedTvshow.execute());
    },
  );
}
