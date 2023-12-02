import 'dart:async';
import 'package:degust_et_des_couleurs/controller/register_controller.dart';
import 'package:degust_et_des_couleurs/core/auth.dart';
import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
import 'package:degust_et_des_couleurs/model/user.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:degust_et_des_couleurs/repository/user_repository.dart';
import 'package:degust_et_des_couleurs/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginControllerState();
  }
}

class LoginControllerState extends State<LoginController> {
  String errorMessage = '';
  bool isLogin = true;

  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LoginView(
        signWithCustomToken: signWithCustomToken,
        redirectToRegister: redirectToRegister);
  }

  Future<void> signWithCustomToken(
      TextEditingValue email, TextEditingValue password) async {
    try {
      await TokenRepository()
          .createToken(email.text, password.text)
          .then((value) async {
        String? token = value.token;

        if (token == null) {
          throw BadCredentialException();
        }

        await Auth().signInWitCustomToken(token: token).then((value) async {
          await UserRepository()
              .getByUsername(email.text)
              .then((User value) async {
            const storage = FlutterSecureStorage();

            await storage.write(key: "user_id", value: value.id.toString());
          });
        }).catchError((error) {
          setState(() {
            errorMessage = error.message;
          });
        });
      });
    } catch (exception) {
      rethrow;
    }
  }

  void redirectToRegister() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
      return const RegisterController();
    });

    Navigator.of(context).push(materialPageRoute);
  }
}
