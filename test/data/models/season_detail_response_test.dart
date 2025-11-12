import 'package:ditonton/data/models/tvshow/season_detail_response.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final seasonDetailResponse = SeasonDetailResponse(
      idMongo: "",
      airDate: "",
      episodes: [
        EpisodeModel(
            episodeNumber: 1,
            id: 1,
            seasonNumber: 1,
            voteAverage: 1,
            voteCount: 1,
            name: "name",
            overview: "overview")
      ],
      name: "",
      networks: [
        NetworkModel(id: 1, logoPath: "", name: "", originCountry: "")
      ],
      overview: "",
      id: 1,
      posterPath: "",
      seasonNumber: 1,
      voteAverage: 1);

  final seasonDetail = SeasonDetail(
      idMongo: "",
      airDate: "",
      episodes: [
        SeasonEpisode(
            episodeNumber: 1,
            id: 1,
            seasonNumber: 1,
            voteAverage: 1,
            voteCount: 1,
            name: "name",
            overview: "overview")
      ],
      name: "",
      networks: [
        SeasonNetwork(id: 1, logoPath: "", name: "", originCountry: "")
      ],
      overview: "",
      id: 1,
      posterPath: "",
      seasonNumber: 1,
      voteAverage: 1);

  test('should be a subclass of Movie entity', () async {
    final result = seasonDetailResponse.toEntity();
    expect(result, seasonDetail);
  });
}
