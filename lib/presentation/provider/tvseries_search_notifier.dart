import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/search_tvseries.dart';
import 'package:flutter/foundation.dart';

class TvseriesSearchNotifier extends ChangeNotifier {
  final SearchTvseries searchTvseries;

  TvseriesSearchNotifier({required this.searchTvseries});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tvseries> _searchResult = [];
  List<Tvseries> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvseriesSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTvseries.execute(query);
    result.fold(
          (failure) {
            _message = failure.message;
            _state = RequestState.Error;
            notifyListeners();
            },
          (data) {
            _searchResult = data;
            _state = RequestState.Loaded;
            notifyListeners();
            },
    );
  }
}
