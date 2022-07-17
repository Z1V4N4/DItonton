import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvseriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = 'tvseries/detail';

  final int id;
  TvseriesDetailPage({required this.id});

  @override
  _TvseriesDetailPageState createState() => _TvseriesDetailPageState();
}

class _TvseriesDetailPageState extends State<TvseriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvseriesDetailBloc>(context, listen: false)
          .add(GetTvseriesDetailEvent(id: widget.id));
      Provider.of<TvseriesDetailBloc>(context, listen: false)
          .add(GetWatchlistStatusEvent(id: widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TvseriesDetailBloc, TvseriesDetailState>(
        listener: (context, state) async {
          if (state is WatchlistSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is WatchlistError){
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(state.message),
                  );
                }
            );
          }
        },
        builder: (context, state) {
          if (state is TvseriesDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvseriesDetailHasData) {
            return DetailPageContent(state.tvseriesDetail, state.recommendations, state.status);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailPageContent extends StatelessWidget {
  final TvseriesDetail tvseriesDetail;
  final List<Tvseries> recommendations;
  final bool isAddedWatchlist;

  DetailPageContent(this.tvseriesDetail, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvseriesDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvseriesDetail.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  Provider.of<TvseriesDetailBloc>(context, listen: false).add(AddWatchlistEvent(tvseriesDetail: tvseriesDetail));
                                  Provider.of<TvseriesDetailBloc>(context, listen: false).add(GetTvseriesDetailEvent(id: tvseriesDetail.id));
                                } else {
                                  Provider.of<TvseriesDetailBloc>(context, listen: false).add(RemoveWatchlistEvent(tvseriesDetail: tvseriesDetail));
                                  Provider.of<TvseriesDetailBloc>(context, listen: false).add(GetTvseriesDetailEvent(id: tvseriesDetail.id));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _seriesGenres(tvseriesDetail.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvseriesDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvseriesDetail.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvseriesDetail.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvseriesDetailBloc, TvseriesDetailState>(
                              builder: (context, state) {
                                if (state is TvseriesDetailLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvseriesDetailError) {
                                  return Text(state.message);
                                } else if (state is TvseriesDetailHasData) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tvseries = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvseriesDetailPage.ROUTE_NAME,
                                                arguments: tvseries.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                'https://image.tmdb.org/t/p/w500${tvseries.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                      child:
                                                      CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                    Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _seriesGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

}
