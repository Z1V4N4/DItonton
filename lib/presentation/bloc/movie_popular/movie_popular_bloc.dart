import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_event.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_state.dart';

class MoviesPopularBloc extends Bloc<MoviesPopularEvent, MoviesPopularState> {
  final GetPopularMovies _getPopularMovies;

  MoviesPopularBloc(this._getPopularMovies) : super(PopularListEmpty()) {
    on<GetMoviesPopularEvent>((event, emit) async {

      emit(PopularListLoading());
      final result = await _getPopularMovies.execute();

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