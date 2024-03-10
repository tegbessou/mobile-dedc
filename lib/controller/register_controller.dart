import 'dart:async';

import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/repository/user_repository.dart';
import 'package:degust_et_des_couleurs/view/register/register_view.dart';
import 'package:flutter/material.dart';

class RegisterController extends StatefulWidget {
  const RegisterController({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterControllerState();
  }
}

class RegisterControllerState extends State<RegisterController> {
  String errorMessage = '';

  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RegisterView(register: register, redirectToLogin: redirectToLogin);
  }

  Future<void> register(TextEditingValue email, TextEditingValue password,
      TextEditingValue firstName) async {
    try {
      await UserRepository()
          .post(email.text, password.text, firstName.text)
          .then((value) {
        redirectToLogin();
      });
    } catch (exception) {
      rethrow;
    }
  }

  void redirectToLogin() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
      return const LoginController();
    });

    Navigator.of(context).push(materialPageRoute);
  }
}
