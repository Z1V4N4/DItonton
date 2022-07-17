import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_now_airing_tvseries.dart';
import 'package:ditonton/domain/usecases/get_popular_tvseries.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvseries.dart';
import 'package:ditonton/presentation/provider/tvseries_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_airing_tvseries_notifier_series.mocks.dart';
import 'popular_tvseries_notifier_test.mocks.dart';
import 'top_rated_tvseries_notifier_test.mocks.dart';

@GenerateMocks([GetNowAiringTvseries, GetPopularTvseries, GetTopRatedTvseries])
void main() {
  late TvSeriesListNotifier provider;
  late MockGetNowAiringTvseries mockGetNowAiringTvseries;
  late MockGetPopularTvseries mockGetPopularTvseries;
  late MockGetTopRatedTvseries mockGetTopRatedTvseries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowAiringTvseries = MockGetNowAiringTvseries();
    mockGetPopularTvseries = MockGetPopularTvseries();
    mockGetTopRatedTvseries = MockGetTopRatedTvseries();
    provider = TvSeriesListNotifier(
      getNowAiringTvseries: mockGetNowAiringTvseries,
      getPopularTvseries: mockGetPopularTvseries,
      getTopRatedTvseries: mockGetTopRatedTvseries,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tseries = Tvseries(
      backdropPath: 'backdropPath',
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
  final tTvseriesList = <Tvseries>[tseries];

  group('now playing tv shows', () {
    test('initialState should be Empty', () {
      expect(provider.nowAiringState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowAiringTvseries.execute())
          .thenAnswer((_) async => Right(tTvseriesList));
      // act
      provider.fetchNowAiringTvseries();
      // assert
      verify(mockGetNowAiringTvseries.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowAiringTvseries.execute())
          .thenAnswer((_) async => Right(tTvseriesList));
      // act
      provider.fetchNowAiringTvseries();
      // assert
      expect(provider.nowAiringState, RequestState.Loading);
    });

    test('should change tv shows when data is gotten successfully', () async {
      // arrange
      when(mockGetNowAiringTvseries.execute())
          .thenAnswer((_) async => Right(tTvseriesList));
      // act
      await provider.fetchNowAiringTvseries();
      // assert
      expect(provider.nowAiringState, RequestState.Loaded);
      expect(provider.nowAiringTvseries, tTvseriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowAiringTvseries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowAiringTvseries();
      // assert
      expect(provider.nowAiringState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTvseries.execute())
          .thenAnswer((_) async => Right(tTvseriesList));
      // act
      provider.fetchPopularTvseries();
      // assert
      expect(provider.popularTvseriesState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change tv shows data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetPopularTvseries.execute())
              .thenAnswer((_) async => Right(tTvseriesList));
          // act
          await provider.fetchPopularTvseries();
          // assert
          expect(provider.popularTvseriesState, RequestState.Loaded);
          expect(provider.popularTvseries, tTvseriesList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTvseries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTvseries();
      // assert
      expect(provider.popularTvseriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTvseries.execute())
          .thenAnswer((_) async => Right(tTvseriesList));
      // act
      provider.fetchTopRatedTvseries();
      // assert
      expect(provider.topRatedTvseriesState, RequestState.Loading);
    });

    test('should change tv shows data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetTopRatedTvseries.execute())
              .thenAnswer((_) async => Right(tTvseriesList));
          // act
          await provider.fetchTopRatedTvseries();
          // assert
          expect(provider.topRatedTvseriesState, RequestState.Loaded);
          expect(provider.topRatedTvseries, tTvseriesList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTvseries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTvseries();
      // assert
      expect(provider.topRatedTvseriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
