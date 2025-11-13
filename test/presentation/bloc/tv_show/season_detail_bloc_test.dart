import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tvshow/get_season_detail.dart';
import 'package:ditonton/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'season_detail_bloc_test.mocks.dart';

@GenerateMocks([GetSeasonDetail])
void main() {
  late MockGetSeasonDetail mockGetSeasonDetail;
  late SeasonDetailBloc seasonDetailBloc;

  setUp(() {
    mockGetSeasonDetail = MockGetSeasonDetail();
    seasonDetailBloc = SeasonDetailBloc(getSeasonDetail: mockGetSeasonDetail);
  });

  // Tentukan ID dummy untuk pengujian
  final tSeriesId = 1;
  final tSeasonId = 1;

  // Gunakan data dummy 'testSeasonDetail' dari dummy_objects.dart
  final tSeasonDetail = testSeasonDetail;

  test('initial state should be Empty', () {
    // Memeriksa state awal BLoC
    expect(seasonDetailBloc.state, SeasonDetailEmpty());
  });

  // blocTest untuk skenario sukses
  blocTest<SeasonDetailBloc, SeasonDetailState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    // build: Siapkan mock & kembalikan BLoC
    build: () {
      // Stub 'when' untuk use case
      when(mockGetSeasonDetail.execute(tSeriesId, tSeasonId))
          .thenAnswer((_) async => Right(tSeasonDetail));
      return seasonDetailBloc;
    },
    // act: Kirim event ke BLoC
    act: (bloc) => bloc.add(FetchSeasonDetail(tSeriesId, tSeasonId)),
    // expect: Daftar state yang diharapkan di-emit
    expect: () => [
      SeasonDetailLoading(), // State pertama
      SeasonDetailLoaded(tSeasonDetail.episodes), // State kedua
    ],
    // verify: (Opsional) pastikan mock dipanggil
    verify: (_) {
      verify(mockGetSeasonDetail.execute(tSeriesId, tSeasonId));
    },
  );

  // blocTest untuk skenario gagal
  blocTest<SeasonDetailBloc, SeasonDetailState>(
    'should emit [Loading, Error] when data is unsuccessful',
    build: () {
      // Stub 'when' untuk kegagalan
      when(mockGetSeasonDetail.execute(tSeriesId, tSeasonId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seasonDetailBloc;
    },
    act: (bloc) => bloc.add(FetchSeasonDetail(tSeriesId, tSeasonId)),
    // expect: Daftar state yang diharapkan
    expect: () => [
      SeasonDetailLoading(),
      SeasonDetailError('Server Failure'), // State Error dengan pesan
    ],
    verify: (_) {
      verify(mockGetSeasonDetail.execute(tSeriesId, tSeasonId));
    },
  );
}
