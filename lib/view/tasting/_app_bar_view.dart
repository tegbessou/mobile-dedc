import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  Tasting? tasting;

  AppBarView({
    super.key,
    this.tasting,
  });

  @override
  Widget build(BuildContext context) {
    final isClosed = tasting?.closed ?? false;

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: MyColors().blackColor),
        onPressed: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
              builder: (BuildContext context) {
                return const HomepageController();
              });

          Navigator.of(context).push(materialPageRoute);
        },
      ),
      titleSpacing: 0,
      backgroundColor: !isClosed ? MyColors().whiteColor : MyColors().lightGreyColor,
      title: !isClosed ? TextDmSans(
        tasting?.name == null ? "Dégustation" : "Dégustation ${tasting?.name}",
        fontSize: 22,
        letterSpacing: 0,
        fontWeight: FontWeight.bold,
      ) : TextDmSans(
        "Résumé de la dégustation",
        fontSize: 22,
        letterSpacing: 0,
        fontWeight: FontWeight.bold,
      ),
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