import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tvseries_detail_model.dart';
import 'package:ditonton/data/models/tvseries_model.dart';
import 'package:ditonton/data/repositories/tvseries_repository_impl.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvseriesRepositoryImpl repository;
  late MockTvseriesRemoteDataSource mockRemoteDataSource;
  late MockTvseriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvseriesRemoteDataSource();
    mockLocalDataSource = MockTvseriesLocalDataSource();
    repository = TvseriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvseriesModel = TvseriesModel(
      backdropPath: 'a',
      genreIds: [1],
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      name: 'name',
      voteAverage: 1,
      voteCount: 1
  );

  final tTvseries = Tvseries(
      backdropPath: 'a',
      genreIds: [1],
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      name: 'name',
      voteAverage: 1,
      voteCount: 1
  );

  final tTvseriesModelList = <TvseriesModel>[tTvseriesModel];
  final tTvseriesList = <Tvseries>[tTvseries];

  group('Now Airing Tv Shows', () {
    test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowAiringTvseries())
              .thenAnswer((_) async => tTvseriesModelList);
          // act
          final result = await repository.getNowAiringTvseries();
          // assert
          verify(mockRemoteDataSource.getNowAiringTvseries());
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvseriesList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowAiringTvseries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getNowAiringTvseries();
          // assert
          verify(mockRemoteDataSource.getNowAiringTvseries());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowAiringTvseries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getNowAiringTvseries();
          // assert
          verify(mockRemoteDataSource.getNowAiringTvseries());
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Popular Tv Shows', () {
    test('should return tv show list when call to data source is success',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvseries())
              .thenAnswer((_) async => tTvseriesModelList);
          // act
          final result = await repository.getPopularTvseries();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvseriesList);
        });

    test(
        'should return server failure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvseries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getPopularTvseries();
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return connection failure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvseries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getPopularTvseries();
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Top Rated Tv Shows', () {
    test('should return tv show list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvseries())
              .thenAnswer((_) async => tTvseriesModelList);
          // act
          final result = await repository.getTopRatedTvseries();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvseriesList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvseries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getTopRatedTvseries();
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvseries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTopRatedTvseries();
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Get TvShow Detail', () {
    final tId = 1;
    final tTvShowResponse = TvseriesDetailResponse(
      backdropPath: 'backdropPath',
      genres: [GenreModel(id: 1, name: 'Action')],
      id: 1,
      originalName: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      name: 'title',
      voteAverage: 1,
      voteCount: 1,
      firstAirDate: 'firstAirDate',
      lastAirDate: 'lastAirDate',
      originalLanguage: '',
      homepage: '',
      popularity: 1,
      status: 'status',
      tagline: '',
    );

    test(
        'should return tv show data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvseriesDetail(tId))
              .thenAnswer((_) async => tTvShowResponse);
          // act
          final result = await repository.getTvseriesDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvseriesDetail(tId));
          expect(result, equals(Right(testTvseriesDetail)));
        });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvseriesDetail(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvseriesDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvseriesDetail(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvseriesDetail(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvseriesDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvseriesDetail(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Get Tv Show Recommendations', () {
    final tTvShowList = <TvseriesModel>[];
    final tId = 1;

    test('should return data (tv show list) when the call is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvseriesRecommendations(tId))
              .thenAnswer((_) async => tTvShowList);
          // act
          final result = await repository.getTvseriesRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTvseriesRecommendations(tId));
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tTvShowList));
        });

    test(
        'should return server failure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvseriesRecommendations(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvseriesRecommendations(tId);
          // assertbuild runner
          verify(mockRemoteDataSource.getTvseriesRecommendations(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvseriesRecommendations(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvseriesRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTvseriesRecommendations(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Seach Tv Shows', () {
    final tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvseries(tQuery))
              .thenAnswer((_) async => tTvseriesModelList);
          // act
          final result = await repository.searchTvseries(tQuery);
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvseriesList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvseries(tQuery))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchTvseries(tQuery);
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvseries(tQuery))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.searchTvseries(tQuery);
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertTvseriesWatchList(testTvseriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvseriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertTvseriesWatchList(testTvseriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTvseriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeTvseriesWatchList(testTvseriesTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTvseriesDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeTvseriesWatchList(testTvseriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTvseriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTvseriesById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tv shows', () {
    test('should return list of Tv Shows', () async {
      // arrange
      when(mockLocalDataSource.getTvseriesWatchList())
          .thenAnswer((_) async => [testTvseriesTable]);
      // act
      final result = await repository.getTvseriesWatchList();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvseries]);
    });
  });
}
