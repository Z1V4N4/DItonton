import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:equatable/equatable.dart';

abstract class TvseriesWatchlistState extends Equatable {
  TvseriesWatchlistState();

  @override
  List<Object> get props => [];

}

class TvseriesWatchlistEmpty extends TvseriesWatchlistState {}

class TvseriesWatchlistLoading extends TvseriesWatchlistState {}

class TvseriesWatchlistError extends TvseriesWatchlistState {
  final String message;

  TvseriesWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class TvseriesWatchlistHasData extends TvseriesWatchlistState {
  final List<Tvseries> tvseries;

  TvseriesWatchlistHasData({required this.tvseries});

  @override
  List<Object> get props => [tvseries];
}