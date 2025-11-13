import 'package:ditonton/presentation/pages/tvshow/season_detail_tvshow_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:ditonton/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:mocktail/mocktail.dart';
import '../../../dummy_data/dummy_objects.dart';

class MockSeasonDetailBloc extends MockBloc<SeasonDetailEvent, SeasonDetailState> implements SeasonDetailBloc {}

void main() {
  late MockSeasonDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockSeasonDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SeasonDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SeasonDetailLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(SeasonDetailTvshowPage(seasonId: 1, seriesId: 1)));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SeasonDetailLoaded(testSeasonDetail.episodes));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(SeasonDetailTvshowPage(seasonId: 1, seriesId: 1)));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(SeasonDetailError('Error message'));

    await tester.pumpWidget(makeTestableWidget(SeasonDetailTvshowPage(seasonId: 1, seriesId: 1)));

    expect(find.text('Data episode kosong.'), findsOneWidget);
  });
}
