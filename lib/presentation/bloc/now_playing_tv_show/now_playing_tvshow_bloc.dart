import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/Tvshow.dart';
import '../../../domain/usecases/tvshow/get_now_playing_tvshow.dart';

part 'now_playing_tvshow_event.dart';
part 'now_playing_tvshow_state.dart';

class NowPlayingTvshowBloc
    extends Bloc<NowPlayingTvshowEvent, NowPlayingTvshowState> {
  final GetNowPlayingTvshow getNowPlayingTvshow;

  NowPlayingTvshowBloc({required this.getNowPlayingTvshow})
      : super(NowPlayingTvshowEmpty()) {
    on<FetchNowPlayingTvshows>(_onFetchNowPlayingTvshows);
  }

  Future<void> _onFetchNowPlayingTvshows(
    FetchNowPlayingTvshows event,
    Emitter<NowPlayingTvshowState> emit,
  ) async {
    emit(NowPlayingTvshowLoading());

    final result = await getNowPlayingTvshow.execute();

    result.fold(
      (failure) {
        emit(NowPlayingTvshowError(failure.message));
      },
      (tvshowsData) {
        emit(NowPlayingTvshowLoaded(tvshowsData));
      },
    );
  }
}
