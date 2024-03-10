import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/public/_public_footer.dart';
import 'package:degust_et_des_couleurs/view/public/_public_header.dart';
import 'package:degust_et_des_couleurs/view/register/_register_form.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  final Future<void> Function(TextEditingValue username,
      TextEditingValue password, TextEditingValue firstName) register;
  final void Function() redirectToLogin;

  const RegisterView(
      {super.key, required this.register, required this.redirectToLogin});

  @override
  State<StatefulWidget> createState() {
    return RegisterViewState();
  }
}

class RegisterViewState extends State<RegisterView> {
  late Future<void> Function(TextEditingValue username,
      TextEditingValue password, TextEditingValue firstName) register;
  late void Function() redirectToLogin;

  @override
  void initState() {
    super.initState();

    register = widget.register;
    redirectToLogin = widget.redirectToLogin;
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
                pageName: "Inscription",
              ),
              RegisterForm(
                handleSubmit: register,
              ),
              const Spacer(),
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
}
