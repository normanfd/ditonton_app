import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:equatable/equatable.dart';

class SeasonDetailResponse extends Equatable {
  final String? idMongo; // _id dari JSON (string)
  final String? airDate;
  final List<EpisodeModel> episodes;
  final String? name;
  final List<NetworkModel> networks;
  final String? overview;
  final int id;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  const SeasonDetailResponse({
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

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        idMongo: json['_id'] as String?,
        airDate: json['air_date'] as String?,
        episodes: (json['episodes'] as List<dynamic>?)
                ?.map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        name: json['name'] as String?,
        networks: (json['networks'] as List<dynamic>?)
                ?.map((e) => NetworkModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        overview: json['overview'] as String?,
        id: (json['id'] is int)
            ? json['id'] as int
            : int.tryParse('${json['id']}') ?? 0,
        posterPath: json['poster_path'] as String?,
        seasonNumber: (json['season_number'] is int)
            ? json['season_number'] as int
            : int.tryParse('${json['season_number']}') ?? 0,
        voteAverage: (json['vote_average'] is num)
            ? (json['vote_average'] as num).toDouble()
            : double.tryParse('${json['vote_average']}') ?? 0.0,
      );

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

  SeasonDetail toEntity() {
    return SeasonDetail(
      id: id,
      seasonNumber: seasonNumber,
      voteAverage: voteAverage,
      episodes: episodes.map((model) => model.toEntity()).toList(),
      idMongo: idMongo,
      airDate: airDate,
      name: name,
      overview: overview,
      posterPath: posterPath,
      networks: networks.map((model) => model.toEntity()).toList(),
    );
  }
}

class EpisodeModel extends Equatable {
  final String? airDate;
  final int episodeNumber;
  final String? episodeType;
  final int id;
  final String? name;
  final String? overview;
  final String? productionCode;
  final int? runtime;
  final int seasonNumber;
  final int? showId;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;
  final List<dynamic> crew;
  final List<dynamic> guestStars;

  const EpisodeModel({
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

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        airDate: json['air_date'] as String?,
        episodeNumber: (json['episode_number'] is int)
            ? json['episode_number'] as int
            : int.tryParse('${json['episode_number']}') ?? 0,
        episodeType: json['episode_type'] as String?,
        id: (json['id'] is int)
            ? json['id'] as int
            : int.tryParse('${json['id']}') ?? 0,
        name: json['name'] as String?,
        overview: json['overview'] as String?,
        productionCode: json['production_code'] as String?,
        runtime: (json['runtime'] is int)
            ? json['runtime'] as int
            : int.tryParse('${json['runtime']}'),
        seasonNumber: (json['season_number'] is int)
            ? json['season_number'] as int
            : int.tryParse('${json['season_number']}') ?? 0,
        showId: (json['show_id'] is int)
            ? json['show_id'] as int
            : int.tryParse('${json['show_id']}'),
        stillPath: json['still_path'] as String?,
        voteAverage: (json['vote_average'] is num)
            ? (json['vote_average'] as num).toDouble()
            : double.tryParse('${json['vote_average']}') ?? 0.0,
        voteCount: (json['vote_count'] is int)
            ? json['vote_count'] as int
            : int.tryParse('${json['vote_count']}') ?? 0,
        crew: (json['crew'] as List<dynamic>?) ?? [],
        guestStars: (json['guest_stars'] as List<dynamic>?) ?? [],
      );

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

  SeasonEpisode toEntity() {
    return SeasonEpisode(
        episodeNumber: episodeNumber,
        id: id,
        seasonNumber: seasonNumber,
        voteAverage: voteAverage,
        overview: overview,
        voteCount: voteCount,
        name: name,
        stillPath: stillPath);
  }
}

class NetworkModel extends Equatable {
  final int id;
  final String? logoPath;
  final String? name;
  final String? originCountry;

  const NetworkModel({
    required this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });

  factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
        id: (json['id'] is int)
            ? json['id'] as int
            : int.tryParse('${json['id']}') ?? 0,
        logoPath: json['logo_path'] as String?,
        name: json['name'] as String?,
        originCountry: json['origin_country'] as String?,
      );

  SeasonNetwork toEntity() {
    return SeasonNetwork(
      id: id,
      logoPath: logoPath,
      name: name,
      originCountry: originCountry,
    );
  }

  @override
  List<Object?> get props => [id, logoPath, name, originCountry];
}
