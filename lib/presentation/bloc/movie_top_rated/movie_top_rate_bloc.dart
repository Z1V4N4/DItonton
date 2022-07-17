import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rated_event.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rated_state.dart';

class MoviesTopRatedBloc extends Bloc<MoviesTopRatedEvent, MoviesTopRatedState> {
  final GetTopRatedMovies _getTopRatedMovies;

  MoviesTopRatedBloc(this._getTopRatedMovies) : super(TopRatedListEmpty()) {
    on<GetMoviesTopRatedEvent>((event, emit) async {

      emit(TopRatedListLoading());
      final result = await _getTopRatedMovies.execute();

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