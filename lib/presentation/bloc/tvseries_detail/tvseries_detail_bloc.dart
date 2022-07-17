import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tvseries.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tvseries.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_state.dart';

class TvseriesDetailBloc extends Bloc<TvseriesDetailEvent, TvseriesDetailState> {
  final GetTvseriesDetail _getTvseriesDetail;
  final GetTvseriesRecommendations _getTvseriesRecommendations;
  final GetWatchListStatusTvseries _getWatchListStatusTvseries;
  final SaveWatchlistTvseries _saveWatchlistTvseries;
  final RemoveWatchlistTvseries _removeWatchlistTvseries;

  TvseriesDetailBloc(this._getTvseriesDetail, this._getTvseriesRecommendations, this._getWatchListStatusTvseries, this._saveWatchlistTvseries, this._removeWatchlistTvseries) : super(TvseriesDetailEmpty()) {
    on<GetTvseriesDetailEvent>((event, emit) async {
      emit(TvseriesDetailLoading());
      final result = await _getTvseriesDetail.execute(event.id);
      final recommendations = await _getTvseriesRecommendations.execute(event.id);
      final status = await _getWatchListStatusTvseries.execute(event.id);

      result.fold(
            (failure) {
          emit(TvseriesDetailError(failure.message));
        },
            (tv) {
          recommendations.fold(
                  (failure) {
                emit(TvseriesDetailError(failure.message));
              },
                  (recommendations) {
                emit(TvseriesDetailHasData(tvseriesDetail: tv, recommendations: recommendations, status: status));
              }
          );
        },
      );
    });

    on<AddWatchlistEvent>((event, emit) async {
      final result = await _saveWatchlistTvseries.execute(event.tvseriesDetail);

      result.fold(
              (failure) {
            emit(WatchlistError(message: failure.message));
          },
              (success) {
            emit(WatchlistSuccess(message: success));
          }
      );

      add(GetWatchlistStatusEvent(id: event.tvseriesDetail.id));
    });

    on<RemoveWatchlistEvent>((event, emit) async {
      final result = await _removeWatchlistTvseries.execute(event.tvseriesDetail);

      result.fold(
              (failure) {
            emit(WatchlistError(message: failure.message));
          },
              (success) {
            emit(WatchlistSuccess(message: success));
          }
      );

      add(GetWatchlistStatusEvent(id: event.tvseriesDetail.id));
    });

    on<GetWatchlistStatusEvent>((event, emit) async{
      final status = await _getWatchListStatusTvseries.execute(event.id);
      emit(WatchlistStatusState(status: status));
    });
  }
}