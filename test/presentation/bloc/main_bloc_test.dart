import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:ditonton/presentation/bloc/main/main_bloc.dart';

void main() {
  group('MainBloc', () {
    test('initial state should be MainState(tabIndex: 0)', () {
      expect(MainBloc().state, const MainState(tabIndex: 0));
    });

    blocTest<MainBloc, MainState>(
      'emits [MainState(tabIndex: 1)] when MainTabChanged(1) is added.',
      build: () => MainBloc(),
      act: (bloc) => bloc.add(const MainTabChanged(1)),
      expect: () => [
        const MainState(tabIndex: 1),
      ],
    );

    blocTest<MainBloc, MainState>(
      'emits [MainState(tabIndex: 1), MainState(tabIndex: 0)] when events are added sequentially.',
      build: () => MainBloc(),
      act: (bloc) {
        bloc.add(const MainTabChanged(1));
        bloc.add(const MainTabChanged(0));
      },
      expect: () => [
        const MainState(tabIndex: 1),
        const MainState(tabIndex: 0),
      ],
    );
  });
}
