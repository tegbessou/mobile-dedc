import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class DishCardMenuAction extends StatelessWidget {
  void Function() updateDish;
  void Function() deleteDish;

  DishCardMenuAction({
    super.key,
    required this.updateDish,
    required this.deleteDish,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        offset: const Offset(0, 15),
        position: PopupMenuPosition.under,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          side: BorderSide(
            width: 1,
            color: MyColors().secondaryColor,
          ),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: "Modifier",
            onTap: updateDish,
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: MyColors().blackColor,
                ),
                const Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                    )
                ),
                TextDmSans(
                  "Modifier",
                  fontSize: 16,
                  letterSpacing: 0,
                  color: MyColors().blackColor,
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: "Supprimer",
            onTap: deleteDish,
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: MyColors().blackColor,
                ),
                const Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                    )
                ),
                TextDmSans(
                  "Supprimer",
                  fontSize: 16,
                  letterSpacing: 0,
                  color: MyColors().blackColor,
                ),
              ],
            ),
          ),
        ],
      );
  }
}