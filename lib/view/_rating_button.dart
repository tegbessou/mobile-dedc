import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class RatingButton extends StatelessWidget {
  final void Function() onPress;
  final String text;
  final bool isActive;

  const RatingButton({
    super.key,
    required this.onPress,
    required this.text,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height > 680
          ? MediaQuery.of(context).size.width / 8
          : MediaQuery.of(context).size.width / 9,
      height: MediaQuery.of(context).size.height > 680
          ? MediaQuery.of(context).size.width / 8
          : MediaQuery.of(context).size.width / 9,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color:
                isActive ? MyColors().primaryColor : MyColors().secondaryColor),
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: isActive ? MyColors().lightPrimaryColor : Colors.transparent,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: onPress,
        child: TextDmSans(
          text,
          fontSize: 15,
          color: isActive ? MyColors().primaryColor : MyColors().blackColor,
        ),
      ),
    );
  }
}
