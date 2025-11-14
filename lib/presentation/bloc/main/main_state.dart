part of 'main_bloc.dart';

class MainState extends Equatable {
  final int tabIndex;

  const MainState({required this.tabIndex});

  @override
  List<Object> get props => [tabIndex];
}
