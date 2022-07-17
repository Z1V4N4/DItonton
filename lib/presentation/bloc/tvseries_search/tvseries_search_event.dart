import 'package:equatable/equatable.dart';

abstract class TvseriesSearchEvent extends Equatable {
  const TvseriesSearchEvent();

  @override
  List<Object> get props => [];
}

class OnTvQueryChanged extends TvseriesSearchEvent {
  final String query;

  OnTvQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}