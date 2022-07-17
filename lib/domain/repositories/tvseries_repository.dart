import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';

abstract class TvseriesRepository {
  Future<Either<Failure, List<Tvseries>>> getNowAiringTvseries();
  Future<Either<Failure, List<Tvseries>>> getPopularTvseries();
  Future<Either<Failure, List<Tvseries>>> getTopRatedTvseries();
  Future<Either<Failure, TvseriesDetail>> getTvseriesDetail(int id);
  Future<Either<Failure, List<Tvseries>>> getTvseriesRecommendations(int id);
  Future<Either<Failure, List<Tvseries>>> searchTvseries(String query);
  Future<Either<Failure, String>> saveWatchlist(TvseriesDetail tvseries);
  Future<Either<Failure, String>> removeWatchlist(TvseriesDetail tvseries);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tvseries>>> getTvseriesWatchList();
}
