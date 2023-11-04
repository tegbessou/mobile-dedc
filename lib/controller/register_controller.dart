import 'dart:async';

import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/core/auth.dart';
import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:degust_et_des_couleurs/repository/user_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/public/_public_footer.dart';
import 'package:degust_et_des_couleurs/view/public/_public_header.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:degust_et_des_couleurs/view/public/_public_login_register_form.dart';
import 'package:flutter/material.dart';

class RegisterController extends StatefulWidget {
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const PublicHeader(
                pageName: "Inscription",
              ),
              PublicLoginRegisterForm(
                buttonLabel: "Inscription",
                handleSubmit: register,
              ),
              Spacer(),
              PublicFooter(
                firstSentence: "Vous avez déjà un compte ? ",
                secondSentence: "Connexion",
                redirectTo: redirectToLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register(TextEditingValue email, TextEditingValue password) async {
    try {
      await UserRepository().post(email.text, password.text).then((value) {
        redirectToLogin();
      });
    } catch (exception) {
      rethrow;
    }
  }

  void redirectToLogin() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context) {
      return LoginController();
    });

    Navigator.of(context).push(materialPageRoute);
  }
}