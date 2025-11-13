import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc movieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  // Inisialisasi mocks di setUp
  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
  });

  // Data dummy tetap sama
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
  final tMovieList = <Movie>[tMovie];
  const tState = MovieListState();

  test('initial state should be correct (all empty)', () {
    movieListBloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
    expect(movieListBloc.state, tState);
  });

  group('FetchAllMovieLists', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, Loaded] when all usecases are successful',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));

        return MovieListBloc(
          getNowPlayingMovies: mockGetNowPlayingMovies,
          getPopularMovies: mockGetPopularMovies,
          getTopRatedMovies: mockGetTopRatedMovies,
        );
      },
      act: (bloc) => bloc.add(FetchAllMovieLists()),
      expect: () => [
        tState.copyWith(
          nowPlayingState: RequestState.Loading,
          popularMoviesState: RequestState.Loading,
          topRatedMoviesState: RequestState.Loading,
        ),
        tState.copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularMoviesState: RequestState.Loaded,
          popularMovies: tMovieList,
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: tMovieList,
        ),
      ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
        verify(mockGetPopularMovies.execute());
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, State] with one Error when NowPlaying fails',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));

        return MovieListBloc(
          getNowPlayingMovies: mockGetNowPlayingMovies,
          getPopularMovies: mockGetPopularMovies,
          getTopRatedMovies: mockGetTopRatedMovies,
        );
      },
      act: (bloc) => bloc.add(FetchAllMovieLists()),
      expect: () => [
        tState.copyWith(
          nowPlayingState: RequestState.Loading,
          popularMoviesState: RequestState.Loading,
          topRatedMoviesState: RequestState.Loading,
        ),
        tState.copyWith(
          nowPlayingState: RequestState.Error,
          nowPlayingMessage: 'Server Failure',
          popularMoviesState: RequestState.Loaded,
          popularMovies: tMovieList,
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: tMovieList,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [Loading, State] with one Error when Popular fails',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));

        return MovieListBloc(
          getNowPlayingMovies: mockGetNowPlayingMovies,
          getPopularMovies: mockGetPopularMovies,
          getTopRatedMovies: mockGetTopRatedMovies,
        );
      },
      act: (bloc) => bloc.add(FetchAllMovieLists()),
      expect: () => [
        tState.copyWith(
          nowPlayingState: RequestState.Loading,
          popularMoviesState: RequestState.Loading,
          topRatedMoviesState: RequestState.Loading,
        ),
        tState.copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
          popularMoviesState: RequestState.Error,
          popularMessage: 'Server Failure',
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: tMovieList,
        ),
      ],
    );
  });
}
