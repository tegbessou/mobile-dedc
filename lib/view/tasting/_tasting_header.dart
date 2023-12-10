import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tasting_header_icon_button.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tasting_resume_card_view.dart';
import 'package:flutter/material.dart';

class TastingHeader extends StatefulWidget implements PreferredSizeWidget {
  final Tasting? tasting;

  const TastingHeader({
    super.key,
    required this.tasting,
  });

  @override
  State<StatefulWidget> createState() {
    return TastingHeaderState();
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(40.0);
  }
}

class TastingHeaderState extends State<TastingHeader> {
  late Tasting? tasting;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tasting = widget.tasting;
  }

  @override
  Widget build(BuildContext context) {
    final bool isClosed = tasting?.closed ?? false;
    final Tasting? loadedTasting = tasting;

    if (loadedTasting == null) {
      throw Exception();
    }

    return Container(
      color: !isClosed ? MyColors().whiteColor : MyColors().lightGreyColor,
      padding: const EdgeInsets.only(
        left: 27,
        right: 27,
      ),
      child: !isClosed
          ? Column(
              children: [
                Row(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(
                      left: 8,
                      bottom: 40,
                    )),
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
                    tasting?.restaurant.city != null
                        ? Icon(
                            Icons.location_on_outlined,
                            color: MyColors().greyColor,
                          )
                        : Container(),
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
                        setState(() {
                          isLoading = true;
                        });

                        final String? iri = tasting?.iri;

                        if (iri == null) {
                          return;
                        }

                        TastingRepository().closed(iri).then((value) {
                          MaterialPageRoute materialPageRoute =
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return const HomepageController();
                          });

                          Navigator.of(context).push(materialPageRoute);

                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      icon: Icons.check,
                      isLoading: isLoading,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    TastingHeaderIconButton(
                      onPress: () {},
                      icon: Icons.file_download_outlined,
                      isLoading: false,
                    ),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                TastingResumeCardView(tasting: loadedTasting),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                ),
              ],
            ),
    );
  }
}
