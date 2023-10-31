import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  String placeholder;
  IconData icon;
  Color? iconColor;
  bool obscureText;
  TextEditingController? controller;
  void Function(String value)? onChanged;

  TextFieldCustom({
    super.key,
    required this.placeholder,
    required this.icon,
    this.iconColor,
    this.controller,
    this.onChanged,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged ?? (value) => {},
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: MyColors().whiteColor,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: MyColors().secondaryColor,
            )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: MyColors().secondaryColor,
          ),
        ),
        focusColor: MyColors().secondaryColor,
        prefixIcon: Icon(icon),
        prefixIconColor: iconColor ?? MyColors().blackColor,
        labelText: placeholder,
        labelStyle: TextStyle(
          color: MyColors().greyColor,
        ),
      ),
    );
  }
}