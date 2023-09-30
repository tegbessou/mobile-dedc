import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:flutter/material.dart';

class CreateParticipantAlertDialog extends StatelessWidget {
  TextEditingController createParticipantNameController;
  Future<void> Function() createParticipant;

  CreateParticipantAlertDialog({
    super.key,
    required this.createParticipantNameController,
    required this.createParticipant,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      title: TextDmSans(
        "Créer un participant",
        fontSize: 25,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: MyColors().primaryColor,
      ),
      content: TextFieldCustom(
        controller: createParticipantNameController,
        placeholder: "Nom du participant",
        icon: Icons.person_outline,
        iconColor: MyColors().primaryColor,
      ),
      actions: <Widget>[
        FloatingActionButtonCustom(
          onPressed: createParticipant,
          text: "Créer"
        ),
        FloatingActionButtonCustom(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: "Annuler",
          backgroundColor: MyColors().whiteColor,
          textColor: MyColors().primaryColor,
          elevation: 0,
        ),
      ],
    );
  }

}