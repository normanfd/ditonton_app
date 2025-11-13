import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // movie
        BlocProvider(create: (_) => di.locator<MovieListBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),

        // tv show
        BlocProvider(create: (_) => di.locator<NowPlayingTvshowBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvshowBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvshowBloc>()),
        BlocProvider(create: (_) => di.locator<TvshowSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TvshowDetailBloc>()),
        BlocProvider(create: (_) => di.locator<SeasonDetailBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvshowBloc>()),
        BlocProvider(create: (_) => di.locator<TvshowListBloc>()),
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
