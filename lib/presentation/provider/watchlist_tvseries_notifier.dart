import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_wacthlist_tvseries.dart';
import 'package:flutter/foundation.dart';

class WatchListTvseriesNotifier extends ChangeNotifier {
  var _watchListTvseries = <Tvseries>[];
  List<Tvseries> get watchlistTvseries => _watchListTvseries;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchListTvseriesNotifier({required this.getWatchListTvseries});

  final GetWatchListTvseries getWatchListTvseries;

  Future<void> fetchWatchlistTvseries() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchListTvseries.execute();
    result.fold(
          (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvseriesData) {
        _watchlistState = RequestState.Loaded;
        _watchListTvseries = tvseriesData;
        notifyListeners();
      },
    );
  }
}
