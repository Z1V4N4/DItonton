import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tvseries_now_airing_notifier.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
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
        Provider.of<TvseriesNowAiringNotifier>(context, listen: false)
            .fetchNowAiringTvseries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Airing Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TvseriesNowAiringNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvseries = data.tvseries[index];
                  return TvSeriesCard(tvseries);
                },
                itemCount: data.tvseries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
