import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_state.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist/tvseries_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist/tvseries_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist/tvseries_watchlist_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieWatchlistBloc>(context, listen: false)
          .add(GetMovieWatchlistEvent());
      Provider.of<TvseriesWatchlistBloc>(context, listen: false)
          .add(GetTvseriesWatchlistEvent());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<MovieWatchlistBloc>(context, listen: false)
        .add(GetMovieWatchlistEvent());
    Provider.of<TvseriesWatchlistBloc>(context, listen: false)
        .add(GetTvseriesWatchlistEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text('Movies', style: kHeading6)
                      ),
                      Expanded(
                        child: BlocBuilder<MovieWatchlistBloc, MovieWatchlistState>(
                          builder: (context, state) {
                            if (state is MovieWatchlistLoading) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is MovieWatchlistHasData) {
                              if (state.movies.isEmpty) {
                                return Center(child: Text('You haven\'t added any movies'));
                              } else {
                                return ListView.builder(
                                  itemBuilder: (context, index) {
                                    final movie = state.movies[index];
                                    return MovieCard(movie);
                                  },
                                  itemCount: state.movies.length,
                                );
                              }
                            } else if (state is MovieWatchlistError){
                              return Center(
                                key: Key('error_message'),
                                child: Text(state.message),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      )
                    ],
                  )
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text('TV Series', style: kHeading6)
                    ),
                    Expanded(
                      child: BlocBuilder<TvseriesWatchlistBloc, TvseriesWatchlistState>(
                        builder: (context, state) {
                          if (state is TvseriesWatchlistLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is TvseriesWatchlistHasData) {
                            if (state.tvseries.isEmpty) {
                              return Center(child: Text('You haven\'t added any TV series'));
                            } else {
                              return ListView.builder(
                                itemBuilder: (context, index) {
                                  final tvseries = state.tvseries[index];
                                  return TvSeriesCard(tvseries);
                                },
                                itemCount: state.tvseries.length,
                              );
                            }
                          } else if (state is TvseriesWatchlistError){
                            return Center(
                              key: Key('error_message'),
                              child: Text(state.message),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
