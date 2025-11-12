import 'package:ditonton/domain/entities/Tvshow.dart';
import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

// 1. Konstanta yang diperlukan
const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';
const TextStyle kHeading6 =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

// 3. Halaman Detail (Tiruan untuk nama rute)
class MovieDetailPage {
  static const ROUTE_NAME = '/detail-tvshow';
}

void main() {
  Widget createTestableWidget(
      {required Widget child, required Map<String, WidgetBuilder> routes}) {
    return MaterialApp(
      home: Scaffold(body: child),
      routes: routes,
    );
  }

  // Halaman tiruan untuk tujuan navigasi
  final Widget dummyDetailPage = Container(key: Key('detail_page'));

  group('Tes Widget TvShowCard', () {
    testWidgets('Menampilkan title dan overview dengan benar',
        (WidgetTester tester) async {
      // 2. ACT: Render widget
      await tester.pumpWidget(createTestableWidget(
        child: TvshowCard(testTvshow),
        routes: {MovieDetailPage.ROUTE_NAME: (context) => dummyDetailPage},
      ));

      // 3. VERIFY: Periksa apakah teks ada di layar
      expect(find.text('Dirty Linen'), findsOneWidget);
      expect(
          find.text(
              'To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.'),
          findsOneWidget);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Menampilkan fallback text (-) jika title dan overview null',
        (WidgetTester tester) async {
      Tvshow data = testTvshow;
      data.name = null;
      data.overview = null;

      // 2. ACT: Render widget
      await tester.pumpWidget(createTestableWidget(
        child: TvshowCard(data),
        routes: {MovieDetailPage.ROUTE_NAME: (context) => dummyDetailPage},
      ));

      // 3. VERIFY: Periksa apakah fallback text '-' muncul 2x
      expect(find.text(''), findsNWidgets(2));

      // Verifikasi bahwa errorWidget (Icon) muncul
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Memicu navigasi ke halaman detail saat di-tap',
        (WidgetTester tester) async {
      // 1. SETUP: Buat data movie dengan ID spesifik

      // Variabel untuk menangkap ID yang dikirim sebagai argumen
      int? navigatedMovieId;

      await tester.pumpWidget(createTestableWidget(
        child: TvshowCard(testTvshow),
        routes: {
          MovieDetailPage.ROUTE_NAME: (context) {
            // Saat rute ini di-push, tangkap argumennya
            navigatedMovieId =
                ModalRoute.of(context)!.settings.arguments as int;
            return dummyDetailPage;
          },
        },
      ));

      // Cek (sanity check): Halaman detail belum ada
      expect(find.byKey(Key('detail_page')), findsNothing);

      // 2. ACT: Tap widget InkWell
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('detail_page')), findsOneWidget);
      expect(find.byType(TvshowCard), findsNothing);
      expect(navigatedMovieId, 202250);
    });
  });
}
