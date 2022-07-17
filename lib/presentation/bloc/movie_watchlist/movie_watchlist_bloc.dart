import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_state.dart';

class MovieWatchlistBloc extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies _getWatchlistMovies;

  MovieWatchlistBloc(this._getWatchlistMovies) : super(MovieWatchlistEmpty()) {
    on<GetMovieWatchlistEvent>((event, emit) async {
      emit(MovieWatchlistLoading());
      final result = await _getWatchlistMovies.execute();

      result.fold(
            (failure) {
          emit(MovieWatchlistError(failure.message));
        },
            (movies) {
          emit(MovieWatchlistHasData(movies: movies));
        },
      );
    });
  }
}