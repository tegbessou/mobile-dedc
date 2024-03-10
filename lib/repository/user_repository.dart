import 'dart:convert';
import 'package:degust_et_des_couleurs/cache-manager/user_cache_manager.dart';
import 'package:degust_et_des_couleurs/exception/username_already_used_exception.dart';
import 'package:degust_et_des_couleurs/model/user.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:http/http.dart';

class UserRepository {
  Future<User> post(
    String username,
    String password,
    String firstName,
  ) async {
    Map data = {
      "email": username,
      "plainPassword": password,
      "firstName": firstName,
    };

    Response response = await HttpRepository().post(
      'users',
      data,
      withoutAuthentication: true,
    );

    final parsed = jsonDecode(response.body);

    if (response.statusCode == 422) {
      throw UsernameAlreadyUsedException();
    }

    return User.fromJson(parsed);
  }

  Future<User> getByUsername(
    String username,
  ) async {
    final queryParam = {
      "email": username,
    };

    final Response response = await HttpRepository().get('users',
        UserCacheManager.instance, "get_users_${queryParam.toString()}",
        queryParam: queryParam);

    final parsed =
        jsonDecode(response.body)["hydra:member"].cast<Map<String, dynamic>>();

    final users = parsed.map<User>((json) => User.fromJson(json)).toList();

    return users[0];
  }

  Future<User> find(
    int id, {
    bool noCache = false,
  }) async {
    Response response = noCache
        ? await HttpRepository().getWithOutCache('users/$id')
        : await HttpRepository()
            .get('users/$id', UserCacheManager.instance, "get_user_$id}");

    final parsed = jsonDecode(response.body);

    return User.fromJson(parsed);
  }

  Future<void> delete() async {
    await HttpRepository()
        .delete(
      'users/${await HttpRepository().getUserId()}',
    )
        .then((value) {
      UserCacheManager.instance.emptyCache();
    });
  }

  Future<List<User>> findByPseudo(String pseudo) async {
    final Map<String, dynamic> queryParam = {
      "pseudo": pseudo,
    };

    Response response = await HttpRepository().get(
        "users",
        UserCacheManager.instance,
        "get_users_by_pseudo_${queryParam.toString()}",
        queryParam: queryParam);

    final parsed =
        jsonDecode(response.body)["hydra:member"].cast<Map<String, dynamic>>();

    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<void> removeFriend(
    User user,
  ) async {
    final Map data = {
      "user": '/users/${await HttpRepository().getUserId()}',
      "friend": user.iri,
    };

    await HttpRepository().post(
      '/remove_friends',
      data,
    );

    UserCacheManager.instance.emptyCache();
  }
}
