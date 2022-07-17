import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_state.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularTvseriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-series';

  @override
  _PopularTvseriesPageState createState() => _PopularTvseriesPageState();
}

class _PopularTvseriesPageState extends State<PopularTvseriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TvseriesPopularBloc>(context, listen: false)
            .add(GetTvseriesPopularEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv Sseries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvseriesPopularBloc, TvseriesPopularState>(
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
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final tvseries = result[index];
                  return TvSeriesCard(tvseries);
                },
                itemCount: result.length,
              );
            } else if (state is PopularListError) {
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