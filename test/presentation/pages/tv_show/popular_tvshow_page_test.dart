import 'package:ditonton/presentation/bloc/popular_tv_show/popular_tv_show_bloc.dart';
import 'package:ditonton/presentation/pages/tvshow/popular_tvshow_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../dummy_data/dummy_objects.dart';

class MockPopularTvshowBloc extends MockBloc<PopularTvshowEvent, PopularTvshowState> implements PopularTvshowBloc {}

void main() {
  late MockPopularTvshowBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularTvshowBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvshowBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTvshowLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(PopularTvshowPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTvshowLoaded([testTvshow]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(PopularTvshowPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(PopularTvshowError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(PopularTvshowPage()));

    expect(textFinder, findsOneWidget);
  });
}
