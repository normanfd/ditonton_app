import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/presentation/pages/tvshow/top_rated_tvshow_page.dart';
import 'package:ditonton/presentation/provider/tvshow/top_rated_tvshow_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_tvshow_page_test.mocks.dart';

@GenerateMocks([TopRatedTvshowNotifier])
void main() {
  late MockTopRatedTvshowNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTopRatedTvshowNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedTvshowNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(TopRatedTvshowPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvshow).thenReturn(<Tvshow>[testTvshow]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(TopRatedTvshowPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(TopRatedTvshowPage()));

    expect(textFinder, findsOneWidget);
  });
}
