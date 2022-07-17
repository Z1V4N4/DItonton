import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';

class GetWatchListTvseries {
  final TvseriesRepository _repository;

  GetWatchListTvseries(this._repository);

  Future<Either<Failure, List<Tvseries>>> execute() {
    return _repository.getTvseriesWatchList();
  }
}
