
import 'dart:convert';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/token.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class ParticipantRepository {
  Future<Participant> post(
    String name,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw Exception();
    }

    Token token = await TokenRepository().getToken(
      'hugues.gobet@gmail.com',
      'root'
    );

    Uri url = Uri.https(apiUrl, 'participants');
    Client client = Client();

    final Map data = {
      "name": name,
      "user": "/users/1",
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

    return Participant.fromJson(parsed);
  }

  Future<List<Participant>> findByName(String name) async {
    List<Participant> participants = [];
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      return participants;
    }

    Token token = await TokenRepository().getToken(
        'hugues.gobet@gmail.com',
        'root'
    );

    Uri url = Uri.https(apiUrl, 'participants', {
      "name": name,
      "user": "/users/1",
    });
    Client client = Client();

    final clientResponse = await client.get(
        url,
        headers: {
          "Authorization": "Bearer ${token.token}",
        }
    );

    final parsed = jsonDecode(clientResponse.body)["hydra:member"].cast<Map<String, dynamic>>();

    return parsed.map<Participant>((json) => Participant.fromJson(json)).toList();
  }
}