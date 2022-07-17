import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_now_airing_tvseries.dart';
import 'package:ditonton/presentation/bloc/tvseries_now_airing/tvseries_now_airing_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_now_airing/tvseries_now_airing_state.dart';

class TvseriesNowAiringBloc extends Bloc<TvseriesNowAiringEvent, TvseriesNowAiringState> {
  final GetNowAiringTvseries _getNowAiringTvseries;

  TvseriesNowAiringBloc(this._getNowAiringTvseries) : super(NowAiringListEmpty()) {
    on<GetTvseriesNowAiringEvent>((event, emit) async {

      emit(NowAiringListLoading());
      final result = await _getNowAiringTvseries.execute();

      result.fold(
            (failure) {
          emit(NowAiringListError(failure.message));
        },
            (data) {
          emit(NowAiringListHasData(data));
        },
      );
    });
  }
}