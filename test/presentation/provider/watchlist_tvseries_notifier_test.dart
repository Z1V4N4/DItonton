import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_wacthlist_tvseries.dart';
import 'package:ditonton/presentation/provider/watchlist_tvseries_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tvseries_notifier_test.mocks.dart';

@GenerateMocks([GetWatchListTvseries])
void main() {
  late WatchListTvseriesNotifier provider;
  late MockGetWatchListTvseries mockGetWatchListTvseries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchListTvseries = MockGetWatchListTvseries();
    provider = WatchListTvseriesNotifier(
      getWatchListTvseries: mockGetWatchListTvseries,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  test('should change tv shows data when data is gotten successfully', () async {
    // arrange
    when(mockGetWatchListTvseries.execute())
        .thenAnswer((_) async => Right([testWatchlistTvseries]));
    // act
    await provider.fetchWatchlistTvseries();
    // assert
    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlistTvseries, [testWatchlistTvseries]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchListTvseries.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlistTvseries();
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
