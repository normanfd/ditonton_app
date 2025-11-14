part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class MainTabChanged extends MainEvent {
  final int tabIndex;

  const MainTabChanged(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}
