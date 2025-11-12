import 'package:ditonton/data/models/tvshow/tvshow_model.dart';
import 'package:equatable/equatable.dart';

class TvshowResponse extends Equatable {
  final List<TvshowModel> movieList;

  const TvshowResponse({required this.movieList});

  factory TvshowResponse.fromJson(Map<String, dynamic> json) => TvshowResponse(
        movieList: List<TvshowModel>.from((json["results"] as List)
            .map((x) => TvshowModel.fromJson(x))
            .where((element) => element.posterPath != null)),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(movieList.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [movieList];
}
