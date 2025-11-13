import 'dart:io';
import 'package:http/io_client.dart';
import 'ssl_util.dart';

class HttpSslClient {
  static Future<IOClient> create() async {
    final context = await SslUtil.globalContext;
    final httpClient = HttpClient(context: context)
      ..badCertificateCallback = (cert, host, port) => false;
    return IOClient(httpClient);
  }

}

