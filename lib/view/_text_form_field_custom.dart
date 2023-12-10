import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  final String placeholder;
  final IconData icon;
  final Color? iconColor;
  final bool obscureText;
  final bool autocorrect;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? onValidate;

  const TextFormFieldCustom({
    super.key,
    required this.placeholder,
    required this.icon,
    this.iconColor,
    this.controller,
    this.onChanged,
    this.onValidate,
    this.obscureText = false,
    this.autocorrect = true,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged ?? (value) => {},
      obscureText: obscureText,
      validator: onValidate ??
          (value) {
            return null;
          },
      autocorrect: autocorrect,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: MyColors().whiteColor,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: MyColors().secondaryColor,
            )),
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
