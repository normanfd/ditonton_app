import 'package:ditonton/main.dart' as app;
import 'package:ditonton/presentation/pages/tvshow/tvshow_detail_page.dart';
import 'package:ditonton/presentation/widgets/tvshow_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/injection.dart' as di;

void main(){
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

          // masuk tab tv show
          await tester.tap(find.byIcon(Icons.tv));
          await tester.pumpAndSettle();

          // tekan icon search
          await tester.tap(find.byIcon(Icons.search));
          await tester.pumpAndSettle();

          // input judul film
          final textFieldFinder = find.byType(TextField);
          expect(textFieldFinder, findsOneWidget);
          await tester.enterText(textFieldFinder, 'one');
          await tester.pump();

          // tekan enter
          await tester.testTextInput.receiveAction(TextInputAction.search);
          await tester.pumpAndSettle();

          // muncul list hasil pencarian
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