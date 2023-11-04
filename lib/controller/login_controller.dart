import 'dart:async';
import 'package:degust_et_des_couleurs/controller/register_controller.dart';
import 'package:degust_et_des_couleurs/core/auth.dart';
import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
import 'package:degust_et_des_couleurs/model/user.dart';
import 'package:degust_et_des_couleurs/repository/token_repository.dart';
import 'package:degust_et_des_couleurs/repository/user_repository.dart';
import 'package:degust_et_des_couleurs/view/public/_public_footer.dart';
import 'package:degust_et_des_couleurs/view/public/_public_header.dart';
import 'package:degust_et_des_couleurs/view/public/_public_login_register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

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
                pageName: "Connexion",
              ),
              PublicLoginRegisterForm(
                buttonLabel: "Connexion",
                handleSubmit: signWithCustomToken,
              ),
              Spacer(),
              PublicFooter(
                firstSentence: "Pas encore de compte ? ",
                secondSentence: "Inscription",
                redirectTo: redirectToRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signWithCustomToken(TextEditingValue email, TextEditingValue password) async {
    try {
      await TokenRepository().createToken(email.text, password.text).then((value) {
        String? token = value.token;

        if (token == null) {
          throw BadCredentialException();
        }

        Auth().signInWitCustomToken(token: token).then((value) {
          UserRepository().getByUsername(email.text).then((User value) async {
            const storage = FlutterSecureStorage();

            await storage.write(key: "user_id", value: value.id.toString());

            context.goNamed("homepage");
          });
        }).catchError((error) {
          setState(() {
            errorMessage = error.message ?? "";
          });
        });
      });
    } catch (exception) {
      rethrow;
    }
  }

  void redirectToRegister() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context) {
      return RegisterController();
    });

    Navigator.of(context).push(materialPageRoute);
  }
}