import 'dart:convert';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/sommelier_rating.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/model/token.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class SommelierRatingRepository {
  Future<SommelierRating> post(
    Tasting tasting,
    Participant participant,
    String rate,
    String? comment,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw Exception();
    }

    Token? token = await TokenRepository().getToken();

    if (token == null) {
      throw Exception();
    }

    Uri url = Uri.https(apiUrl, 'sommelier_ratings');
    Client client = Client();

    final Map data = {
      "tasting": tasting.iri,
      "participant": participant.iri,
      "rate": rate,
      "comment": comment ?? "",
    };

    final clientResponse = await client.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token.token}",
      },
      body: json.encode(data),
    );

    final parsed = jsonDecode(clientResponse.body);

    return SommelierRating.fromJson(parsed);
  }

  Future<SommelierRating> put(
    String iri,
    String rate,
    String? comment,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw Exception();
    }

    Token? token = await TokenRepository().getToken();

    if (token == null) {
      throw Exception();
    }

    Uri url = Uri.https(apiUrl, iri);
    Client client = Client();

    print(comment);

    final Map data = {
      "rate": rate,
      "comment": comment ?? "",
    };

    final clientResponse = await client.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token.token}",
      },
      body: json.encode(data),
    );

    final parsed = jsonDecode(clientResponse.body);

    return SommelierRating.fromJson(parsed);
  }
}