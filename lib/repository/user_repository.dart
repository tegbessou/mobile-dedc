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
  ) async {
    Map data = {
      "email": username,
      "plainPassword": password,
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

  Future<void> delete() async {
    await HttpRepository()
        .delete(
      'users/${await HttpRepository().getUserId()}',
    )
        .then((value) {
      UserCacheManager.instance.emptyCache();
    });
  }
}
