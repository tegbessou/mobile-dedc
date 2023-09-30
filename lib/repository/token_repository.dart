
import 'dart:convert';

import 'package:degust_et_des_couleurs/model/token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenRepository {
  Future<Token> getToken(
    String username,
    String password,
  ) async {
    const storage = FlutterSecureStorage();

    String? value = await storage.read(key: username);

    if (value == null) {
      Token token = await createToken(
        username,
        password,
      );

      await storage.write(key: username, value: token.token);

      return token;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(value);

    DateTime expiredAt = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
    DateTime now  = DateTime.now();

    if (now.compareTo(expiredAt) > 0) {
      Token token = await createToken(
        username,
        password,
      );

      await storage.write(key: username, value: token.token);

      return token;
    }

    return Token(
      token: value,
    );
  }

  Future<Token> createToken(
    String username,
    String password,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      return Token(
        token: '',
      );
    }

    Uri url = Uri.https(apiUrl, 'auth');
    Client client = Client();

    Map data = {
      "email": username,
      "password": password,
    };

    final clientResponse = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    final parsed = jsonDecode(clientResponse.body);

    return Token.fromJson(parsed);
  }
}