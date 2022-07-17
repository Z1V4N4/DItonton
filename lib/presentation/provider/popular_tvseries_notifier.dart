import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_popular_tvseries.dart';
import 'package:flutter/foundation.dart';

class PopularTvseriesNotifier extends ChangeNotifier {
  final GetPopularTvseries getPopularTvseries;

  PopularTvseriesNotifier(this.getPopularTvseries);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tvseries> _tvseries = [];
  List<Tvseries> get tvseries => _tvseries;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTvseries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvseries.execute();

    result.fold(
          (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
          (tvseriesData) {
        _tvseries = tvseriesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
