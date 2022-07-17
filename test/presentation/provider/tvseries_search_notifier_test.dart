import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/search_tvseries.dart';
import 'package:ditonton/presentation/provider/tvseries_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tvseries_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvseries])
void main() {
  late TvseriesSearchNotifier provider;
  late MockSearchTvseries mockSearchTvseries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTvseries = MockSearchTvseries();
    provider = TvseriesSearchNotifier(searchTvseries: mockSearchTvseries)
      ..addListener(() {
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
  final tTvSeriesList = <Tvseries>[tseries];
  final tQuery = 'spiderman';

  group('search tv show', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTvseries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      provider.fetchTvseriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
            () async {
          // arrange
          when(mockSearchTvseries.execute(tQuery))
              .thenAnswer((_) async => Right(tTvSeriesList));
          // act
          await provider.fetchTvseriesSearch(tQuery);
          // assert
          expect(provider.state, RequestState.Loaded);
          expect(provider.searchResult, tTvSeriesList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTvseries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvseriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
