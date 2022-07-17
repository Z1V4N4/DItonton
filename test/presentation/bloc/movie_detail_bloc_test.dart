import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieDetailBloc = MovieDetailBloc(
        mockGetMovieDetail,
        mockGetMovieRecommendations,
        mockGetWatchlistStatus,
        mockSaveWatchlist,
        mockRemoveWatchlist
    );
  });

  final tId = 1;
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Comedy')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 1,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  test('initial state should be empty', () {
    expect(movieDetailBloc.state, MovieDetailEmpty());
  });

  group('Get Movie Detail', () {

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit MovieDetailLoading and MovieDetailHasData when get Detail Movies and Recommendation Succeed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(GetMovieDetailEvent(id: tId)),
      expect: () => [MovieDetailLoading(), MovieDetailHasData(movie: tMovieDetail, recommendations: tMovies, status: false)],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit MovieDetailLoading and MovieDetailError when Get MovieRecommendations Failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(GetMovieDetailEvent(id: tId)),
      expect: () => [MovieDetailLoading(), MovieDetailError('Failed')],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit MovieDetailError when Get Movie Detail Failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(GetMovieDetailEvent(id: tId)),
      expect: () => [MovieDetailLoading(), MovieDetailError('Failed')],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });

  group('AddToWatchlist Movie', () {

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit WatchlistSuccess and isAddedToWatchlist True when AddWatchlist Succeed',
      build: () {
        when(mockSaveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistEvent(movie: tMovieDetail)),
      expect: () => [WatchlistSuccess(message: 'Added to Watchlist'), WatchlistStatusState(status: true)],
      verify: (_) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
      },
    );
  });

  group('RemoveFromWatchlist Movie', () {

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit WatchlistMessage and isAddedToWatchlist False when Success RemoveFromWatchlist',
      build: () {
        when(mockRemoveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveWatchlistEvent(movie: tMovieDetail)),
      expect: () => [WatchlistSuccess(message: 'Removed from Watchlist'), WatchlistStatusState(status: false)],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
      },
    );
  });
}