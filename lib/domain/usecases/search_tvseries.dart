import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';

class SearchTvseries {
  final TvseriesRepository repository;

  SearchTvseries(this.repository);

  Future<Either<Failure, List<Tvseries>>> execute(String query) {
    return repository.searchTvseries(query);
  }
}
