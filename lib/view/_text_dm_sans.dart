import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TextDmSans extends StatelessWidget {
  final String value;
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;
  final Color? color;
  final TextAlign align;

  const TextDmSans(
    this.value, {
    super.key,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.letterSpacing = 1,
    this.align = TextAlign.start,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: GoogleFonts.dmSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        color: color ?? MyColors().blackColor,
      ),
      textAlign: align,
    );
  }
}
