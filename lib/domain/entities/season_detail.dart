import 'package:equatable/equatable.dart';

class SeasonDetail extends Equatable {
  final String? idMongo; // _id dari JSON (string)
  final String? airDate;
  List<SeasonEpisode> episodes;
  final String? name;
  final List<SeasonNetwork> networks;
  final String? overview;
  final int id;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  SeasonDetail({
    this.idMongo,
    this.airDate,
    this.episodes = const [],
    this.name,
    this.networks = const [],
    this.overview,
    required this.id,
    this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  @override
  List<Object?> get props => [
        idMongo,
        airDate,
        episodes,
        name,
        networks,
        overview,
        id,
        posterPath,
        seasonNumber,
        voteAverage,
      ];
}

class SeasonEpisode extends Equatable {
  final String? airDate;
  final int episodeNumber;
  final String? episodeType;
  final int id;
  String? name;
  String? overview;
  final String? productionCode;
  final int? runtime;
  final int seasonNumber;
  final int? showId;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;
  final List<dynamic> crew;
  final List<dynamic> guestStars;

  SeasonEpisode({
    this.airDate,
    required this.episodeNumber,
    this.episodeType,
    required this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.runtime,
    required this.seasonNumber,
    this.showId,
    this.stillPath,
    required this.voteAverage,
    required this.voteCount,
    this.crew = const [],
    this.guestStars = const [],
  });

  @override
  List<Object?> get props => [
        airDate,
        episodeNumber,
        episodeType,
        id,
        name,
        overview,
        productionCode,
        runtime,
        seasonNumber,
        showId,
        stillPath,
        voteAverage,
        voteCount,
        crew,
        guestStars,
      ];
}

class SeasonNetwork extends Equatable {
  final int id;
  final String? logoPath;
  final String? name;
  final String? originCountry;

  const SeasonNetwork({
    required this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });

  factory SeasonNetwork.fromJson(Map<String, dynamic> json) => SeasonNetwork(
        id: (json['id'] is int)
            ? json['id'] as int
            : int.tryParse('${json['id']}') ?? 0,
        logoPath: json['logo_path'] as String?,
        name: json['name'] as String?,
        originCountry: json['origin_country'] as String?,
      );

  @override
  List<Object?> get props => [id, logoPath, name, originCountry];
}
