import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class SmallElevatedButton extends StatelessWidget {
  final void Function()? onPress;
  final String text;
  final Color backgroundColor;
  final Color color;
  final Size? size;

  const SmallElevatedButton({
    super.key,
    required this.onPress,
    required this.text,
    required this.backgroundColor,
    required this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
        elevation: MaterialStateProperty.resolveWith((states) => 0),
        backgroundColor: MaterialStateColor.resolveWith((states) => backgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        minimumSize: MaterialStateProperty.resolveWith((states) => size ?? const Size(62, 25))
      ),
      onPressed: onPress,
      child: TextDmSans(
        text,
        fontSize: 13,
        letterSpacing: 0,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}