import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class MoviesNowPlayingState extends Equatable {
  const MoviesNowPlayingState();

  @override
  List<Object> get props => [];
}

class NowPlayingListEmpty extends MoviesNowPlayingState {}

class NowPlayingListLoading extends MoviesNowPlayingState {}

class NowPlayingListError extends MoviesNowPlayingState {
  final String message;

  NowPlayingListError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingListHasData extends MoviesNowPlayingState {
  final List<Movie> result;

  NowPlayingListHasData(this.result);

  @override
  List<Object> get props => result;
}