import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:degust_et_des_couleurs/exception/missing_api_url_exception.dart';
import 'package:degust_et_des_couleurs/exception/unauthenticated_user_exception.dart';
import 'package:degust_et_des_couleurs/model/token.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class HttpRepository {
  Future<Response> post(
    String uri,
    Map data, {
    bool withoutAuthentication = false,
  }) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw MissingApiUrlException();
    }

    Uri url = Uri.https(apiUrl, uri);
    Client client = Client();

    Map<String, String> headers = {};

    if (headers.isEmpty) {
      headers["Content-Type"] = "application/json";
    }

    if (!withoutAuthentication) {
      headers["Authorization"] = "Bearer ${await getToken()}";
    }

    return client.post(
      url,
      headers: headers,
      body: json.encode(data),
    );
  }

  Future<Response> postMultiPart(
    String uri,
    Map data, {
    bool withoutAuthentication = false,
  }) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw MissingApiUrlException();
    }

    Uri url = Uri.https(apiUrl, uri);
    MultipartRequest multipartRequest = MultipartRequest("POST", url);

    multipartRequest.headers
        .addAll({"Authorization": "Bearer ${await getToken()}"});

    multipartRequest.fields["json"] = json.encode(data);

    return Response.fromStream(await multipartRequest.send());
  }

  Future<Response> put(
    String uri,
    Map data,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw MissingApiUrlException();
    }

    Uri url = Uri.https(apiUrl, uri);
    Client client = Client();

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await getToken()}",
    };

    return client.put(
      url,
      headers: headers,
      body: json.encode(data),
    );
  }

  Future<Response> get(
    String uri,
    CacheManager cacheManager,
    String cacheKey, {
    Map<String, dynamic> queryParam = const {},
  }) async {
    String? apiUrl = dotenv.env['API_URL'];

    final cachedData = await cacheManager.getFileFromMemory(cacheKey);

    if (cachedData != null) {
      return Response(cachedData.file.readAsStringSync(), 200,
          headers: {
        HttpHeaders.contentTypeHeader: 'application/ld+json; charset=utf-8',
      });
    }

    if (apiUrl == null) {
      throw MissingApiUrlException();
    }

    Uri url = Uri.https(apiUrl, uri, queryParam);
    Client client = Client();

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await getToken()}",
    };

    return client
        .get(
      url,
      headers: headers,
    )
        .then((value) {
      Uint8List fileBytes = Uint8List.fromList(value.bodyBytes);
      cacheManager.putFile(cacheKey, fileBytes);

      return value;
    });
  }

  Future<Response> delete(String uri) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw MissingApiUrlException();
    }

    Uri url = Uri.https(apiUrl, uri);
    Client client = Client();

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await getToken()}",
    };

    return client.delete(
      url,
      headers: headers,
    );
  }

  Future<String> getUserId() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: "user_id");

    if (userId == null) {
      throw UnauthenticatedUserException();
    }

    return userId;
  }

  Future<String> getToken() async {
    Token? token = await TokenRepository().getToken();

    if (token == null) {
      throw UnauthenticatedUserException();
    }

    final String? tokenAsString = token.token;

    if (tokenAsString == null) {
      throw UnauthenticatedUserException();
    }

    return tokenAsString;
  }
}
