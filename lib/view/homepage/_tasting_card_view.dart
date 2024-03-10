import 'dart:math';
import 'package:degust_et_des_couleurs/controller/tasting_controller.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class TastingCardView extends StatelessWidget {
  final List<String> pictures = [
    "assets/images/tasting_1.jpeg",
    "assets/images/tasting_2.jpeg",
    "assets/images/tasting_3.jpeg",
    "assets/images/tasting_4.jpeg",
  ];
  final Tasting tasting;
  final int userId;
  final Future<void> Function(Tasting tasting) delete;

  TastingCardView({
    super.key,
    required this.tasting,
    required this.userId,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    return InkWell(
      onTap: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) {
          return TastingController(id: tasting.id, userId: userId);
        });

        Navigator.of(context).push(materialPageRoute);
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          top: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                pictures[random.nextInt(3) + 1],
                fit: BoxFit.cover,
                width: 72,
                height: 72,
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Container(
                padding: const EdgeInsets.only(
                  top: 7,
                  bottom: 7,
                ),
                width: MediaQuery.of(context).size.width - 160,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 210,
                          child: TextDmSans(
                            tasting.restaurant.name,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                        ),
                        tasting.closed && canShare()
                            ? PopupMenuButton<String>(
                                color: MyColors().whiteColor,
                                padding: const EdgeInsets.only(
                                  left: 15,
                                ),
                                offset: const Offset(0, 0),
                                position: PopupMenuPosition.under,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0)),
                                  side: BorderSide(
                                    width: 1,
                                    color: MyColors().secondaryColor,
                                  ),
                                ),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: "Supprimer",
                                    onTap: () => delete(tasting),
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
                                        )),
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
                              )
                            : Container(),
                      ],
                    ),
                    TextDmSans(
                      "${tasting.getFormattedDate()} - ${tasting.name}",
                      fontSize: 11,
                      letterSpacing: 0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextDmSans(
                          "${tasting.participants.length} participants",
                          fontSize: 11,
                          color: MyColors().greyColor,
                          letterSpacing: 0,
                        ),
                        const Spacer(),
                        !tasting.closed
                            ? SizedBox(
                                height: 25,
                                width: 85,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor:
                                        MyColors().lightPrimaryColor,
                                    elevation: 0,
                                    padding: const EdgeInsets.only(
                                      left: 0,
                                      right: 0,
                                    ),
                                  ),
                                  onPressed: () {
                                    MaterialPageRoute materialPageRoute =
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return TastingController(
                                          id: tasting.id, userId: userId);
                                    });

                                    Navigator.of(context)
                                        .push(materialPageRoute);
                                  },
                                  child: Center(
                                    child: TextDmSans(
                                      "Reprendre",
                                      fontSize: 11,
                                      letterSpacing: 0,
                                      color: MyColors().primaryColor,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  bool canShare() {
    return tasting.user == "/users/$userId";
  }
}
