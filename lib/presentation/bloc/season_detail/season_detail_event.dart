part of 'season_detail_bloc.dart';

abstract class SeasonDetailEvent extends Equatable {
  const SeasonDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchSeasonDetail extends SeasonDetailEvent {
  final int seriesId;
  final int seasonId;

  const FetchSeasonDetail(this.seriesId, this.seasonId);

  @override
  List<Object> get props => [seriesId, seasonId];
}
