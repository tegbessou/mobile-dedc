import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_form_field_custom.dart';
import 'package:flutter/material.dart';

class CreateParticipantAlertDialog extends StatefulWidget {
  final TextEditingController createParticipantNameController;
  final Future<void> Function() createParticipant;

  const CreateParticipantAlertDialog({
    super.key,
    required this.createParticipantNameController,
    required this.createParticipant,
  });

  @override
  State<StatefulWidget> createState() {
    return CreateParticipantAlertDialogState();
  }
}

class CreateParticipantAlertDialogState
    extends State<CreateParticipantAlertDialog> {
  late TextEditingController createParticipantNameController;
  final _formKey = GlobalKey<FormState>();
  late Future<void> Function() createParticipant;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    createParticipantNameController = widget.createParticipantNameController;
    createParticipant = widget.createParticipant;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors().whiteColor,
      elevation: 0,
      title: TextDmSans(
        "Créer un participant",
        fontSize: 25,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: MyColors().primaryColor,
      ),
      content: Form(
        key: _formKey,
        child: TextFormFieldCustom(
          controller: createParticipantNameController,
          placeholder: "Nom du participant",
          icon: Icons.person_outline,
          iconColor: MyColors().primaryColor,
          onValidate: (value) {
            if (value == null || value.isEmpty) {
              return 'Le nom du participant est obligatoire';
            }

            return null;
          },
        ),
      ),
      actions: <Widget>[
        FloatingActionButtonCustom(
          onPressed: addParticipant,
          text: "Créer",
          isLoading: isLoading,
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

  void addParticipant() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      createParticipant().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
