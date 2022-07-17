import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tvseries.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tvseries.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TvseriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvseriesDetail getTvseriesDetail;
  final GetTvseriesRecommendations getTvseriesRecommendations;
  final GetWatchListStatusTvseries getWatchListStatusTvseries;
  final SaveWatchlistTvseries saveWatchlistTvseries;
  final RemoveWatchlistTvseries removeWatchlistTvseries;

  TvseriesDetailNotifier({
    required this.getTvseriesDetail,
    required this.getTvseriesRecommendations,
    required this.getWatchListStatusTvseries,
    required this.saveWatchlistTvseries,
    required this.removeWatchlistTvseries,
  });

  late TvseriesDetail _tvseriesDetail;
  TvseriesDetail get tvseries => _tvseriesDetail;

  RequestState _tvseriesState = RequestState.Empty;
  RequestState get tvseriesState => _tvseriesState;

  List<Tvseries> _tvseriesRecommendations = [];
  List<Tvseries> get tvseriesRecommendations => _tvseriesRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTvseriesDetail(int id) async {
    _tvseriesState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvseriesDetail.execute(id);
    final recommendationResult = await getTvseriesRecommendations.execute(id);
    detailResult.fold(
          (failure) {
        _tvseriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvseries) {
        _recommendationState = RequestState.Loading;
        _tvseriesDetail = tvseries;
        notifyListeners();
        recommendationResult.fold(
              (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
              (tvseries) {
            _recommendationState = RequestState.Loaded;
            _tvseriesRecommendations = tvseries;
          },
        );
        _tvseriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TvseriesDetail tvseries) async {
    final result = await saveWatchlistTvseries.execute(tvseries);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvseries.id);
  }

  Future<void> removeFromWatchlist(TvseriesDetail tvseries) async {
    final result = await removeWatchlistTvseries.execute(tvseries);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvseries.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusTvseries.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
