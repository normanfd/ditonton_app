import 'package:ditonton/main.dart' as app;
import 'package:ditonton/presentation/pages/main_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page_content.dart';
import 'package:ditonton/presentation/pages/tvshow/home_tvshow_page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/injection.dart' as di;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HomeScreen Integration Test', () {
    setUpAll(() {
      di.init();
    });

    tearDownAll(() {
      di.locator.reset();
    });

    testWidgets('Bottom navigation bar switches pages and updates AppBar title',
        (WidgetTester tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // 1. Verifikasi state awal (Movies)
      expect(find.text('Ditonton - Movies'), findsOneWidget);
      expect(find.byType(HomeMoviePageContent), findsOneWidget);
      expect(find.byType(HomeTvshowPageContent), findsNothing);

      // 2. Tap ikon TV Shows
      await tester.tap(find.byIcon(Icons.tv));
      await tester.pumpAndSettle(); // Tunggu animasi selesai

      // 3. Verifikasi state TV Shows
      expect(find.text('Ditonton - TV Shows'), findsOneWidget);
      expect(find.byType(HomeMoviePageContent), findsNothing);
      expect(find.byType(HomeTvshowPageContent), findsOneWidget);

      // 4. Tap ikon Movies (kembali)
      await tester.tap(find.byIcon(Icons.movie));
      await tester.pumpAndSettle();

      // 5. Verifikasi state Movies
      expect(find.text('Ditonton - Movies'), findsOneWidget);
      expect(find.byType(HomeMoviePageContent), findsOneWidget);
      expect(find.byType(HomeTvshowPageContent), findsNothing);
    });

    testWidgets(
        'Search button navigates to correct search page based on selected tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // 1. Di tab Movies (default), tap search
      expect(find.text('Ditonton - Movies'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // 2. Verifikasi navigasi ke SearchPage (Movies)
      expect(find.text('Search'), findsOneWidget);

      // 3. Kembali ke MainPage
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Ditonton - Movies'), findsOneWidget);

      // 4. Pindah ke tab TV Shows
      await tester.tap(find.byIcon(Icons.tv));
      await tester.pumpAndSettle();
      expect(find.text('Ditonton - TV Shows'), findsOneWidget);

      // 5. Di tab TV Shows, tap search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // 6. Verifikasi navigasi ke SearchPageTvshow
      expect(find.text('Search Tv Show'), findsOneWidget);
    });

    testWidgets('Drawer navigation items navigate to correct pages',
        (WidgetTester tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Helper untuk buka drawer, tap item, dan verifikasi
      Future<void> navigateFromDrawer(
          String itemText, String expectedPageTitle) async {
        // Buka Drawer
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // Tap item
        await tester.tap(find.text(itemText));
        await tester.pumpAndSettle();

        // Verifikasi halaman tujuan
        expect(find.text(expectedPageTitle), findsOneWidget);

        // Kembali ke MainPage
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Pastikan kita kembali ke halaman utama
        expect(find.byType(MainPage), findsOneWidget);
      }

      // Tes Movie Watchlist
      await navigateFromDrawer('Movie Watchlist', 'Watchlist Movie');

      // Tes TV Show Watchlist
      await navigateFromDrawer('TV Show Watchlist', 'Watchlist Tv Show');

      // Tes About
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap item
      await tester.tap(find.text("About"));
      await tester.pumpAndSettle();

      // Verifikasi halaman tujuan
      expect(
          find.text(
              "Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert."),
          findsOneWidget);

      // Kembali ke MainPage
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Pastikan kita kembali ke halaman utama
      expect(find.byType(MainPage), findsOneWidget);
    });
  });
}
