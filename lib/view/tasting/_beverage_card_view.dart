import 'package:degust_et_des_couleurs/model/beverage.dart';
import 'package:degust_et_des_couleurs/model/beverage_rating.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class BeverageCardView extends StatelessWidget {
  List<String> dropDownMenuOptions = [
    'Modifier',
    'Supprimer',
  ];

  BeverageCardView({
    super.key,
    required this.beverage,
  });

  Beverage? beverage;

  @override
  Widget build(BuildContext context) {
    int numberOfRating = beverage?.beverageRatings.length ?? 1;

    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          top: 20,
          left: 27,
          right: 27,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Padding(padding: EdgeInsets.only(right: 15)),
            Container(
              width: 330,
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Icon(Icons.room_service_outlined),
                      const Padding(
                        padding: EdgeInsets.only(
                          right: 8,
                        ),
                      ),
                      TextDmSans(
                        beverage?.name ?? "",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                      Spacer(),
                      PopupMenuButton<String>(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        offset: const Offset(0, 15),
                        position: PopupMenuPosition.under,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          side: BorderSide(
                            width: 1,
                            color: MyColors().secondaryColor,
                          ),
                        ),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: "Modifier",
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
                            onTap: () {
                              print("Modifier");
                            },
                          ),
                          PopupMenuItem<String>(
                            value: "Supprimer",
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
                            onTap: () {
                              print("Supprimer");
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: numberOfRating * 45,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: beverage?.beverageRatings.length,
                      itemBuilder: (context, index) {
                        BeverageRating? beverageRating = beverage?.beverageRatings[index];

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDmSans(
                                  beverageRating?.participant.name ?? "",
                                  fontSize: 14,
                                  letterSpacing: 0
                                ),
                                TextDmSans(
                                  "Pedro",
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  color: MyColors().greyColor,
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: MyColors().secondaryColor),
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: Colors.transparent,
                              ),
                              alignment: Alignment.center,
                              child: TextDmSans(
                                beverageRating?.rate ?? "",
                                fontSize: 13,
                                color: MyColors().blackColor,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 45),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}