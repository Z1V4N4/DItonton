import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieDetailState extends Equatable {
  MovieDetailState();

  @override
  List<Object> get props => [];

}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool status;

  MovieDetailHasData({required this.movie, required this.recommendations, required this.status});

  @override
  List<Object> get props => [movie, recommendations, status];
}

class WatchlistSuccess extends MovieDetailState {
  final String message;

  WatchlistSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class WatchlistError extends MovieDetailState {
  final String message;

  WatchlistError({required this.message});

  @override
  List<Object> get props => [message];
}

class WatchlistStatusState extends MovieDetailState {
  final bool status;

  WatchlistStatusState({required this.status});

  @override
  List<Object> get props => [status];
}