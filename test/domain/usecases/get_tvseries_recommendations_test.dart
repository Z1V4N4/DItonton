import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_tvseries_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvseriesRecommendations usecase;
  late MockTvseriesRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvseriesRepository();
    usecase = GetTvseriesRecommendations(mockTvShowRepository);
  });

  final tId = 1;
  final tTvShows = <Tvseries>[];

  test('should get list of tv show recommendations from the repository',
          () async {
        // arrange
        when(mockTvShowRepository.getTvseriesRecommendations(tId))
            .thenAnswer((_) async => Right(tTvShows));
        // act
        final result = await usecase.execute(tId);
        // assert
        expect(result, Right(tTvShows));
      });
}
