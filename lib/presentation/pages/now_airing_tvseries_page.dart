import 'package:ditonton/presentation/bloc/tvseries_now_airing/tvseries_now_airing_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_now_airing/tvseries_now_airing_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_now_airing/tvseries_now_airing_state.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class NowAiringTvseriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-airing-tv-series';

  @override
  _NowAiringTvseriesPageState createState() => _NowAiringTvseriesPageState();
}

class _NowAiringTvseriesPageState extends State<NowAiringTvseriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TvseriesNowAiringBloc>(context, listen: false)
            .add(GetTvseriesNowAiringEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Airing Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvseriesNowAiringBloc, TvseriesNowAiringState>(
          builder: (context, state) {
            if (state is NowAiringListEmpty) {
            }
            if (state is NowAiringListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowAiringListHasData) {
              final result = state.result;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final tvseries = result[index];
                  return TvSeriesCard(tvseries);
                },
                itemCount: result.length,
              );
            } else if (state is NowAiringListError) {
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