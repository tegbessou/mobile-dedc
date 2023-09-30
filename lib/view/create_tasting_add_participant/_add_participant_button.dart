import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';

class AddParticipantButton extends StatelessWidget {
  void Function() displayAddParticipant;

  AddParticipantButton({
    super.key,
    required this.displayAddParticipant,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: MyColors().primaryColor,
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: MyColors().whiteColor,
        ),
        onPressed: displayAddParticipant,
      ),
    );
  }
}