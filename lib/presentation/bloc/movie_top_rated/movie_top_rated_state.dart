import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MoviesTopRatedState extends Equatable {
  const MoviesTopRatedState();

  @override
  List<Object> get props => [];
}

class TopRatedListEmpty extends MoviesTopRatedState {}

class TopRatedListLoading extends MoviesTopRatedState {}

class TopRatedListError extends MoviesTopRatedState {
  final String message;

  TopRatedListError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedListHasData extends MoviesTopRatedState {
  final List<Movie> result;

  TopRatedListHasData(this.result);

  @override
  List<Object> get props => result;
}