import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class DishCardView extends StatelessWidget {
  final List<String> dropDownMenuOptions = [
    'Modifier',
    'Supprimer',
  ];
  final Tasting tasting;
  final Dish? dish;
  final void Function(Dish? dish) remove;
  final void Function(Tasting tasting, Dish? dish) update;

  DishCardView({
    super.key,
    required this.tasting,
    required this.dish,
    required this.remove,
    required this.update,
  });

  @override
  Widget build(BuildContext context) {
    int numberOfRating = dish?.dishRatings.length ?? 1;
    String? imagePath = dish!.contentUrl;

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
                        SizedBox(
                          width: (imagePath != null)
                              ? MediaQuery.of(context).size.width - 230
                              : MediaQuery.of(context).size.width - 180,
                          child: TextDmSans(
                            dish?.name ?? "",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                        ),
                        (imagePath != null && !tasting.closed)
                            ? IconButton(
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    backgroundColor: MyColors().whiteColor,
                                    surfaceTintColor: MyColors().whiteColor,
                                    content: Image.network(
                                      imagePath,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                icon: const Icon(Icons.photo),
                              )
                            : Container(),
                        !tasting.closed
                            ? PopupMenuButton<String>(
                                color: MyColors().whiteColor,
                                padding: const EdgeInsets.only(
                                  left: 15,
                                ),
                                offset: const Offset(0, 15),
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
                                        )),
                                        TextDmSans(
                                          "Modifier",
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          color: MyColors().blackColor,
                                        ),
                                      ],
                                    ),
                                    onTap: () => update(tasting, dish),
                                  ),
                                  PopupMenuItem<String>(
                                    value: "Supprimer",
                                    onTap: () => remove(dish),
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
                                        letterSpacing: 0),
                                    TextDmSans(
                                      dishRating?.comment ?? "",
                                      fontSize: 14,
                                      letterSpacing: 0,
                                      color: MyColors().greyColor,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: MyColors().secondaryColor),
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
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
                          }),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
