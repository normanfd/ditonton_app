import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tStateLoaded = MovieDetailState(
    movieState: RequestState.Loaded,
    movie: testMovieDetail,
    recommendationState: RequestState.Loaded,
    movieRecommendations: <Movie>[testMovie],
    isAddedToWatchlist: false,
    watchlistMessage: '',
    message: '',
  );

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    final tState = tStateLoaded.copyWith(isAddedToWatchlist: false);
    when(() => mockBloc.state).thenReturn(tState);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    final tState = tStateLoaded.copyWith(isAddedToWatchlist: true);
    when(() => mockBloc.state).thenReturn(tState);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

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

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
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

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);

    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
