import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart';

class CrashlyticsHelper {
  static bool isTesting = false;
  static Future<void> recordApiError(String url, Response response) async {
    if (isTesting || Platform.environment.containsKey('FLUTTER_TEST')) return;
    await FirebaseCrashlytics.instance.recordError(
      'Unexpected status code: ${response.statusCode}',
      StackTrace.current,
      reason: 'Failed to fetch data',
      information: [
        'URL: $url',
        'Response body: ${response.body}',
      ],
      fatal: false,
    );
  }
}
