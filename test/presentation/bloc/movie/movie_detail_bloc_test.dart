import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Impor file mocks yang akan digenerasi
import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

// Anotasi mocks tetap sama
@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
  });

  // Data dummy tetap sama
  final tId = 1;
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];
  // testMovieDetail adalah dari dummy_objects.dart

  // State Awal (untuk perbandingan)
  const tState = MovieDetailState();

  group('FetchMovieDetail', () {
    // Gunakan 'blocTest'
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        // Atur mock untuk SEMUA panggilan di dalam _onFetchMovieDetail
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return MovieDetailBloc(
          getMovieDetail: mockGetMovieDetail,
          getMovieRecommendations: mockGetMovieRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      // act: Mengirim event ke BLoC
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      // expect: Memastikan urutan state yang di-emit
      expect: () => [
        // 1. State Loading
        tState.copyWith(movieState: RequestState.Loading),
        // 2. State Final (Loaded)
        tState.copyWith(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: tMovies,
          isAddedToWatchlist: true,
        ),
      ],
      // verify: Memastikan use case dipanggil
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Error] when GetMovieDetail fails',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        // Tetap mock panggilan lain
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return MovieDetailBloc(
          getMovieDetail: mockGetMovieDetail,
          getMovieRecommendations: mockGetMovieRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        tState.copyWith(movieState: RequestState.Loading),
        tState.copyWith(
          movieState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Loaded] with recommendation error when GetMovieRecommendations fails',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return MovieDetailBloc(
          getMovieDetail: mockGetMovieDetail,
          getMovieRecommendations: mockGetMovieRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        tState.copyWith(movieState: RequestState.Loading),
        tState.copyWith(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Error,
          message: 'Failed', // Pesan error dari rekomendasi
          isAddedToWatchlist: true,
        ),
      ],
    );
  });

  group('Watchlist Actions', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit new state with success message when AddToWatchlist is successful',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return MovieDetailBloc(
          getMovieDetail: mockGetMovieDetail,
          getMovieRecommendations: mockGetMovieRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        // Hanya emit 1 state baru
        tState.copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit new state with failure message when AddToWatchlist fails',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false); // Status tidak berubah
        return MovieDetailBloc(
          getMovieDetail: mockGetMovieDetail,
          getMovieRecommendations: mockGetMovieRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        tState.copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit new state with success message when RemoveFromWatchlist is successful',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed'));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return MovieDetailBloc(
          getMovieDetail: mockGetMovieDetail,
          getMovieRecommendations: mockGetMovieRecommendations,
          getWatchListStatus: mockGetWatchlistStatus,
          saveWatchlist: mockSaveWatchlist,
          removeWatchlist: mockRemoveWatchlist,
        );
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        tState.copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed',
        ),
      ],
    );
  });
}