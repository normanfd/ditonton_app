import 'dart:convert';

import 'package:ditonton/data/models/tvshow/tvshow_model.dart';
import 'package:ditonton/data/models/tvshow/tvshow_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieModel = TvshowModel(
    backdropPath: "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
    firstAirDate: "2023-01-23",
    genreIds: [9648, 18],
    id: 202250,
    name: "Dirty Linen",
    originCountry: ["PH"],
    originalLanguage: "tl",
    originalName: "Dirty Linen",
    overview:
        "To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.",
    popularity: 2684.061,
    posterPath: "/ujlkQtHAVShWyWTloGU2Vh5Jbo9.jpg",
    voteAverage: 5,
    voteCount: 13,
  );
  final tMovieResponseModel =
      TvshowResponse(movieList: <TvshowModel>[tMovieModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing_tv_show.json'));
      // act
      final result = TvshowResponse.fromJson(jsonMap);
      // assert
      expect(result, tMovieResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tMovieResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
            "first_air_date": "2023-01-23",
            "genre_ids": [9648, 18],
            "id": 202250,
            "name": "Dirty Linen",
            "origin_country": ["PH"],
            "original_language": "tl",
            "original_name": "Dirty Linen",
            "overview":
                "To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.",
            "popularity": 2684.061,
            "poster_path": "/ujlkQtHAVShWyWTloGU2Vh5Jbo9.jpg",
            "vote_average": 5,
            "vote_count": 13
          }
        ]
      };
      expect(result, expectedJsonMap);
    });
  });
}
