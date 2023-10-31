import 'dart:async';

import 'package:degust_et_des_couleurs/core/auth.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:flutter/material.dart';

class LoginController extends StatefulWidget {
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

  Future<void> signWithCustomToken() async {
    setState(() {
      errorMessage = "";
    });

    TokenRepository().getToken(controllerEmail.text, controllerPassword.text).then(
      (value) {
        Auth().signInWitCustomToken(token: value.token).catchError((error) {
          setState(() {
            errorMessage = error.message ?? "";
          });
        });
      }
    ).catchError((error) {
      setState(() {
        errorMessage = "Identifiants incorrects";
      });
    });
  }

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
              const Padding(
                padding: EdgeInsets.only(
                  top: 70,
                )
              ),
              Image.asset(
                "assets/images/logo.png",
                height: 130,
                alignment: Alignment.centerLeft,
              ),
              Container(
                padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextDmSans(
                      "Connexion",
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 17,
                      ),
                    ),
                    TextDmSans(
                      "Bienvenue sur Dégust' et des couleurs !",
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w100,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 17,
                      ),
                    ),
                    TextFieldCustom(
                      controller: controllerEmail,
                      placeholder: "Adresse email",
                      icon: Icons.mail_outline_outlined,
                      iconColor: MyColors().primaryColor,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 17,
                      ),
                    ),
                    TextFieldCustom(
                      controller: controllerPassword,
                      placeholder: "Mot de passe",
                      icon: Icons.lock_outline_rounded,
                      iconColor: MyColors().primaryColor,
                      obscureText: true,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child:Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    FloatingActionButtonCustom(
                      text: "Connexion",
                      onPressed: signWithCustomToken,
                    ),
                  ],
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextDmSans(
                      "Pas encore de compte ?",
                      fontSize: 16,
                      letterSpacing: 0,
                    ),
                    TextDmSans(
                      " Inscription",
                      fontSize: 16,
                      letterSpacing: 0,
                      color: MyColors().primaryColor,
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}