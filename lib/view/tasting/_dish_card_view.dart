import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class DishCardView extends StatelessWidget {
  List<String> dropDownMenuOptions = [
    'Modifier',
    'Supprimer',
  ];

  DishCardView({
    super.key,
    required this.dish,
  });

  Dish? dish;

  @override
  Widget build(BuildContext context) {
    int numberOfRating = dish?.dishRatings.length ?? 1;

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
              width: MediaQuery.of(context).size.width - 100,
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
                        dish?.name ?? "",
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
                      itemCount: dish?.dishRatings.length,
                      itemBuilder: (context, index) {
                        DishRating? dishRating = dish?.dishRatings[index];

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDmSans(
                                  dishRating?.participant.name ?? "",
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
                                dishRating?.rate ?? "",
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