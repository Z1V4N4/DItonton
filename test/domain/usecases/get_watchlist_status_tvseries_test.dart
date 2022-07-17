import 'package:ditonton/domain/usecases/get_watchlist_status_tvseries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListStatusTvseries usecase;
  late MockTvseriesRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvseriesRepository();
    usecase = GetWatchListStatusTvseries(mockTvShowRepository);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(mockTvShowRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
