import 'package:ditonton/main.dart' as app;
import 'package:ditonton/presentation/pages/tvshow/tvshow_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('TV Show Page Content', () {
    setUpAll(() {
      di.init();
    });

    tearDownAll(() {
      di.locator.reset();
    });

    testWidgets('tapping "See More" on Popular navigates to PopularTvshowPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.tv));
      await tester.pumpAndSettle();

      final popularRow =
          find.ancestor(of: find.text('Popular'), matching: find.byType(Row));
      final seeMoreButton =
          find.descendant(of: popularRow, matching: find.text('See More'));

      await tester.tap(seeMoreButton);
      await tester.pumpAndSettle();

      expect(find.text('Popular Tv Show'), findsOneWidget);

      // terdapat list view dengan data
      final listFinder = find.byType(ListView);
      final itemFinder = find.descendant(
        of: listFinder,
        matching: find.byType(TvshowCard),
      );

      // memastikan hasil minimal 1
      expect(itemFinder, findsAtLeastNWidgets(1));

      // jika di klik masuk halaman detail
      await tester.tap(itemFinder.first);
      await tester.pumpAndSettle();
      expect(find.byType(TvshowDetailPage), findsOneWidget);
    });

    testWidgets(
        'tapping "See More" on Top Rated navigates to Top RatedTvshowPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.tv));
      await tester.pumpAndSettle();

      final popularRow =
          find.ancestor(of: find.text('Top Rated'), matching: find.byType(Row));
      final seeMoreButton =
          find.descendant(of: popularRow, matching: find.text('See More'));

      await tester.tap(seeMoreButton);
      await tester.pumpAndSettle();

      expect(find.text('Top Rated Tv Show'), findsOneWidget);

      // terdapat list view dengan data
      final listFinder = find.byType(ListView);
      final itemFinder = find.descendant(
        of: listFinder,
        matching: find.byType(TvshowCard),
      );

      // memastikan hasil minimal 1
      expect(itemFinder, findsAtLeastNWidgets(1));

      // jika di klik masuk halaman detail
      await tester.tap(itemFinder.first);
      await tester.pumpAndSettle();
      expect(find.byType(TvshowDetailPage), findsOneWidget);
    });

    testWidgets(
        'tapping "See More" on Now Playing navigates to NowPlayingTvshowPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.tv));
      await tester.pumpAndSettle();

      final row = find.ancestor(
          of: find.text('Now Playing'), matching: find.byType(Row));
      final seeMoreButton =
          find.descendant(of: row, matching: find.text('See More'));

      await tester.tap(seeMoreButton);
      await tester.pumpAndSettle();

      expect(find.text('Now Playing Tv Show'), findsOneWidget);

      // terdapat list view dengan data
      final listFinder = find.byType(ListView);
      final itemFinder = find.descendant(
        of: listFinder,
        matching: find.byType(TvshowCard),
      );

      // memastikan hasil minimal 1
      expect(itemFinder, findsAtLeastNWidgets(1));

      // jika di klik masuk halaman detail
      await tester.tap(itemFinder.first);
      await tester.pumpAndSettle();
      expect(find.byType(TvshowDetailPage), findsOneWidget);
    });
  });
}
