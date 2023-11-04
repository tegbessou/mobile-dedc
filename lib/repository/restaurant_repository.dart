
import 'dart:convert';

import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/model/token.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class RestaurantRepository {
  Future<List<Restaurant>> findByName(String name) async {
    List<Restaurant> restaurants = [];
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      return restaurants;
    }

    Token? token = await TokenRepository().getToken();

    if (token == null) {
      throw Exception();
    }

    Uri url = Uri.https(apiUrl, 'restaurants', {
      "name": name,
    });
    Client client = Client();

    final clientResponse = await client.get(
      url,
      headers: {
        "Authorization": "Bearer ${token.token}",
      }
    );

    final parsed = jsonDecode(clientResponse.body)["hydra:member"].cast<Map<String, dynamic>>();

    return parsed.map<Restaurant>((json) => Restaurant.fromJson(json)).toList();
  }
}