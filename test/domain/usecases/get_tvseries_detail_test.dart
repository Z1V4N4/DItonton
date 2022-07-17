import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tvseries_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvseriesDetail usecase;
  late MockTvseriesRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvseriesRepository();
    usecase = GetTvseriesDetail(mockTvShowRepository);
  });

  final tId = 1;

  test('should get tv show detail from the repository', () async {
    // arrange
    when(mockTvShowRepository.getTvseriesDetail(tId))
        .thenAnswer((_) async => Right(testTvseriesDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testTvseriesDetail));
  });
}
