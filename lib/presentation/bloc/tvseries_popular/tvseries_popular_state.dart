import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:equatable/equatable.dart';

abstract class TvseriesPopularState extends Equatable {
  const TvseriesPopularState();

  @override
  List<Object> get props => [];
}

class PopularListEmpty extends TvseriesPopularState {}

class PopularListLoading extends TvseriesPopularState {}

class PopularListError extends TvseriesPopularState {
  final String message;

  PopularListError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularListHasData extends TvseriesPopularState {
  final List<Tvseries> result;

  PopularListHasData(this.result);

  @override
  List<Object> get props => result;
}