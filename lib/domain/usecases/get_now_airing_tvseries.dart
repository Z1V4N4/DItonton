import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';

class GetNowAiringTvseries {
  final TvseriesRepository repository;

  GetNowAiringTvseries(this.repository);

  Future<Either<Failure, List<Tvseries>>> execute() {
    return repository.getNowAiringTvseries();
  }
}