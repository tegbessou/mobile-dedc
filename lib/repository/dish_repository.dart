
import 'dart:convert';
import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/model/token.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class DishRepository {
  Future<Dish> post(
    String name,
    Tasting tasting,
    Map<Participant, DishRating> ratings,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw Exception();
    }

    Token token = await TokenRepository().getToken(
      'hugues.gobet@gmail.com',
      'root'
    );

    Uri url = Uri.https(apiUrl, 'dishes');
    Client client = Client();

    final Map data = {
      "name": name,
      "tasting": tasting.iri,
      "participants": [],
      "dishRatings": [],
    };

    ratings.forEach((participant, rating) {
      Map ratingObject = {};

      ratingObject["participant"] = participant.iri;
      ratingObject["rate"] = rating.rate;
      ratingObject["comment"] = rating.comment ?? "";

      data["participants"].add(participant.iri);
      data["dishRatings"].add(ratingObject);
    });

    final clientResponse = await client.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token.token}",
      },
      body: json.encode(data),
    );

    final parsed = jsonDecode(clientResponse.body);

    return Dish.fromJson(parsed);
  }

  Future<List<Dish>> findByTasting(Tasting tasting) async {
    List<Dish> dish = [];
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      return dish;
    }

    Token token = await TokenRepository().getToken(
        'hugues.gobet@gmail.com',
        'root'
    );

    Uri url = Uri.https(apiUrl, 'dishes', {
      "tasting.id": tasting.id.toString(),
    });
    Client client = Client();

    final clientResponse = await client.get(
        url,
        headers: {
          "Authorization": "Bearer ${token.token}",
        }
    );

    final parsed = jsonDecode(clientResponse.body)["hydra:member"].cast<Map<String, dynamic>>();

    return parsed.map<Dish>((json) => Dish.fromJson(json)).toList();
  }

  Future<void> delete(
    String iri,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw Exception();
    }

    Token token = await TokenRepository().getToken(
        'hugues.gobet@gmail.com',
        'root'
    );

    Uri url = Uri.https(apiUrl, iri);
    Client client = Client();

    await client.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token.token}",
      },
    );
  }
}