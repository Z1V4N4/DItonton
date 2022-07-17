import 'dart:convert';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tvseries/tvseries_remote_data_source.dart';
import 'package:ditonton/data/models/tvseries_detail_model.dart';
import 'package:ditonton/data/models/tvseries_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvseriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvseriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Airing Tv Series', () {
    final tTvseriesList = TvseriesResponse.fromJson(
        json.decode(readJson('dummy_data/now_airing.json')))
        .tvseriesList;

    test('should return list of Tv Series Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/now_airing.json'), 200));
          // act
          final result = await dataSource.getNowAiringTvseries();
          // assert
          expect(result, equals(tTvseriesList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getNowAiringTvseries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Popular Tv Series', () {
    final tTvSeriesList =
        TvseriesResponse.fromJson(json.decode(readJson('dummy_data/popular_series.json')))
            .tvseriesList;

    test('should return list of tv series when response is success (200)',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/popular_series.json'), 200));
          // act
          final result = await dataSource.getPopularTvseries();
          // assert
          expect(result, tTvSeriesList);
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getPopularTvseries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Top Rated Tv Series', () {
    final tTvseriesList = TvseriesResponse.fromJson(
        json.decode(readJson('dummy_data/top_rated_tvseries.json')))
        .tvseriesList;

    test('should return list of tv series when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/top_rated_tvseries.json'), 200));
      // act
      final result = await dataSource.getTopRatedTvseries();
      // assert
      expect(result, tTvseriesList);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTopRatedTvseries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get tv series detail', () {
    final tId = 1;
    final tTvSeriesDetail = TvseriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tvseries_detail.json')));

    test('should return tv series detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tvseries_detail.json'), 200));
      // act
      final result = await dataSource.getTvseriesDetail(tId);
      // assert
      expect(result, equals(tTvSeriesDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTvseriesDetail(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get tv series recommendations', () {
    final tTvSeriesList = TvseriesResponse.fromJson(
        json.decode(readJson('dummy_data/tvseries_recommendations.json')))
        .tvseriesList;
    final tId = 1;

    test('should return list of Movie Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tvseries_recommendations.json'), 200));
          // act
          final result = await dataSource.getTvseriesRecommendations(tId);
          // assert
          expect(result, equals(tTvSeriesList));
        });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTvseriesRecommendations(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('search tv series', () {
    final tSearchResult = TvseriesResponse.fromJson(
        json.decode(readJson('dummy_data/search_spiderman_tvseries.json')))
        .tvseriesList;
    final tQuery = 'Spiderman';

    test('should return list of tv series when response code is 200', () async {
      // arrange
      when(mockHttpClient
          .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
          readJson('dummy_data/search_spiderman_tvseries.json'), 200));
      // act
      final result = await dataSource.searchTvseries(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.searchTvseries(tQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });
}
