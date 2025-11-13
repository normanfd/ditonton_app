import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/Tvshow.dart';
import '../../../domain/usecases/tvshow/get_popular_tvshow.dart';

part 'popular_tv_show_event.dart';

part 'popular_tv_show_state.dart';

class PopularTvshowBloc extends Bloc<PopularTvshowEvent, PopularTvshowState> {
  final GetPopularTvshow getPopularTvshow;

  PopularTvshowBloc({required this.getPopularTvshow})
      : super(PopularTvshowEmpty()) {
    on<FetchPopularTvshows>(_onFetchPopularTvshows);
  }

  Future<void> _onFetchPopularTvshows(
    FetchPopularTvshows event,
    Emitter<PopularTvshowState> emit,
  ) async {
    emit(PopularTvshowLoading());

    final result = await getPopularTvshow.execute();

    result.fold(
      (failure) {
        emit(PopularTvshowError(failure.message));
      },
      (tvshowsData) {
        emit(PopularTvshowLoaded(tvshowsData));
      },
    );
  }
}
