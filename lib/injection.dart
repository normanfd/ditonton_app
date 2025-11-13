import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/local_data_source.dart';
import 'package:ditonton/data/datasources/movie/movie_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/tvshow/get_season_detail.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_detail.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/domain/usecases/tvshow/get_tvshow_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tvshow/remove_tvshow_watchlist.dart';
import 'package:ditonton/domain/usecases/tvshow/save_tvshow_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_tv_show/now_playing_tvshow_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_show/popular_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_show/top_rated_tv_show_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show_list/tv_show_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_show_search/tv_show_search_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show/watchlist_tv_show_bloc.dart';
import 'package:ditonton/util/http_ssl_client.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';

import 'data/datasources/tvshow/tvshow_remote_data_source.dart';
import 'data/repositories/tvshow_repository_impl.dart';
import 'domain/repositories/tvshow_repository.dart';
import 'domain/usecases/tvshow/get_now_playing_tvshow.dart';
import 'domain/usecases/tvshow/get_popular_tvshow.dart';
import 'domain/usecases/tvshow/get_top_rated_tvshow.dart';
import 'domain/usecases/tvshow/get_watchlist_tvshow.dart';
import 'domain/usecases/tvshow/search_tvshow.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // bloc - tvshow
  locator.registerFactory(
      () => NowPlayingTvshowBloc(getNowPlayingTvshow: locator()));
  locator.registerFactory(() => PopularTvshowBloc(getPopularTvshow: locator()));
  locator
      .registerFactory(() => TopRatedTvshowBloc(getTopRatedTvshow: locator()));
  locator.registerFactory(() => TvshowSearchBloc(searchTvShow: locator()));
  locator.registerFactory(() => TvshowDetailBloc(
      getTvshowDetail: locator(),
      getTvshowRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator()));
  locator.registerFactory(() => SeasonDetailBloc(getSeasonDetail: locator()));
  locator.registerFactory(
      () => WatchlistTvshowBloc(getWatchlistTvshow: locator()));
  locator.registerFactory(() => TvshowListBloc(
      getNowPlayingTvshows: locator(),
      getPopularTvshows: locator(),
      getTopRatedTvshows: locator()));
  // bloc - movie
  locator.registerFactory(
    () => MovieListBloc(
        getNowPlayingMovies: locator(),
        getPopularMovies: locator(),
        getTopRatedMovies: locator()),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
        getMovieDetail: locator(),
        getMovieRecommendations: locator(),
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator()),
  );
  locator.registerFactory(() => MovieSearchBloc(searchMovies: locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator
      .registerFactory(() => TopRatedMoviesBloc(getTopRatedMovies: locator()));
  locator
      .registerFactory(() => WatchlistMovieBloc(getWatchlistMovies: locator()));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingTvshow(locator()));
  locator.registerLazySingleton(() => GetPopularTvshow(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvshow(locator()));
  locator.registerLazySingleton(() => GetTvshowDetail(locator()));
  locator.registerLazySingleton(() => GetTvshowRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvshow(locator()));
  locator.registerLazySingleton(() => GetTvshowWatchListStatus(locator()));
  locator.registerLazySingleton(() => RemoveTvshowWatchlist(locator()));
  locator.registerLazySingleton(() => SaveTvshowWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvshow(locator()));
  locator.registerLazySingleton(() => GetSeasonDetail(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvshowRepository>(
    () => TvshowRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvshowRemoteDataSource>(
      () => TvshowRemoteDataSourceImpl(client: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  // locator.registerLazySingleton(() => http.Client());
  final secureClient = await HttpSslClient.create();
  locator.registerLazySingleton<IOClient>(() => secureClient);
  locator.registerLazySingleton<http.Client>(() => secureClient);
}
