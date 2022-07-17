import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends MovieSearchState {}

class SearchLoading extends MovieSearchState {}

class SearchError extends MovieSearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends MovieSearchState {
  final List<Movie> result;

  SearchHasData(this.result);

  @override
  List<Object> get props => result;
}