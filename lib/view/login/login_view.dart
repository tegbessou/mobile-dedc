import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/login/_login_form.dart';
import 'package:degust_et_des_couleurs/view/public/_public_footer.dart';
import 'package:degust_et_des_couleurs/view/public/_public_header.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  final Future<void> Function(
      TextEditingValue username, TextEditingValue password) signWithCustomToken;
  final void Function() redirectToRegister;

  const LoginView(
      {super.key,
      required this.signWithCustomToken,
      required this.redirectToRegister});

  @override
  State<StatefulWidget> createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<LoginView> {
  late Future<void> Function(
      TextEditingValue username, TextEditingValue password) signWithCustomToken;
  late void Function() redirectToRegister;

  @override
  void initState() {
    super.initState();

    signWithCustomToken = widget.signWithCustomToken;
    redirectToRegister = widget.redirectToRegister;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().whiteColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const PublicHeader(
                pageName: "Connexion",
              ),
              LoginForm(
                handleSubmit: signWithCustomToken,
              ),
              const Spacer(),
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
}
