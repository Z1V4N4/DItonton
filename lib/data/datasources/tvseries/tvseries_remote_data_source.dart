import 'dart:convert';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tvseries_detail_model.dart';
import 'package:ditonton/data/models/tvseries_model.dart';
import 'package:ditonton/data/models/tvseries_response.dart';
import 'package:http/http.dart' as http;

abstract class TvseriesRemoteDataSource {
  Future<List<TvseriesModel>> getNowAiringTvseries();
  Future<List<TvseriesModel>> getPopularTvseries();
  Future<List<TvseriesModel>> getTopRatedTvseries();
  Future<TvseriesDetailResponse> getTvseriesDetail(int id);
  Future<List<TvseriesModel>> getTvseriesRecommendations(int id);
  Future<List<TvseriesModel>> searchTvseries(String query);
}

class TvseriesRemoteDataSourceImpl implements TvseriesRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvseriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvseriesModel>> getNowAiringTvseries() async {
    final response =
    await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TvseriesResponse.fromJson(json.decode(response.body)).tvseriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvseriesDetailResponse> getTvseriesDetail(int id) async {
    final response =
    await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TvseriesDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvseriesModel>> getTvseriesRecommendations(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TvseriesResponse.fromJson(json.decode(response.body)).tvseriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvseriesModel>> getPopularTvseries() async {
    final response =
    await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TvseriesResponse.fromJson(json.decode(response.body)).tvseriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvseriesModel>> getTopRatedTvseries() async {
    final response =
    await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TvseriesResponse.fromJson(json.decode(response.body)).tvseriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvseriesModel>> searchTvseries(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return TvseriesResponse.fromJson(json.decode(response.body)).tvseriesList;
    } else {
      throw ServerException();
    }
  }

}
