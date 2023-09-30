import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';

class TastingHeaderIconButton extends StatelessWidget {
  void Function() onPress;
  IconData icon;

  TastingHeaderIconButton({
    super.key,
    required this.onPress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: MyColors().secondaryColor),
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: IconButton(
        onPressed: onPress,
        icon: Icon(icon),
      ),
    );
  }

}