import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Api {
  var log = Logger();
  static Uri _url(String url) {
    return Uri.parse(url);
  }

  static Future<http.Response> getRequest(String uri) async {
    final response = await http.get(
      _url(uri),
      headers: {"Content-type": "application/json"},
    ).timeout(const Duration(seconds: 60));

    return response;
  }

  static Future<http.Response> postRequest(String uri, Object? body) async {
    final response = await http
        .post(
          _url(uri),
          headers: {
            'Content-type': 'application/json',
          },
          body: json.encode(body),
        )
        .timeout(const Duration(seconds: 60));

    return response;
  }

  static Future<http.Response> deleteRequest(String uri,
      {String? token}) async {
    final response = await http.delete(_url(uri), headers: {
      'Content-type': 'application/json'
    }).timeout(const Duration(seconds: 60));
    return response;
  }
}

class ResponseApi {
  final bool status;
  final String message;
  dynamic data;

  ResponseApi({
    required this.status,
    required this.message,
    this.data,
  });
}
