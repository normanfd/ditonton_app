import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/domain/usecases/tvshow/get_season_detail.dart';

part 'season_detail_event.dart';

part 'season_detail_state.dart';

class SeasonDetailBloc extends Bloc<SeasonDetailEvent, SeasonDetailState> {
  final GetSeasonDetail getSeasonDetail;

  SeasonDetailBloc({required this.getSeasonDetail}) : super(SeasonDetailEmpty()) {
    on<FetchSeasonDetail>(_onFetchSeasonDetail);
  }

  Future<void> _onFetchSeasonDetail(FetchSeasonDetail event, Emitter<SeasonDetailState> emit) async {
    emit(SeasonDetailLoading());

    final result = await getSeasonDetail.execute(event.seriesId, event.seasonId);

    result.fold(
      (failure) {
        emit(SeasonDetailError(failure.message));
      },
      (seasonData) {
        emit(SeasonDetailLoaded(seasonData.episodes));
      },
    );
  }
}
