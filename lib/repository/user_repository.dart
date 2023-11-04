
import 'dart:convert';

import 'package:degust_et_des_couleurs/exception/username_already_used_exception.dart';
import 'package:degust_et_des_couleurs/model/token.dart';
import 'package:degust_et_des_couleurs/model/user.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserRepository {
  Future<User> post(
    String username,
    String password,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      return User(
        iri: '',
        id: 0,
        username: '',
      );
    }

    Uri url = Uri.https(apiUrl, 'users');
    Client client = Client();

    Map data = {
      "email": username,
      "plainPassword": password,
    };

    final clientResponse = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    final parsed = jsonDecode(clientResponse.body);

    if (clientResponse.statusCode == 422) {
      throw UsernameAlreadyUsedException();
    }

    return User.fromJson(parsed);
  }

  Future<User> getByUsername(
    String username,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      return User(
        iri: '',
        id: 0,
        username: '',
      );
    }

    Token? token = await TokenRepository().getToken();

    if (token == null) {
      throw Exception();
    }

    Uri url = Uri.https(apiUrl, 'users', {
      "email": username,
    });
    Client client = Client();

    final clientResponse = await client.get(
      url,
      headers: {
        "Authorization": "Bearer ${token.token}",
      }
    );

    final parsed = jsonDecode(clientResponse.body)["hydra:member"].cast<Map<String, dynamic>>();

    final users = parsed.map<User>((json) => User.fromJson(json)).toList();

    return users[0];
  }
}