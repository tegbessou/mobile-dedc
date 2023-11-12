import 'dart:convert';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/service_rating.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:http/http.dart';

class ServiceRatingRepository {
  Future<ServiceRating> post(
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
      'service_ratings',
      data,
    );

    final parsed = jsonDecode(response.body);

    return ServiceRating.fromJson(parsed);
  }

  Future<ServiceRating> put(
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

    return ServiceRating.fromJson(parsed);
  }
}
