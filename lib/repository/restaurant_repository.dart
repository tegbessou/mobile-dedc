import 'dart:convert';
import 'package:degust_et_des_couleurs/cache-manager/restaurant_cache_manager.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:http/http.dart';

class RestaurantRepository {
  Future<List<Restaurant>> findByName(String name) async {
    final queryParam = {
      "name": name,
    };

    final Response response = await HttpRepository().get(
        'restaurants',
        RestaurantCacheManager.instance,
        "get_restaurants_${queryParam.toString()}",
        queryParam: queryParam);

    final parsed =
        jsonDecode(response.body)["hydra:member"].cast<Map<String, dynamic>>();

    return parsed.map<Restaurant>((json) => Restaurant.fromJson(json)).toList();
  }
}
