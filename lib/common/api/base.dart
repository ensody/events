import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../utils.dart';

class ApiException implements Exception {
  const ApiException(this.message, this.response, {this.exception});

  final String message;
  final http.Response response;
  final Exception exception;

  @override
  String toString() {
    return 'ApiException (Status: ${response.statusCode}): $message: $message\n-------\n${response.body}\n';
  }
}

enum HttpMethod { GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE }

class BaseApi {
  BaseApi({this.baseUrl = '', http.Client client})
      : client = client ?? http.Client();

  final http.Client client;
  final String baseUrl;
  final timeout = Duration(seconds: 10);

  http.Response handleResponse(http.Response response) => response;

  final Map<String, String> headers = const {};
  final Map<String, List<String>> queryParameters = const {};

  Uri getUrl(String url, {Map<String, List<String>> query}) {
    final uri = Uri.parse(baseUrl + url);
    final params = Map.of(queryParameters);
    params.addAll(uri.queryParametersAll);
    if (query != null) {
      params.addAll(query);
    }
    return uri.replace(queryParameters: params);
  }

  Future<http.Response> _send(http.Request request) async =>
      await http.Response.fromStream(await client.send(request));

  Future<http.Response> send(HttpMethod method, String url,
      {Map<String, List<String>> query,
      Map<String, String> headers,
      Uint8List body,
      bool idempotent = false}) async {
    final methodName = method.toString().split('.')[1].toUpperCase();
    final fullUrl = getUrl(url, query: query);
    final requestHeaders = mergedMaps(this.headers, headers);
    while (true) {
      try {
        final request = http.Request(methodName, fullUrl)
          ..headers.addAll(requestHeaders);
        return handleResponse(await _send(request).timeout(timeout));
      } on http.ClientException {
        if (!idempotent) {
          rethrow;
        }
      } on SocketException {
        if (!idempotent) {
          rethrow;
        }
      } on TimeoutException catch (e) {
        if (!idempotent) {
          throw ApiException('Timeout', null, exception: e);
        }
      } on ApiException catch (e) {
        if (!idempotent || e.response.statusCode < 500) {
          rethrow;
        }
      }
      // TODO: exponential backoff, detection of connection state and use sensible timeouts
      await delay(Duration(seconds: 1));
    }
  }

  Future<http.Response> get(String url,
      {Map<String, List<String>> query,
      Map<String, String> headers,
      Uint8List body,
      bool idempotent = true}) async {
    return await send(HttpMethod.GET, url,
        query: query, headers: headers, body: body, idempotent: idempotent);
  }

  Future<http.Response> post(String url,
      {Map<String, List<String>> query,
      Map<String, String> headers,
      Uint8List body,
      bool idempotent = false}) async {
    return await send(HttpMethod.POST, url,
        query: query, headers: headers, body: body, idempotent: idempotent);
  }

  Future<http.Response> put(String url,
      {Map<String, List<String>> query,
      Map<String, String> headers,
      Uint8List body,
      bool idempotent = true}) async {
    return await send(HttpMethod.PUT, url,
        query: query, headers: headers, body: body, idempotent: idempotent);
  }

  Future<http.Response> delete(String url,
      {Map<String, List<String>> query,
      Map<String, String> headers,
      bool idempotent = true}) async {
    return await send(HttpMethod.DELETE, url,
        query: query, headers: headers, idempotent: idempotent);
  }
}
