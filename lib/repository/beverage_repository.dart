import 'dart:convert';
import 'package:degust_et_des_couleurs/cache-manager/beverage_cache_manager.dart';
import 'package:degust_et_des_couleurs/model/beverage.dart';
import 'package:degust_et_des_couleurs/model/beverage_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:http/http.dart';

class BeverageRepository {
  Future<Beverage> post(
    String name,
    Tasting tasting,
    Map<Participant, BeverageRating> ratings,
  ) async {
    final Map data = {
      "name": name,
      "tasting": tasting.iri,
      "participants": [],
      "beverageRatings": [],
    };

    ratings.forEach((participant, rating) {
      Map ratingObject = {};

      ratingObject["participant"] = participant.iri;
      ratingObject["rate"] = rating.rate;
      ratingObject["comment"] = rating.comment ?? "";

      data["participants"].add(participant.iri);
      data["beverageRatings"].add(ratingObject);
    });

    final Response response = await HttpRepository().postMultiPart(
      'beverages',
      data,
    ).then((value) {
      BeverageCacheManager.instance.emptyCache();

      return value;
    });

    final parsed = jsonDecode(response.body);

    return Beverage.fromJson(parsed);
  }

  Future<List<Beverage>> findByTasting(Tasting tasting) async {
    final queryParam = {
      "tasting.id": tasting.id.toString(),
    };

    final clientResponse = await HttpRepository().get('beverages',
        BeverageCacheManager.instance, "get_beverages_${queryParam.toString()}",
        queryParam: queryParam);

    final parsed = jsonDecode(clientResponse.body)["hydra:member"]
        .cast<Map<String, dynamic>>();

    return parsed.map<Beverage>((json) => Beverage.fromJson(json)).toList();
  }

  Future<void> delete(String iri) async {
    await HttpRepository().delete(
      iri,
    ).then((value) {
      BeverageCacheManager.instance.emptyCache();
    });
  }

  Future<Beverage> put(
    String iri,
    Beverage beverage,
  ) async {
    final Response response = await HttpRepository().put(
      iri,
      beverage.toMap(),
    ).then((value) {
      BeverageCacheManager.instance.emptyCache();

      return value;
    });

    final parsed = jsonDecode(response.body);

    return Beverage.fromJson(parsed);
  }
}
