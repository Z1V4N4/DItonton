import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:equatable/equatable.dart';

abstract class TvseriesTopRatedState extends Equatable {
  const TvseriesTopRatedState();

  @override
  List<Object> get props => [];
}

class TopRatedListEmpty extends TvseriesTopRatedState {}

class TopRatedListLoading extends TvseriesTopRatedState {}

class TopRatedListError extends TvseriesTopRatedState {
  final String message;

  TopRatedListError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedListHasData extends TvseriesTopRatedState {
  final List<Tvseries> result;

  TopRatedListHasData(this.result);

  @override
  List<Object> get props => result;
}