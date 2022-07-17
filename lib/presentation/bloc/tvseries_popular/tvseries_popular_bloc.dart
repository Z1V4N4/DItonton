import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_popular_tvseries.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular/tvseries_popular_state.dart';

class TvseriesPopularBloc extends Bloc<TvseriesPopularEvent, TvseriesPopularState> {
  final GetPopularTvseries _getPopularTvseries;

  TvseriesPopularBloc(this._getPopularTvseries) : super(PopularListEmpty()) {
    on<GetTvseriesPopularEvent>((event, emit) async {

      emit(PopularListLoading());
      final result = await _getPopularTvseries.execute();

      result.fold(
            (failure) {
          emit(PopularListError(failure.message));
        },
            (data) {
          emit(PopularListHasData(data));
        },
      );
    });
  }
}