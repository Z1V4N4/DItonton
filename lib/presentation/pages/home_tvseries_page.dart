import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/presentation/bloc/tvseries_now_airing/tvseries_now_airing_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_now_airing/tvseries_now_airing_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_now_airing/tvseries_now_airing_state.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_state.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated/tvseries_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated/tvseries_top_rated_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated/tvseries_top_rated_state.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/now_airing_tvseries_page.dart';
import 'package:ditonton/presentation/pages/popular_tvseries_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tvseries_page.dart';
import 'package:ditonton/presentation/pages/tvseries_detail_page.dart';
import 'package:ditonton/presentation/pages/tvseries_search_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvseriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/tvseries';

  @override
  _HomeTvseriesPageState createState() => _HomeTvseriesPageState();
}

class _HomeTvseriesPageState extends State<HomeTvseriesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushReplacementNamed(context, HomeMoviePage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TvseriesSearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Airing',
                onTap: () =>
                    Navigator.pushNamed(context, NowAiringTvseriesPage.ROUTE_NAME),
              ),
              BlocBuilder<TvseriesNowAiringBloc, TvseriesNowAiringState>(
                builder: (context, state) {
                  if (state is NowAiringListEmpty) {
                    context.read<TvseriesNowAiringBloc>().add(GetTvseriesNowAiringEvent());
                  }
                  if (state is NowAiringListLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowAiringListHasData) {
                    final result = state.result;
                    return TvseriesList(result);
                  } else if (state is NowAiringListError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvseriesPage.ROUTE_NAME),
              ),
              BlocBuilder<TvseriesPopularBloc, TvseriesPopularState>(
                builder: (context, state) {
                  if (state is PopularListEmpty) {
                    context.read<TvseriesPopularBloc>().add(GetTvseriesPopularEvent());
                  }
                  if (state is PopularListLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularListHasData) {
                    final result = state.result;
                    return TvseriesList(result);
                  } else if (state is PopularListError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvseriesPage.ROUTE_NAME),
              ),
              BlocBuilder<TvseriesTopRatedBloc, TvseriesTopRatedState>(
                builder: (context, state) {
                  if(state is TopRatedListEmpty) {
                    context.read<TvseriesTopRatedBloc>().add(GetTvseriesTopRatedEvent());
                  }
                  if (state is TopRatedListLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedListHasData) {
                    final result = state.result;
                    return TvseriesList(result);
                  } else if (state is TopRatedListError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvseriesList extends StatelessWidget {
  final List<Tvseries> tvseries;

  TvseriesList(this.tvseries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvserieslist = tvseries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvseriesDetailPage.ROUTE_NAME,
                  arguments: tvserieslist.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvserieslist.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvseries.length,
      ),
    );
  }
}
