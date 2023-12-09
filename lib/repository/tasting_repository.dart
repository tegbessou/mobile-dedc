import 'dart:convert';
import 'package:degust_et_des_couleurs/cache-manager/tasting_cache_manager.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:http/http.dart';

class TastingRepository {
  Future<Tasting> post(
    String name,
    Restaurant restaurant,
  ) async {
    final Map data = {
      "name": name,
      "restaurant": restaurant.iri,
      "user": "/users/${await HttpRepository().getUserId()}",
    };

    Response response = await HttpRepository().post(
      "tastings",
      data,
    ).then((value) {
      TastingCacheManager.instance.emptyCache();

      return value;
    });

    return Tasting.fromJson(json.decode(response.body));
  }

  Future<List<Tasting>> findByName(String name) async {
    final Map<String, dynamic> queryParam = {
      "user.id": await HttpRepository().getUserId(),
      "groups[]": "read_light_tasting",
    };

    if (name != "") {
      queryParam["name"] = name;
    }

    Response response = await HttpRepository().get("tastings",
        TastingCacheManager.instance, "get_tastings_${queryParam.toString()}",
        queryParam: queryParam);

    final parsed =
        jsonDecode(response.body)["hydra:member"].cast<Map<String, dynamic>>();

    return parsed.map<Tasting>((json) => Tasting.fromJson(json)).toList();
  }

  Future<Tasting> addParticipants(
    Tasting tasting,
    List<Participant> participants,
  ) async {
    final Map data = {
      "participants": [],
    };

    for (var participant in participants) {
      data["participants"].add(participant.iri);
    }

    Response response = await HttpRepository().put(tasting.iri, data);

    return Tasting.fromJson(json.decode(response.body));
  }

  Future<Tasting> find(int id) async {
    Response response = await HttpRepository()
        .get('tastings/$id', TastingCacheManager.instance, "get_tasting_$id}");

    final parsed = jsonDecode(response.body);

    return Tasting.fromJson(parsed);
  }

  Future<void> closed(String iri) async {
    final Map data = {
      "closed": true,
    };

    await HttpRepository().put(iri, data).then((value) {
      TastingCacheManager.instance.emptyCache();

      return value;
    });
  }
}
