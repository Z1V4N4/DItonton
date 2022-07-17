import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movie_now_playing/movie_now_playing_event.dart';
import 'package:ditonton/presentation/bloc/movie_now_playing/movie_now_playing_state.dart';

class MoviesNowPlayingBloc extends Bloc<MoviesNowPlayingEvent, MoviesNowPlayingState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  MoviesNowPlayingBloc(this._getNowPlayingMovies) : super(NowPlayingListEmpty()) {
    on<GetMoviesNowPlayingEvent>((event, emit) async {

      emit(NowPlayingListLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
            (failure) {
          emit(NowPlayingListError(failure.message));
        },
            (data) {
          emit(NowPlayingListHasData(data));
        },
      );
    });
  }
}