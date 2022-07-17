import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class GetMovieDetailEvent extends MovieDetailEvent {
  final int id;

  GetMovieDetailEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class AddWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;

  AddWatchlistEvent({required this.movie});

  @override
  List<Object> get props => [movie];
}

class RemoveWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;

  RemoveWatchlistEvent({required this.movie});

  @override
  List<Object> get props => [movie];
}

class GetWatchlistStatusEvent extends MovieDetailEvent {
  final int id;

  GetWatchlistStatusEvent({required this.id});

  @override
  List<Object> get props => [id];
}