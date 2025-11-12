import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tvshow/season_detail_tvshow_page.dart';
import 'package:ditonton/presentation/provider/tvshow/season_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'season_detail_tvshow_page_test.mocks.dart';

@GenerateMocks([SeasonDetailNotifier])
void main() {
  late MockSeasonDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockSeasonDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<SeasonDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(
        makeTestableWidget(SeasonDetailTvshowPage(seasonId: 1, seriesId: 1)));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.seasonDetail).thenReturn(testSeasonDetail.episodes);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(SeasonDetailTvshowPage(seasonId: 1, seriesId: 1)));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(SeasonDetailTvshowPage(seasonId: 1, seriesId: 1)));

    expect(textFinder, findsOneWidget);
  });
}
