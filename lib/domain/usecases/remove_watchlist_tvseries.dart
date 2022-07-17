import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';

class RemoveWatchlistTvseries {
  final TvseriesRepository repository;

  RemoveWatchlistTvseries(this.repository);

  Future<Either<Failure, String>> execute(TvseriesDetail tvseries) {
    return repository.removeWatchlist(tvseries);
  }
}
