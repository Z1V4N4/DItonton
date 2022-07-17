import 'package:ditonton/presentation/bloc/tvseries_top_rated/tvseries_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated/tvseries_top_rated_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated/tvseries_top_rated_state.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedTvseriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-series';

  @override
  _TopRatedTvseriesPageState createState() => _TopRatedTvseriesPageState();
}

class _TopRatedTvseriesPageState extends State<TopRatedTvseriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TvseriesTopRatedBloc>(context, listen: false)
            .add(GetTvseriesTopRatedEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvseriesTopRatedBloc, TvseriesTopRatedState>(
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
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final tvseries = result[index];
                  return TvSeriesCard(tvseries);
                },
                itemCount: result.length,
              );
            } else if (state is TopRatedListError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
