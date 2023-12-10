import 'dart:convert';
import 'package:degust_et_des_couleurs/cache-manager/participant_cache_manager.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:http/http.dart';

class ParticipantRepository {
  Future<Participant> post(
    String name,
  ) async {
    final Map data = {
      "name": name,
      "user": "/users/${await HttpRepository().getUserId()}",
    };

    final Response response = await HttpRepository()
        .post(
      'participants',
      data,
    )
        .then((value) {
      ParticipantCacheManager.instance.emptyCache();

      return value;
    });

    final parsed = jsonDecode(response.body);

    return Participant.fromJson(parsed);
  }

  Future<List<Participant>> findByName(String name) async {
    final queryParam = {
      "name": name,
      "user.id": await HttpRepository().getUserId(),
    };

    final Response response = await HttpRepository().get(
        'participants',
        ParticipantCacheManager.instance,
        "get_participants_${queryParam.toString()}",
        queryParam: queryParam);

    final parsed =
        jsonDecode(response.body)["hydra:member"].cast<Map<String, dynamic>>();

    return parsed
        .map<Participant>((json) => Participant.fromJson(json))
        .toList();
  }
}
