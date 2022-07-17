import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MoviesPopularState extends Equatable {
  const MoviesPopularState();

  @override
  List<Object> get props => [];
}

class PopularListEmpty extends MoviesPopularState {}

class PopularListLoading extends MoviesPopularState {}

class PopularListError extends MoviesPopularState {
  final String message;

  PopularListError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularListHasData extends MoviesPopularState {
  final List<Movie> result;

  PopularListHasData(this.result);

  @override
  List<Object> get props => result;
}