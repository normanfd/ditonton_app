import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tvshow/tvshow_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockTvshowDetailBloc
    extends MockBloc<TvshowDetailEvent, TvshowDetailState>
    implements TvshowDetailBloc {}

void main() {
  late MockTvshowDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvshowDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvshowDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tStateLoaded = TvshowDetailState(
    tvshowState: RequestState.Loaded,
    tvshow: testTvshowDetail,
    recommendationState: RequestState.Loaded,
    tvshowRecommendations: <Tvshow>[testTvshow],
    isAddedToWatchlist: false,
    watchlistMessage: '',
    message: '',
  );

  testWidgets(
      'Watchlist button should display add icon when tvshow not added to watchlist',
      (WidgetTester tester) async {
    final tState = tStateLoaded.copyWith(isAddedToWatchlist: false);
    when(() => mockBloc.state).thenReturn(tState);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(TvshowDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when tvshow is added to wathclist',
      (WidgetTester tester) async {
    final tState = tStateLoaded.copyWith(isAddedToWatchlist: true);
    when(() => mockBloc.state).thenReturn(tState);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(TvshowDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final tStateInitial =
        tStateLoaded.copyWith(isAddedToWatchlist: false, watchlistMessage: '');

    final tStateSuccess = tStateLoaded.copyWith(
        isAddedToWatchlist: true, watchlistMessage: 'Added to Watchlist');

    when(() => mockBloc.state).thenReturn(tStateInitial);

    whenListen(
      mockBloc,
      Stream.fromIterable([tStateSuccess]),
      initialState: tStateInitial,
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(makeTestableWidget(TvshowDetailPage(id: 1)));
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);

    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final tStateInitial =
        tStateLoaded.copyWith(isAddedToWatchlist: false, watchlistMessage: '');
    final tStateFailed = tStateLoaded.copyWith(
        isAddedToWatchlist: false, watchlistMessage: 'Failed');

    when(() => mockBloc.state).thenReturn(tStateInitial);
    whenListen(
      mockBloc,
      Stream.fromIterable([tStateFailed]),
      initialState: tStateInitial,
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(makeTestableWidget(TvshowDetailPage(id: 1)));
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);

    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
