import 'dart:convert';

import 'package:degust_et_des_couleurs/cache-manager/user_cache_manager.dart';
import 'package:degust_et_des_couleurs/exception/friend_request_already_friend.dart';
import 'package:degust_et_des_couleurs/model/friend_request.dart';
import 'package:degust_et_des_couleurs/model/user.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:http/http.dart';

class FriendRequestRepository {
  Future<List<FriendRequest>> getAllForCurrentUser() async {
    final Response response =
        await HttpRepository().getWithOutCache('friend_requests');

    final parsed =
        jsonDecode(response.body)["hydra:member"].cast<Map<String, dynamic>>();

    return parsed
        .map<FriendRequest>((json) => FriendRequest.fromJson(json))
        .toList();
  }

  Future<void> post(
    User target,
  ) async {
    String iri = '/users/${await HttpRepository().getUserId()}';

    Map data = {
      "target": target.iri,
      "source": iri,
    };

    Response response = await HttpRepository().post(
      'friend_requests',
      data,
    );

    if (response.statusCode == 422 || response.statusCode == 400) {
      throw FriendRequestAlreadyFriend();
    }

    return;
  }

  Future<void> decline(
    FriendRequest friendRequest,
  ) async {
    await HttpRepository().delete(
      'friend_requests/${friendRequest.id}/decline',
    );
  }

  Future<void> accept(
    FriendRequest friendRequest,
  ) async {
    await HttpRepository().post(
      '/friend_requests/${friendRequest.id}/accept',
      {},
    ).then((value) {
      UserCacheManager.instance.emptyCache();
    });
  }
}
