import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tvshow/season_detail_response.dart';
import 'package:http/http.dart' as http;

import '../../../util/crashlytics_helper.dart';
import '../../models/tvshow/tvshow_detail_response.dart';
import '../../models/tvshow/tvshow_model.dart';
import '../../models/tvshow/tvshow_response.dart';

abstract class TvshowRemoteDataSource {
  Future<List<TvshowModel>> getNowPlayingTvshow();

  Future<List<TvshowModel>> getPopularTvshow();

  Future<List<TvshowModel>> getTopRatedTvshow();

  Future<TvshowDetailResponse> getTvshowDetail(int id);

  Future<List<TvshowModel>> getTvshowRecommendations(int id);

  Future<List<TvshowModel>> searchTvshow(String query);

  Future<SeasonDetailResponse> getTvshowSeasonDetail(
      int seriesId, int seasonId);
}

class TvshowRemoteDataSourceImpl implements TvshowRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvshowRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvshowModel>> getNowPlayingTvshow() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TvshowResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      await CrashlyticsHelper.recordApiError(
          '$BASE_URL/tv/on_the_air', response);
      throw ServerException();
    }
  }

  @override
  Future<TvshowDetailResponse> getTvshowDetail(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TvshowDetailResponse.fromJson(json.decode(response.body));
    } else {
      await CrashlyticsHelper.recordApiError('$BASE_URL/tv/$id', response);
      throw ServerException();
    }
  }

  @override
  Future<List<TvshowModel>> getTvshowRecommendations(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TvshowResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      await CrashlyticsHelper.recordApiError(
          '$BASE_URL/tv/$id/recommendations', response);
      throw ServerException();
    }
  }

  @override
  Future<List<TvshowModel>> getPopularTvshow() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TvshowResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      await CrashlyticsHelper.recordApiError('$BASE_URL/tv/popular', response);
      throw ServerException();
    }
  }

  @override
  Future<List<TvshowModel>> getTopRatedTvshow() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TvshowResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      await CrashlyticsHelper.recordApiError(
          '$BASE_URL/tv/top_rated', response);
      throw ServerException();
    }
  }

  @override
  Future<List<TvshowModel>> searchTvshow(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return TvshowResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      await CrashlyticsHelper.recordApiError(
          '$BASE_URL/search/tv?query=$query', response);
      throw ServerException();
    }
  }

  @override
  Future<SeasonDetailResponse> getTvshowSeasonDetail(
      int seriesId, int seasonId) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$seriesId/season/$seasonId?$API_KEY'));

    if (response.statusCode == 200) {
      return SeasonDetailResponse.fromJson(json.decode(response.body));
    } else {
      await CrashlyticsHelper.recordApiError(
          '$BASE_URL/tv/$seriesId/season/$seasonId', response);
      throw ServerException();
    }
  }
}
