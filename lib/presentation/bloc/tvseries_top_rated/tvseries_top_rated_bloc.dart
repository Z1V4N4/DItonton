import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvseries.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated/tvseries_top_rated_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated/tvseries_top_rated_state.dart';

class TvseriesTopRatedBloc extends Bloc<TvseriesTopRatedEvent, TvseriesTopRatedState> {
  final GetTopRatedTvseries _getTopRatedTvseries;

  TvseriesTopRatedBloc(this._getTopRatedTvseries) : super(TopRatedListEmpty()) {
    on<GetTvseriesTopRatedEvent>((event, emit) async {

      emit(TopRatedListLoading());
      final result = await _getTopRatedTvseries.execute();

      result.fold(
            (failure) {
          emit(TopRatedListError(failure.message));
        },
            (data) {
          emit(TopRatedListHasData(data));
        },
      );
    });
  }
}