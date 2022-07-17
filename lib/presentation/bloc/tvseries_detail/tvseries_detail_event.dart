import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvseriesDetailEvent extends Equatable {
  const TvseriesDetailEvent();

  @override
  List<Object> get props => [];
}

class GetTvseriesDetailEvent extends TvseriesDetailEvent {
  final int id;

  GetTvseriesDetailEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class AddWatchlistEvent extends TvseriesDetailEvent {
  final TvseriesDetail tvseriesDetail;

  AddWatchlistEvent({required this.tvseriesDetail});

  @override
  List<Object> get props => [tvseriesDetail];
}

class RemoveWatchlistEvent extends TvseriesDetailEvent {
  final TvseriesDetail tvseriesDetail;

  RemoveWatchlistEvent({required this.tvseriesDetail});

  @override
  List<Object> get props => [tvseriesDetail];
}

class GetWatchlistStatusEvent extends TvseriesDetailEvent {
  final int id;

  GetWatchlistStatusEvent({required this.id});

  @override
  List<Object> get props => [id];
}