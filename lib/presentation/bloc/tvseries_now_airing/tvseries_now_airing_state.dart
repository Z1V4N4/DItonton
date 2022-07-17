import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:equatable/equatable.dart';

abstract class TvseriesNowAiringState extends Equatable {
  const TvseriesNowAiringState();

  @override
  List<Object> get props => [];
}

class NowAiringListEmpty extends TvseriesNowAiringState {}

class NowAiringListLoading extends TvseriesNowAiringState {}

class NowAiringListError extends TvseriesNowAiringState {
  final String message;

  NowAiringListError(this.message);

  @override
  List<Object> get props => [message];
}

class NowAiringListHasData extends TvseriesNowAiringState {
  final List<Tvseries> result;

  NowAiringListHasData(this.result);

  @override
  List<Object> get props => result;
}