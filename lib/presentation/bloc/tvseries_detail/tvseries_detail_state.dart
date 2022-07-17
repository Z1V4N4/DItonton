import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvseriesDetailState extends Equatable {
  TvseriesDetailState();

  @override
  List<Object> get props => [];

}

class TvseriesDetailEmpty extends TvseriesDetailState {}

class TvseriesDetailLoading extends TvseriesDetailState {}

class TvseriesDetailError extends TvseriesDetailState {
  final String message;

  TvseriesDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvseriesDetailHasData extends TvseriesDetailState {
  final TvseriesDetail tvseriesDetail;
  final List<Tvseries> recommendations;
  final bool status;

  TvseriesDetailHasData({required this.tvseriesDetail, required this.recommendations, required this.status});

  @override
  List<Object> get props => [tvseriesDetail, recommendations, status];
}

class WatchlistSuccess extends TvseriesDetailState {
  final String message;

  WatchlistSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class WatchlistError extends TvseriesDetailState {
  final String message;

  WatchlistError({required this.message});

  @override
  List<Object> get props => [message];
}

class WatchlistStatusState extends TvseriesDetailState {
  final bool status;

  WatchlistStatusState({required this.status});

  @override
  List<Object> get props => [status];
}