import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_wacthlist_tvseries.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist/tvseries_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist/tvseries_watchlist_state.dart';

class TvseriesWatchlistBloc extends Bloc<TvseriesWatchlistEvent, TvseriesWatchlistState> {
  final GetWatchListTvseries _getWatchListTvseries;

  TvseriesWatchlistBloc(this._getWatchListTvseries) : super(TvseriesWatchlistEmpty()) {
    on<GetTvseriesWatchlistEvent>((event, emit) async {
      emit(TvseriesWatchlistLoading());
      final result = await _getWatchListTvseries.execute();

      result.fold(
            (failure) {
          emit(TvseriesWatchlistError(failure.message));
        },
            (tvShows) {
          emit(TvseriesWatchlistHasData(tvseries: tvShows));
        },
      );
    });
  }
}