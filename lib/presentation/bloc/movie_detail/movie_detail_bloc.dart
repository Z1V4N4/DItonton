import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  MovieDetailBloc(this._getMovieDetail, this._getMovieRecommendations, this._getWatchListStatus, this._saveWatchlist, this._removeWatchlist) : super(MovieDetailEmpty()) {
    on<GetMovieDetailEvent>((event, emit) async {
      emit(MovieDetailLoading());
      final result = await _getMovieDetail.execute(event.id);
      final recommendations = await _getMovieRecommendations.execute(event.id);
      final status = await _getWatchListStatus.execute(event.id);

      result.fold(
            (failure) {
          emit(MovieDetailError(failure.message));
        },
            (movie) {
          recommendations.fold(
                  (failure) {
                emit(MovieDetailError(failure.message));
              },
                  (recommendations) {
                emit(MovieDetailHasData(movie: movie, recommendations: recommendations, status: status));
              }
          );
        },
      );
    });

    on<AddWatchlistEvent>((event, emit) async {
      final result = await _saveWatchlist.execute(event.movie);

      result.fold(
              (failure) {
            emit(WatchlistError(message: failure.message));
          },
              (success) {
            emit(WatchlistSuccess(message: success));
          }
      );

      add(GetWatchlistStatusEvent(id: event.movie.id));
    });

    on<RemoveWatchlistEvent>((event, emit) async {
      final result = await _removeWatchlist.execute(event.movie);

      result.fold(
              (failure) {
            emit(WatchlistError(message: failure.message));
          },
              (success) {
            emit(WatchlistSuccess(message: success));
          }
      );

      add(GetWatchlistStatusEvent(id: event.movie.id));
    });

    on<GetWatchlistStatusEvent>((event, emit) async{
      final status = await _getWatchListStatus.execute(event.id);
      emit(WatchlistStatusState(status: status));
    });
  }
}