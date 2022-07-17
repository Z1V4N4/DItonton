import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/tvseries_table.dart';

abstract class TvseriesLocalDataSource {
  Future<String> insertTvseriesWatchList(TvseriesTable tvseries);
  Future<String> removeTvseriesWatchList(TvseriesTable tvseries);
  Future<TvseriesTable?> getTvseriesById(int id);
  Future<List<TvseriesTable>> getTvseriesWatchList();
}

class TvseriesLocalDataSourceImpl implements TvseriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvseriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertTvseriesWatchList(TvseriesTable tvseries) async {
    try {
      await databaseHelper.insertTvseriesWatchList(tvseries);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeTvseriesWatchList(TvseriesTable tvseries) async {
    try {
      await databaseHelper.removeTvseriesWatchList(tvseries);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvseriesTable?> getTvseriesById(int id) async {
    final result = await databaseHelper.getTvseriesById(id);
    if (result != null) {
      return TvseriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvseriesTable>> getTvseriesWatchList() async {
    final result = await databaseHelper.getTvseriesWatchList();
    return result.map((data) => TvseriesTable.fromMap(data)).toList();
  }
}
