import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvseries.dart';
import 'package:ditonton/presentation/provider/top_rated_tvseries_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tvseries_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTvseries])
void main() {
  late MockGetTopRatedTvseries mockGetTopRatedTvseries;
  late TopRatedTvseriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTvseries = MockGetTopRatedTvseries();
    notifier = TopRatedTvseriesNotifier(getTopRatedTvseries: mockGetTopRatedTvseries)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTvShow = Tvseries(
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

  final tTvShowList = <Tvseries>[tTvShow];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetTopRatedTvseries.execute())
        .thenAnswer((_) async => Right(tTvShowList));
    // act
    notifier.fetchTopRatedTvseries();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv shows data when data is gotten successfully', () async {
    // arrange
    when(mockGetTopRatedTvseries.execute())
        .thenAnswer((_) async => Right(tTvShowList));
    // act
    await notifier.fetchTopRatedTvseries();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvseries, tTvShowList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedTvseries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTopRatedTvseries();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
