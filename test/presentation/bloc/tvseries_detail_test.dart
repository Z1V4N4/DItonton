import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tvseries.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tvseries.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_event.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail/tvseries_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tvseries_detail_test.mocks.dart';

@GenerateMocks([
  GetTvseriesDetail,
  GetTvseriesRecommendations,
  GetWatchListStatusTvseries,
  SaveWatchlistTvseries,
  RemoveWatchlistTvseries,
])
void main() {
  late TvseriesDetailBloc tvseriesDetailBloc;
  late MockGetTvseriesDetail mockGetTvseriesDetail;
  late MockGetTvseriesRecommendations mockGetTvseriesRecommendations;
  late MockGetWatchListStatusTvseries mockGetWatchlistStatus;
  late MockSaveWatchlistTvseries mockSaveWatchlist;
  late MockRemoveWatchlistTvseries mockRemoveWatchlist;

  setUp(() {
    mockGetTvseriesDetail = MockGetTvseriesDetail();
    mockGetTvseriesRecommendations = MockGetTvseriesRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTvseries();
    mockSaveWatchlist = MockSaveWatchlistTvseries();
    mockRemoveWatchlist = MockRemoveWatchlistTvseries();
    tvseriesDetailBloc = TvseriesDetailBloc(
        mockGetTvseriesDetail,
        mockGetTvseriesRecommendations,
        mockGetWatchlistStatus,
        mockSaveWatchlist,
        mockRemoveWatchlist
    );
  });

  final tId = 1;
  final tTv = Tvseries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    name: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvs = <Tvseries>[tTv];

  final tTvDetail = TvseriesDetail(
      backdropPath: 'backdropPath',
      genres: [Genre(id: 1, name: 'Comedy')],
      id: 1,
      originalName: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      name: 'title',
      voteAverage: 1,
      voteCount: 1,
      tagline: 'tagline',
      homepage: 'homepage',
      originalLanguage: 'originalLanguage',
      firstAirDate: 'firstAirDate',
      lastAirDate: 'lastAirDate',
      popularity: 1,
      status: 'status'
  );

  test('initial state should be empty', () {
    expect(tvseriesDetailBloc.state, TvseriesDetailEmpty());
  });

  group('Get Tv Detail', () {

    blocTest<TvseriesDetailBloc, TvseriesDetailState>(
      'Shoud emit TvDetailLoading and TvDetailHasData when get Detail Tvs and Recommendation Succeed',
      build: () {
        when(mockGetTvseriesDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvseriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvs));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvseriesDetailBloc;
      },
      act: (bloc) => bloc.add(GetTvseriesDetailEvent(id: tId)),
      expect: () => [TvseriesDetailLoading(), TvseriesDetailHasData(tvseriesDetail: tTvDetail, recommendations: tTvs, status: false)],
      verify: (_) {
        verify(mockGetTvseriesDetail.execute(tId));
        verify(mockGetTvseriesRecommendations.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<TvseriesDetailBloc, TvseriesDetailState>(
      'Shoud emit TvDetailLoading and TvDetailError when Get TvRecommendations Failed',
      build: () {
        when(mockGetTvseriesDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvseriesRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvseriesDetailBloc;
      },
      act: (bloc) => bloc.add(GetTvseriesDetailEvent(id: tId)),
      expect: () => [TvseriesDetailLoading(), TvseriesDetailError('Failed')],
      verify: (_) {
        verify(mockGetTvseriesDetail.execute(tId));
        verify(mockGetTvseriesRecommendations.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<TvseriesDetailBloc, TvseriesDetailState>(
      'Shoud emit TvDetailError when Get Tv Detail Failed',
      build: () {
        when(mockGetTvseriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetTvseriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvs));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvseriesDetailBloc;
      },
      act: (bloc) => bloc.add(GetTvseriesDetailEvent(id: tId)),
      expect: () => [TvseriesDetailLoading(), TvseriesDetailError('Failed')],
      verify: (_) {
        verify(mockGetTvseriesDetail.execute(tId));
        verify(mockGetTvseriesRecommendations.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });

  group('AddToWatchlist Tv', () {

    blocTest<TvseriesDetailBloc, TvseriesDetailState>(
      'Shoud emit WatchlistSuccess and isAddedToWatchlist True when AddWatchlist Succeed',
      build: () {
        when(mockSaveWatchlist.execute(tTvDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(tTvDetail.id))
            .thenAnswer((_) async => true);
        return tvseriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistEvent(tvseriesDetail: tTvDetail)),
      expect: () => [WatchlistSuccess(message: 'Added to Watchlist'), WatchlistStatusState(status: true)],
      verify: (_) {
        verify(mockSaveWatchlist.execute(tTvDetail));
        verify(mockGetWatchlistStatus.execute(tTvDetail.id));
      },
    );
  });

  group('RemoveFromWatchlist Tv', () {

    blocTest<TvseriesDetailBloc, TvseriesDetailState>(
      'Shoud emit WatchlistMessage and isAddedToWatchlist False when Success RemoveFromWatchlist',
      build: () {
        when(mockRemoveWatchlist.execute(tTvDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(tTvDetail.id))
            .thenAnswer((_) async => false);
        return tvseriesDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveWatchlistEvent(tvseriesDetail: tTvDetail)),
      expect: () => [WatchlistSuccess(message: 'Removed from Watchlist'), WatchlistStatusState(status: false)],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(tTvDetail));
        verify(mockGetWatchlistStatus.execute(tTvDetail.id));
      },
    );
  });
}