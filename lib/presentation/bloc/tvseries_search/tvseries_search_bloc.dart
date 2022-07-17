import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/search_tvseries.dart';
import 'package:ditonton/presentation/bloc/tvseries_search/tvseries_search_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_search/tvseries_search_state.dart';
import 'package:rxdart/rxdart.dart';

class TvseriesSearchBloc extends Bloc<TvseriesSearchEvent, TvseriesSearchState> {
  final SearchTvseries _searchTvseries;

  TvseriesSearchBloc(this._searchTvseries) : super(SearchEmpty()) {
    on<OnTvQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await _searchTvseries.execute(query);

      result.fold(
            (failure) {
          emit(SearchError(failure.message));
        },
            (data) {
          emit(SearchHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}