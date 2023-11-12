import 'dart:convert';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/sommelier_rating.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:http/http.dart';

class SommelierRatingRepository {
  Future<SommelierRating> post(
    Tasting tasting,
    Participant participant,
    String rate,
    String? comment,
  ) async {
    final Map data = {
      "tasting": tasting.iri,
      "participant": participant.iri,
      "rate": rate,
      "comment": comment ?? "",
    };

    final Response response = await HttpRepository().post(
      'sommelier_ratings',
      data,
    );

    final parsed = jsonDecode(response.body);

    return SommelierRating.fromJson(parsed);
  }

  Future<SommelierRating> put(
    String iri,
    String rate,
    String? comment,
  ) async {
    final Map data = {
      "rate": rate,
      "comment": comment ?? "",
    };

    final Response response = await HttpRepository().put(
      iri,
      data,
    );

    final parsed = jsonDecode(response.body);

    return SommelierRating.fromJson(parsed);
  }
}
