import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tasting_header_icon_button.dart';
import 'package:flutter/material.dart';

class TastingHeader extends StatelessWidget implements PreferredSizeWidget {
  Tasting? tasting;

  TastingHeader({
    super.key,
    this.tasting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 27,
        right: 27,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 8,
                  bottom: 40,
                )
              ),
              TextDmSans(
                tasting?.restaurant.name ?? "",
                fontSize: 20,
                letterSpacing: 0,
              ),
              const Padding(padding: EdgeInsets.all(6)),
              Icon(
                Icons.groups_2_outlined,
                color: MyColors().greyColor,
              ),
              const Padding(padding: EdgeInsets.all(2)),
              TextDmSans(
                "${tasting?.participants.length}",
                fontSize: 12,
                color: MyColors().greyColor,
                letterSpacing: 0,
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: MyColors().greyColor,
              ),
              const Padding(padding: EdgeInsets.all(2)),
              TextDmSans(
                tasting?.restaurant.city ?? "",
                fontSize: 12,
                color: MyColors().greyColor,
                letterSpacing: 0,
              ),
              const Spacer(),
              TastingHeaderIconButton(
                onPress: () {

                },
                icon: Icons.check,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              TastingHeaderIconButton(
                onPress: () {

                },
                icon: Icons.file_download_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(40.0);
  }
}