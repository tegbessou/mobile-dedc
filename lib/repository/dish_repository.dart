import 'dart:convert';
import 'package:degust_et_des_couleurs/cache-manager/dish_cache_manager.dart';
import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';

class DishRepository {
  Future<Dish> post(
    String name,
    Tasting tasting,
    Map<Participant, DishRating> ratings,
  ) async {
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

    final response = await HttpRepository().postMultiPart(
      'dishes',
      data,
    ).then((value) {
      DishCacheManager.instance.emptyCache();

      return value;
    });

    final parsed = jsonDecode(response.body);

    return Dish.fromJson(parsed);
  }

  Future<List<Dish>> findByTasting(Tasting tasting) async {
    final queryParam = {
      "tasting.id": tasting.id.toString(),
    };

    final clientResponse = await HttpRepository().get('dishes',
        DishCacheManager.instance, "get_beverages_${queryParam.toString()}",
        queryParam: queryParam);

    final parsed = jsonDecode(clientResponse.body)["hydra:member"]
        .cast<Map<String, dynamic>>();

    return parsed.map<Dish>((json) => Dish.fromJson(json)).toList();
  }

  Future<void> delete(
    String iri,
  ) async {
    await HttpRepository().delete(
      iri,
    ).then((value) {
      DishCacheManager.instance.emptyCache();
    });
  }

  Future<Dish> put(
    String iri,
    Dish dish,
  ) async {
    final response = await HttpRepository().put(
      iri,
      dish.toMap(),
    ).then((value) {
      DishCacheManager.instance.emptyCache();

      return value;
    });

    final parsed = jsonDecode(response.body);

    return Dish.fromJson(parsed);
  }
}
