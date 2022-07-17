import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_popular_tvseries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvseries usecase;
  late MockTvseriesRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvseriesRepository();
    usecase = GetPopularTvseries(mockTvShowRepository);
  });

  final tTvShows = <Tvseries>[];

  group('GetPopularTvShows Tests', () {
    group('execute', () {
      test(
          'should get list of tv shows from the repository when execute function is called',
              () async {
            // arrange
            when(mockTvShowRepository.getPopularTvseries())
                .thenAnswer((_) async => Right(tTvShows));
            // act
            final result = await usecase.execute();
            // assert
            expect(result, Right(tTvShows));
          });
    });
  });
}
