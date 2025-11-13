import 'package:ditonton/data/models/tvshow/tvshow_model.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvshowModel = TvshowModel(
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

  final tMovie = Tvshow(
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

  test('should be a subclass of Tvshow entity', () async {
    final result = tTvshowModel.toEntity();
    expect(result, tMovie);
  });
}
