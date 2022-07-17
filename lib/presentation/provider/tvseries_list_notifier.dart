import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_now_airing_tvseries.dart';
import 'package:ditonton/domain/usecases/get_popular_tvseries.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvseries.dart';
import 'package:flutter/material.dart';

class TvSeriesListNotifier extends ChangeNotifier {
  var _nowAiringTvseries = <Tvseries>[];
  List<Tvseries> get nowAiringTvseries => _nowAiringTvseries;

  RequestState _nowAiringState = RequestState.Empty;
  RequestState get nowAiringState => _nowAiringState;

  var _popularTvseries = <Tvseries>[];
  List<Tvseries> get popularTvseries => _popularTvseries;

  RequestState _popularTvseriesState = RequestState.Empty;
  RequestState get popularTvseriesState => _popularTvseriesState;

  var _topRatedTvseries = <Tvseries>[];
  List<Tvseries> get topRatedTvseries => _topRatedTvseries;

  RequestState _topRatedTvseriesState = RequestState.Empty;
  RequestState get topRatedTvseriesState => _topRatedTvseriesState;

  String _message = '';
  String get message => _message;

  TvSeriesListNotifier({
    required this.getNowAiringTvseries,
    required this.getPopularTvseries,
    required this.getTopRatedTvseries,
  });

  final GetNowAiringTvseries getNowAiringTvseries;
  final GetPopularTvseries getPopularTvseries;
  final GetTopRatedTvseries getTopRatedTvseries;

  Future<void> fetchNowAiringTvseries() async {
    _nowAiringState = RequestState.Loading;
    notifyListeners();

    final result = await getNowAiringTvseries.execute();
    result.fold(
          (failure) {
        _nowAiringState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvseriesData) {
        _nowAiringState = RequestState.Loaded;
        _nowAiringTvseries = tvseriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvseries() async {
    _popularTvseriesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvseries.execute();
    result.fold(
          (failure) {
        _popularTvseriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvseriesData) {
        _popularTvseriesState = RequestState.Loaded;
        _popularTvseries = tvseriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvseries() async {
    _topRatedTvseriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvseries.execute();
    result.fold(
          (failure) {
        _topRatedTvseriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvseriesData) {
        _topRatedTvseriesState = RequestState.Loaded;
        _topRatedTvseries = tvseriesData;
        notifyListeners();
      },
    );
  }
}
