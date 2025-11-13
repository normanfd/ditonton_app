import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/Tvshow.dart';
import '../../../domain/usecases/tvshow/get_top_rated_tvshow.dart';

part 'top_rated_tv_show_event.dart';

part 'top_rated_tv_show_state.dart';

class TopRatedTvshowBloc
    extends Bloc<TopRatedTvshowEvent, TopRatedTvshowState> {
  final GetTopRatedTvshow getTopRatedTvshow;

  TopRatedTvshowBloc({required this.getTopRatedTvshow})
      : super(TopRatedTvshowEmpty()) {
    on<FetchTopRatedTvshows>(_onFetchTopRatedTvshows);
  }

  Future<void> _onFetchTopRatedTvshows(
      FetchTopRatedTvshows event, Emitter<TopRatedTvshowState> emit) async {
    emit(TopRatedTvshowLoading());

    final result = await getTopRatedTvshow.execute();

    result.fold(
      (failure) {
        emit(TopRatedTvshowError(failure.message));
      },
      (tvshowsData) {
        emit(TopRatedTvshowLoaded(tvshowsData));
      },
    );
  }
}
