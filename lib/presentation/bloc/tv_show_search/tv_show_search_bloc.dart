import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/Tvshow.dart';
import '../../../domain/usecases/tvshow/search_tvshow.dart';

part 'tv_show_search_event.dart';

part 'tv_show_search_state.dart';

class TvshowSearchBloc extends Bloc<TvshowSearchEvent, TvshowSearchState> {
  final SearchTvshow searchTvShow;

  TvshowSearchBloc({required this.searchTvShow}) : super(TvshowSearchEmpty()) {
    on<OnQueryChanged>(
      _onQueryChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );
  }

  Future<void> _onQueryChanged(
      OnQueryChanged event, Emitter<TvshowSearchState> emit) async {
    final query = event.query;
    if (query.isEmpty) {
      emit(TvshowSearchEmpty());
      return;
    }

    emit(TvshowSearchLoading());

    final result = await searchTvShow.execute(query);

    result.fold(
      (failure) {
        emit(TvshowSearchError(failure.message));
      },
      (data) {
        emit(TvshowSearchLoaded(data));
      },
    );
  }
}
