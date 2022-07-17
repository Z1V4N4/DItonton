import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_wacthlist_tvseries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListTvseries usecase;
  late MockTvseriesRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvseriesRepository();
    usecase = GetWatchListTvseries(mockTvShowRepository);
  });

  test('should get list of tv shows from the repository', () async {
    // arrange
    when(mockTvShowRepository.getTvseriesWatchList())
        .thenAnswer((_) async => Right(testTvseriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvseriesList));
  });
}
