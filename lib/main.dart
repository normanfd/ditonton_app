import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/main_page.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/tvshow/now_playing_tvshow_page.dart';
import 'package:ditonton/presentation/pages/tvshow/popular_tvshow_page.dart';
import 'package:ditonton/presentation/pages/movie/search_page.dart';
import 'package:ditonton/presentation/pages/tvshow/search_page_tvshow.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/tvshow/season_detail_tvshow_page.dart';
import 'package:ditonton/presentation/pages/tvshow/top_rated_tvshow_page.dart';
import 'package:ditonton/presentation/pages/tvshow/tvshow_detail_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tvshow/watchlist_tv_shows_page.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        // tv show
        ChangeNotifierProvider(
          create: (_) => di.locator<TvshowListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvshowNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvshowNotifier>(),
        ),
        ChangeNotifierProvider(
            create: (_) => di.locator<TvshowDetailNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TvshowSearchNotifier>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvshowNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SeasonDetailNotifier>(),
        ),
        ChangeNotifierProvider(
            create: (_) => di.locator<NowPlayingTvshowNotifier>())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: MainPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => MainPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case PopularTvshowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvshowPage());
            case NowPlayingTvshowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => NowPlayingTvshowPage());
            case SearchPageTvshow.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPageTvshow());
            case WatchlistTvShowPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvShowPage());
            case TopRatedTvshowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvshowPage());
            case TvshowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvshowDetailPage(id: id),
                settings: settings,
              );
            case SeasonDetailTvshowPage.ROUTE_NAME:
              final args = settings.arguments as List;
              final seriesId = args[0] as int;
              final seasonId = args[1] as int;
              return MaterialPageRoute(
                builder: (_) => SeasonDetailTvshowPage(
                    seriesId: seriesId, seasonId: seasonId),
                settings: settings,
              );
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
