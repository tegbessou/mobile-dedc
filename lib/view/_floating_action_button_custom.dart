import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FloatingActionButtonCustom extends StatelessWidget {
  void Function() onPressed;
  String text;
  Color? backgroundColor;
  Color? textColor;
  double elevation;
  double width;
  double height;
  double fontSize;
  FontWeight? fontWeight;
  EdgeInsets? margin;
  bool isLoading;

  FloatingActionButtonCustom({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.elevation = 1,
    this.width = 325,
    this.height = 60,
    this.fontSize = 18,
    this.fontWeight,
    this.margin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          backgroundColor: backgroundColor ?? MyColors().primaryColor,
          elevation: elevation,
        ),
        onPressed: onPressed,
        child: getButtonContent(),
      ),
    );
  }

  Widget getButtonContent() {
    if (isLoading) {
      return LoadingAnimationWidget.inkDrop(
        color: MyColors().whiteColor,
        size: 20,
      );
    }

    return Center(
      child: TextDmSans(
        text,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w700,
        letterSpacing: 0,
        color: textColor ?? MyColors().whiteColor,
      ),
    );
  }
}