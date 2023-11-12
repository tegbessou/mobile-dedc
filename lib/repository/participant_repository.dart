import 'dart:convert';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:http/http.dart';

class ParticipantRepository {
  Future<Participant> post(
    String name,
  ) async {
    final Map data = {
      "name": name,
      "user.id": await HttpRepository().getUserId(),
    };

    final Response response = await HttpRepository().post(
      'participants',
      data,
    );

    final parsed = jsonDecode(response.body);

    return Participant.fromJson(parsed);
  }

  Future<List<Participant>> findByName(String name) async {
    final Response response =
        await HttpRepository().get('participants', queryParam: {
      "name": name,
      "user.id": await HttpRepository().getUserId(),
    });

    final parsed = jsonDecode(response.body)["hydra:member"]
        .cast<Map<String, dynamic>>();

    return parsed
        .map<Participant>((json) => Participant.fromJson(json))
        .toList();
  }
}
