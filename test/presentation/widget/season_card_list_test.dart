import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/presentation/pages/tvshow/season_detail_tvshow_page.dart';
import 'package:ditonton/presentation/widgets/season_episode_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

// 1. Konstanta yang diperlukan
const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';
const TextStyle kHeading6 =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

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

  group('Tes Widget TvSeasonDetail', () {
    testWidgets('Menampilkan title dan overview dengan benar',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        child: SeasonEpisodeCardList(testSeasonDetail.episodes.first),
        routes: {
          SeasonDetailTvshowPage.ROUTE_NAME: (context) => dummyDetailPage
        },
      ));

      expect(find.text('1. name'), findsOneWidget);
      expect(find.text('overview'), findsOneWidget);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Menampilkan fallback text (-) jika title dan overview null',
        (WidgetTester tester) async {
      SeasonDetail data = testSeasonDetail;
      SeasonEpisode se = data.episodes.first;
      se.name = null;
      se.overview = null;

      data.episodes = [se];

      await tester.pumpWidget(createTestableWidget(
        child: SeasonEpisodeCardList(data.episodes.first),
        routes: {SeasonDetailTvshowPage.ROUTE_NAME: (context) => dummyDetailPage},
      ));

      expect(find.text('1. '), findsNWidgets(1));
      expect(find.text(''), findsNWidgets(1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
