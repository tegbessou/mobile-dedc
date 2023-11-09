import 'dart:async';

import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
import 'package:degust_et_des_couleurs/exception/username_already_used_exception.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_form_field_custom.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class PublicLoginRegisterForm extends StatefulWidget {
  final String buttonLabel;
  final Future<void> Function(TextEditingValue email, TextEditingValue password)
      handleSubmit;

  PublicLoginRegisterForm(
      {super.key, required this.buttonLabel, required this.handleSubmit});

  @override
  State<StatefulWidget> createState() {
    return PublicLoginRegisterFormState();
  }
}

class PublicLoginRegisterFormState extends State<PublicLoginRegisterForm> {
  late String buttonLabel;
  String errorMessage = "";
  late Future<void> Function(TextEditingValue email, TextEditingValue password)
      handleSubmit;
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    buttonLabel = widget.buttonLabel;
    handleSubmit = widget.handleSubmit;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormFieldCustom(
                controller: controllerEmail,
                placeholder: "Adresse email",
                icon: Icons.mail_outline_outlined,
                iconColor: MyColors().primaryColor,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                onValidate: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "L'adresse email est obligatoire";
                  }

                  if (!EmailValidator.validate(value)) {
                    return "L'adresse email n'est pas valide";
                  }

                  return null;
                }),
            MediaQuery.of(context).size.height > 680
                ? const Padding(
                    padding: EdgeInsets.only(
                      top: 17,
                    ),
                  )
                : Spacer(),
            TextFormFieldCustom(
                controller: controllerPassword,
                placeholder: "Mot de passe",
                icon: Icons.lock_outline_rounded,
                iconColor: MyColors().primaryColor,
                obscureText: true,
                onValidate: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Le mot de passe est obligatoire";
                  }

                  return null;
                }),
            MediaQuery.of(context).size.height > 680
                ? const Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                    ),
                  )
                : Spacer(),
            Container(
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            FloatingActionButtonCustom(
              text: buttonLabel,
              onPressed: onSubmitForm,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }

  onSubmitForm() async {
    setState(() {
      errorMessage = "";
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await handleSubmit(controllerEmail.value, controllerPassword.value)
            .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
      } on BadCredentialException {
        setState(() {
          errorMessage = "Identifiants incorrects";
          isLoading = false;
        });
      } on UsernameAlreadyUsedException {
        setState(() {
          errorMessage = "Cette adresse mail est déjà utilisée";
          isLoading = false;
        });
      }
    }
  }
}
