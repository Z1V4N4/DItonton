import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:equatable/equatable.dart';

abstract class TvseriesSearchState extends Equatable {
  const TvseriesSearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends TvseriesSearchState {}

class SearchLoading extends TvseriesSearchState {}

class SearchError extends TvseriesSearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends TvseriesSearchState {
  final List<Tvseries> result;

  SearchHasData(this.result);

  @override
  List<Object> get props => result;
}