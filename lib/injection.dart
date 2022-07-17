import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tvseries/tvseries_local_data_source.dart';
import 'package:ditonton/data/datasources/tvseries/tvseries_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tvseries_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_airing_tvseries.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tvseries.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvseries.dart';
import 'package:ditonton/domain/usecases/get_tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_recommendations.dart';
import 'package:ditonton/domain/usecases/get_wacthlist_tvseries.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tvseries.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tvseries.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rate_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_search/tvseries_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated/tvseries_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist/tvseries_watchlist_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'presentation/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'presentation/bloc/tvseries_now_airing/tvseries_now_airing_bloc.dart';

final locator = GetIt.instance;

void init() {

  //bloc
  locator.registerFactory(
          () => MoviesNowPlayingBloc(locator())
  );
  locator.registerFactory(
        () => MovieSearchBloc(locator()),
  );
  locator.registerFactory(
        () => MovieDetailBloc(
            locator(),
            locator(),
            locator(),
            locator(),
            locator()
        )
  );
  locator.registerFactory(
        () => MoviesPopularBloc(locator()),
  );
  locator.registerFactory(
        () => MoviesTopRatedBloc(locator()),
  );
  locator.registerFactory(
        () => MovieWatchlistBloc(locator()),
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

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  //bloc
  locator.registerFactory(
          () => TvseriesNowAiringBloc(locator())
  );
  locator.registerFactory(
        () => TvseriesDetailBloc(
            locator(),
            locator(),
            locator(),
            locator(),
            locator()
        )
  );
  locator.registerFactory(
        () => TvseriesSearchBloc(locator()),
  );
  locator.registerFactory(
        () => TvseriesPopularBloc(locator()),
  );
  locator.registerFactory(
        () => TvseriesTopRatedBloc(locator()),
  );
  locator.registerFactory(
        () => TvseriesWatchlistBloc(locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetNowAiringTvseries(locator()));
  locator.registerLazySingleton(() => GetPopularTvseries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvseries(locator()));
  locator.registerLazySingleton(() => GetTvseriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvseriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvseries(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTvseries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvseries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvseries(locator()));
  locator.registerLazySingleton(() => GetWatchListTvseries(locator()));

  // repository
  locator.registerLazySingleton<TvseriesRepository>(
        () => TvseriesRepositoryImpl(
          remoteDataSource: locator(),
          localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<TvseriesRemoteDataSource>(
          () => TvseriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvseriesLocalDataSource>(
          () => TvseriesLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
          () => MovieLocalDataSourceImpl(databaseHelper: locator()));


  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
