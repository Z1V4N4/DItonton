import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tvseries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTvseries usecase;
  late MockTvseriesRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvseriesRepository();
    usecase = SaveWatchlistTvseries(mockTvShowRepository);
  });

  test('should save tv shows to the repository', () async {
    // arrange
    when(mockTvShowRepository.saveWatchlist(testTvseriesDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvseriesDetail);
    // assert
    verify(mockTvShowRepository.saveWatchlist(testTvseriesDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
