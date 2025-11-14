import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState(tabIndex: 0)) {
    on<MainTabChanged>((event, emit) {
      emit(MainState(tabIndex: event.tabIndex));
    });
  }
}
