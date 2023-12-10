import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  const AppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: MyColors().blackColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: TextDmSans(
        "Nouvelle dégustation",
        fontSize: 25,
        letterSpacing: 0,
        color: MyColors().blackColor,
        fontWeight: FontWeight.w700,
      ),
      backgroundColor: MyColors().whiteColor,
      centerTitle: false,
      titleTextStyle: TextStyle(
        letterSpacing: 1,
        color: MyColors().blackColor,
        fontWeight: FontWeight.w700,
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(40.0);
  }
}
