import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  const AppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Padding(
        padding: EdgeInsets.only(
          left: 10,
        ),
        child: TextDmSans("Dégustations", fontSize: 25),
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      surfaceTintColor: MyColors().lightGreyColor,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        letterSpacing: 1,
        color: Colors.black,
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
