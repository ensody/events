import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../utils.dart';
import 'base.dart';

Map<String, dynamic> decodeJson(String raw) =>
    json.decode(raw) as Map<String, dynamic>;

Uint8List encodeJson(Object object) =>
    Uint8List.fromList(json.encode(object).codeUnits);

Map<String, dynamic> decodeJsonResponse(http.Response response) =>
    decodeJson(response.body);

class JsonApi extends BaseApi {
  JsonApi({String baseUrl = '', http.Client client})
      : super(baseUrl: baseUrl, client: client);

  Map<String, String> get headers =>
      mergedMaps(super.headers, {'Content-Type': 'application/json'});

  Future<Map<String, dynamic>> getJson(String url,
          {Object data,
          Map<String, List<String>> query,
          Map<String, String> headers,
          bool idempotent = true}) async =>
      decodeJsonResponse(await get(url,
          query: query,
          headers: headers,
          body: data != null ? encodeJson(data) : null,
          idempotent: idempotent));

  Future<Map<String, dynamic>> postJson(String url, Object data,
          {Map<String, List<String>> query,
          Map<String, String> headers,
          bool idempotent = false}) async =>
      decodeJsonResponse(await post(url,
          query: query,
          headers: headers,
          body: data != null ? encodeJson(data) : null,
          idempotent: idempotent));

  Future<Map<String, dynamic>> putJson(String url, Object data,
          {Map<String, List<String>> query,
          Map<String, String> headers,
          bool idempotent = true}) async =>
      decodeJsonResponse(await put(url,
          query: query,
          headers: headers,
          body: data != null ? encodeJson(data) : null,
          idempotent: idempotent));

  Future<Map<String, dynamic>> deleteJson(String url,
          {Map<String, List<String>> query,
          Map<String, String> headers,
          bool idempotent = true}) async =>
      decodeJsonResponse(await delete(url,
          query: query, headers: headers, idempotent: idempotent));
}
