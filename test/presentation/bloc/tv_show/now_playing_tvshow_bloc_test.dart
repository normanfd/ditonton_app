import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tvshow/search_tvshow.dart';
import 'package:ditonton/presentation/bloc/tv_show_search/tv_show_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tvshow_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvshow])
void main() {
  late TvshowSearchBloc tvshowSearchBloc;
  late MockSearchTvshow mockSearchTvshow;

  setUp(() {
    mockSearchTvshow = MockSearchTvshow();
    tvshowSearchBloc = TvshowSearchBloc(searchTvShow: mockSearchTvshow);
  });

  final tQuery = 'spiderman';
  // Sesuaikan durasi debounce
  final tDebounceDuration = Duration(milliseconds: 500);

  test('initial state should be Empty', () {
    expect(tvshowSearchBloc.state, TvshowSearchEmpty());
  });

  blocTest<TvshowSearchBloc, TvshowSearchState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchTvshow.execute(tQuery))
          .thenAnswer((_) async => Right(testTvshowList));
      return TvshowSearchBloc(searchTvShow: mockSearchTvshow);
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: tDebounceDuration, // Tunggu debounce
    expect: () => [
      TvshowSearchLoading(),
      TvshowSearchLoaded(testTvshowList),
    ],
    verify: (_) {
      verify(mockSearchTvshow.execute(tQuery));
    },
  );

  blocTest<TvshowSearchBloc, TvshowSearchState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      when(mockSearchTvshow.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return TvshowSearchBloc(searchTvShow: mockSearchTvshow);
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: tDebounceDuration,
    expect: () => [
      TvshowSearchLoading(),
      TvshowSearchError('Server Failure'),
    ],
    verify: (_) {
      verify(mockSearchTvshow.execute(tQuery));
    },
  );
}