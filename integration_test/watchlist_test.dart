import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/main.dart' as app;
import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Add and Remove Watchlist', () {
    setUpAll(() {
      di.init();
    });

    tearDownAll(() {
      di.locator.reset();
    });

    testWidgets('Add Watchlist', (WidgetTester tester) async {
      // start, dengan catatan watchlist kosong dan item pertama blm di add to watchlist
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // pindah tab tv show
      await tester.tap(find.byIcon(Icons.tv));
      await tester.pumpAndSettle();

      // masuk ke list see more pada bagian popular
      final popularRow =
          find.ancestor(of: find.text('Popular'), matching: find.byType(Row));
      final seeMoreButton =
          find.descendant(of: popularRow, matching: find.text('See More'));

      await tester.tap(seeMoreButton);
      await tester.pumpAndSettle();

      // pilih list pertama yang tertampil untuk ke halaman detail
      final listFinder = find.byType(ListView);
      final itemFinder = find.descendant(
        of: listFinder,
        matching: find.byType(TvshowCard),
      );
      expect(itemFinder, findsWidgets);
      await tester.tap(itemFinder.first);
      await tester.pumpAndSettle();

      // Tambahkan ke watchlist
      final textFinder = find.text('Watchlist');
      expect(textFinder, findsOneWidget);
      await tester.tap(textFinder);
      await tester.pumpAndSettle();
      expect(find.text('Added to Watchlist'), findsOneWidget);

      // kembali ke main page klik back 2 kali
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Buka Drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap item
      await tester.tap(find.text("TV Show Watchlist"));
      await tester.pumpAndSettle();

      // Verifikasi halaman tujuan
      final listFinder2 = find.byType(ListView);
      final itemFinder2 = find.descendant(
        of: listFinder2,
        matching: find.byType(TvshowCard),
      );

      // Pastikan ada minimal satu item
      expect(itemFinder2, findsWidgets);
    });

    testWidgets('Remove Watchlist', (WidgetTester tester) async {
      // start, dengan catatan watchlist sudah terisi dari test diatas dan item pertama masih ada di watchlist
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Buka Drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap item
      await tester.tap(find.text("TV Show Watchlist"));
      await tester.pumpAndSettle();

      // Verifikasi halaman tujuan
      final listFinder2 = find.byType(ListView);
      final itemFinder2 = find.descendant(
        of: listFinder2,
        matching: find.byType(TvshowCard),
      );

      // Pastikan ada minimal satu item
      expect(itemFinder2, findsWidgets);

      await tester.tap(itemFinder2.first);
      await tester.pumpAndSettle();

      // hapus dari watchlist
      final textFinder = find.text('Watchlist');
      expect(textFinder, findsOneWidget);
      await tester.tap(textFinder);
      await tester.pumpAndSettle();

      expect(find.text('Removed from Watchlist'), findsOneWidget);
    });
  });
}
