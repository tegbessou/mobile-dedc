import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: TextDmSans("Dégustations", fontSize: 25),
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
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