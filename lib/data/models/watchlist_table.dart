import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tvshow_detail.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/Tvshow.dart';

class WatchlistTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String? tipe;

  const WatchlistTable(
      {required this.id,
      required this.title,
      required this.posterPath,
      required this.overview,
      required this.tipe});

  factory WatchlistTable.fromEntity(MovieDetail movie) => WatchlistTable(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      tipe: "m");

  factory WatchlistTable.fromTvshowEntity(TvshowDetail movie) => WatchlistTable(
      id: movie.id,
      title: movie.name,
      posterPath: movie.posterPath,
      overview: movie.overview,
      tipe: "t");

  factory WatchlistTable.fromMap(Map<String, dynamic> map) => WatchlistTable(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      overview: map['overview'],
      tipe: map['tipe']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'tipe': tipe
      };

  Movie toEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
      );

  Tvshow toTvshowEntity() => Tvshow.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        name: title,
      );

  @override
  List<Object?> get props => [id, title, posterPath, overview];
}
