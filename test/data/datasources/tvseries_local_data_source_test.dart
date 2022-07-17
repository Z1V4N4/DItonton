import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tvseries/tvseries_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvseriesLocalDataSource dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvseriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
            () async {
          // arrange
          when(mockDatabaseHelper.insertTvseriesWatchList(testTvseriesTable))
              .thenAnswer((_) async => 1);
          // act
          final result = await dataSource.insertTvseriesWatchList(testTvseriesTable);
          // assert
          expect(result, 'Added to Watchlist');
        });

    test('should throw DatabaseException when insert to database is failed',
            () async {
          // arrange
          when(mockDatabaseHelper.insertTvseriesWatchList(testTvseriesTable))
              .thenThrow(Exception());
          // act
          final call = dataSource.insertTvseriesWatchList(testTvseriesTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
            () async {
          // arrange
          when(mockDatabaseHelper.removeTvseriesWatchList(testTvseriesTable))
              .thenAnswer((_) async => 1);
          // act
          final result = await dataSource.removeTvseriesWatchList(testTvseriesTable);
          // assert
          expect(result, 'Removed from Watchlist');
        });

    test('should throw DatabaseException when remove from database is failed',
            () async {
          // arrange
          when(mockDatabaseHelper.removeTvseriesWatchList(testTvseriesTable))
              .thenThrow(Exception());
          // act
          final call = dataSource.removeTvseriesWatchList(testTvseriesTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        });
  });

  group('Get Tv series Detail By Id', () {
    final tId = 1;

    test('should return Tv series Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvseriesById(tId))
          .thenAnswer((_) async => testTvseriesMap);
      // act
      final result = await dataSource.getTvseriesById(tId);
      // assert
      expect(result, testTvseriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvseriesById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvseriesById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvSeriesTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getTvseriesWatchList())
          .thenAnswer((_) async => [testTvseriesMap]);
      // act
      final result = await dataSource.getTvseriesWatchList();
      // assert
      expect(result, [testTvseriesTable]);
    });
  });
}
