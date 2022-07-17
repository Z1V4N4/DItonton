import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rate_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_now_airing/tvseries_now_airing_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_search/tvseries_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated/tvseries_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist/tvseries_watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_tvseries_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/now_airing_tvseries_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tvseries_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tvseries_page.dart';
import 'package:ditonton/presentation/pages/tvseries_detail_page.dart';
import 'package:ditonton/presentation/pages/tvseries_search_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // bloc
        BlocProvider(
          create: (_) => di.locator<MovieSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MoviesNowPlayingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MoviesPopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MoviesTopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvseriesSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvseriesNowAiringBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvseriesPopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvseriesTopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvseriesDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvseriesWatchlistBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
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
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case HomeTvseriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTvseriesPage());
            case NowAiringTvseriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => NowAiringTvseriesPage());
            case PopularTvseriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvseriesPage());
            case TopRatedTvseriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvseriesPage());
            case TvseriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvseriesDetailPage(id: id),
                settings: settings
              );
            case TvseriesSearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TvseriesSearchPage());
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
