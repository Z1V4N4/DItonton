import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieWatchlistState extends Equatable {
  MovieWatchlistState();

  @override
  List<Object> get props => [];

}

class MovieWatchlistEmpty extends MovieWatchlistState {}

class MovieWatchlistLoading extends MovieWatchlistState {}

class MovieWatchlistError extends MovieWatchlistState {
  final String message;

  MovieWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistHasData extends MovieWatchlistState {
  final List<Movie> movies;

  MovieWatchlistHasData({required this.movies});

  @override
  List<Object> get props => [movies];
}