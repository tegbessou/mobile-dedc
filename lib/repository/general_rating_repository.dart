import 'dart:convert';
import 'package:degust_et_des_couleurs/model/general_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/model/token.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class GeneralRatingRepository {
  Future<GeneralRating> post(
    Tasting tasting,
    Participant participant,
    String rate,
    String? comment,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw Exception();
    }

    Token token = await TokenRepository().getToken(
      'hugues.gobet@gmail.com',
      'root'
    );

    Uri url = Uri.https(apiUrl, 'general_ratings');
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

    return GeneralRating.fromJson(parsed);
  }

  Future<GeneralRating> put(
    String iri,
    String rate,
    String? comment,
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

    return GeneralRating.fromJson(parsed);
  }
}