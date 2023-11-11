import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  const AppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: null,
      title: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
      backgroundColor: MyColors().whiteColor,
      centerTitle: false,
      toolbarHeight: 1000,
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