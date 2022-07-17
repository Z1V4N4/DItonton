import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';

class SaveWatchlistTvseries {
  final TvseriesRepository repository;

  SaveWatchlistTvseries(this.repository);

  Future<Either<Failure, String>> execute(TvseriesDetail tvseries) {
    return repository.saveWatchlist(tvseries);
  }
}
