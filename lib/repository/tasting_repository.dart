
import 'dart:convert';

import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/model/token.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class TastingRepository {
  Future<Tasting> post(
    String name,
    Restaurant? restaurant,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: "user_id");

    if (apiUrl == null || restaurant == null) {
      throw Exception();
    }

    Token? token = await TokenRepository().getToken();

    if (token == null) {
      throw Exception();
    }

    Uri url = Uri.https(apiUrl, 'tastings');
    Client client = Client();

    final Map data = {
      "name": name,
      "restaurant": restaurant.iri,
      "user": "/users/$userId",
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

    return Tasting.fromJson(parsed);
  }

  Future<List<Tasting>> findByName(String name) async {
    List<Tasting> tastings = [];
    String? apiUrl = dotenv.env['API_URL'];

    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: "user_id");

    if (apiUrl == null) {
      return tastings;
    }

    Token? token = await TokenRepository().getToken();

    if (token == null) {
      throw Exception();
    }

    Uri url = Uri.https(apiUrl, 'tastings', {
      "name": name,
      "user.id": userId,
    });
    Client client = Client();

    final clientResponse = await client.get(
        url,
        headers: {
          "Authorization": "Bearer ${token.token}",
        }
    );

    final parsed = jsonDecode(clientResponse.body)["hydra:member"].cast<Map<String, dynamic>>();

    return parsed.map<Tasting>((json) => Tasting.fromJson(json)).toList();
  }

  Future<Tasting> addParticipants(
    Tasting? tasting,
    List<Participant> participants,
  ) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null || tasting == null) {
      throw Exception();
    }

    Token? token = await TokenRepository().getToken();

    if (token == null) {
      throw Exception();
    }

    Uri url = Uri.https(apiUrl, 'tastings/${tasting.id}');
    Client client = Client();

    final Map data = {
      "participants": [],
    };

    participants.forEach((Participant participant) {
      data["participants"].add(participant.iri);
    });

    final clientResponse = await client.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token.token}",
        },
        body: json.encode(data),
    );

    final parsed = jsonDecode(clientResponse.body);

    return Tasting.fromJson(parsed);
  }

  Future<Tasting> find(int? id) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw Exception();
    }

    Token? token = await TokenRepository().getToken();

    if (token == null) {
      throw Exception();
    }

    Uri url = Uri.https(apiUrl, 'tastings/$id');
    Client client = Client();

    final clientResponse = await client.get(
        url,
        headers: {
          "Authorization": "Bearer ${token.token}",
        }
    );

    final parsed = jsonDecode(clientResponse.body);

    return Tasting.fromJson(parsed);
  }

  Future<void> closed(String iri) async {
    String? apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      throw Exception();
    }

    Token? token = await TokenRepository().getToken();

    if (token == null) {
      throw Exception();
    }

    Uri url = Uri.https(apiUrl, iri);
    Client client = Client();

    final Map data = {
      "closed": true,
    };

    await client.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token.token}",
      },
      body: json.encode(data),
    );
  }
}