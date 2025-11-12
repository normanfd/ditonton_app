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
import 'package:ditonton/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/tvshow/now_playing_tvshow_notifier.dart';
import 'package:ditonton/presentation/provider/tvshow/popular_tvshow_notifier.dart';
import 'package:ditonton/presentation/provider/movie/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/tvshow/season_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tvshow/top_rated_tvshow_notifier.dart';
import 'package:ditonton/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/tvshow/tvshow_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tvshow/tvshow_list_notifier.dart';
import 'package:ditonton/presentation/provider/tvshow/tvshow_search_notifier.dart';
import 'package:ditonton/presentation/provider/tvshow/watchlist_tvshow_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'data/datasources/tvshow/tvshow_remote_data_source.dart';
import 'data/repositories/tvshow_repository_impl.dart';
import 'domain/repositories/tvshow_repository.dart';
import 'domain/usecases/tvshow/get_now_playing_tvshow.dart';
import 'domain/usecases/tvshow/get_popular_tvshow.dart';
import 'domain/usecases/tvshow/get_top_rated_tvshow.dart';
import 'domain/usecases/tvshow/get_watchlist_tvshow.dart';
import 'domain/usecases/tvshow/search_tvshow.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );

  locator.registerFactory(
    () => TvshowListNotifier(
      getNowPlayingTvshows: locator(),
      getPopularTvshows: locator(),
      getTopRatedTvshows: locator(),
    ),
  );

  locator.registerFactory(
    () => PopularTvshowNotifier(
      locator(),
    ),
  );

  locator.registerFactory(
    () => TopRatedTvshowNotifier(
      getTopRatedTvshow: locator(),
    ),
  );

  locator.registerFactory(
    () => TvshowDetailNotifier(
        getTvshowDetail: locator(),
        getTvshowRecommendations: locator(),
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator()),
  );

  locator.registerFactory(
    () => TvshowSearchNotifier(
      searchTvshow: locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistTvshowNotifier(
      getWatchlistTvshow: locator(),
    ),
  );

  locator.registerFactory(
    () => SeasonDetailNotifier(
      getSeasonEpisode: locator(),
    ),
  );

  locator.registerFactory(
    () => NowPlayingTvshowNotifier(
      getNowPlayingTvshow: locator(),
    ),
  );

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
  locator.registerLazySingleton(() => http.Client());
}
