import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/repository/dish_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_rating_button.dart';
import 'package:degust_et_des_couleurs/view/_small_elevated_button.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:flutter/material.dart';

class UpdateDishView extends StatefulWidget {
  Dish dish;

  UpdateDishView({
    super.key,
    required this.dish,
  });

  @override
  State<StatefulWidget> createState() {
    return UpdateDishViewState();
  }
}

class UpdateDishViewState extends State<UpdateDishView> {
  late Dish dish;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    dish = widget.dish;
    nameController = TextEditingController(text: dish.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      padding: const EdgeInsets.only(
        left: 27,
        right: 27,
        bottom: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 40,
            )
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextDmSans(
                "Nouveau plat",
                fontSize: 28,
                letterSpacing: 0,
                fontWeight: FontWeight.w800,
              ),
              CircleAvatar(
                backgroundColor: MyColors().secondaryColor,
                radius: 16,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    size: 16,
                    color: MyColors().blackColor,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
          ),
          TextFieldCustom(
            placeholder: "Nom du plat",
            icon: Icons.room_service_outlined,
            iconColor: MyColors().primaryColor,
            controller: nameController,
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 20,
            )
          ),
          TextDmSans(
            "Goûté par",
            fontSize: 18,
            letterSpacing: 0,
            fontWeight: FontWeight.w600,
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 5,
            )
          ),
          Wrap(
            children: getParticipants(),
          ),
          const Padding(
              padding: EdgeInsets.only(
                top: 20,
              )
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: dish.dishRatings.length,
              itemBuilder: (context, index) {
                final DishRating dishRating = dish.dishRatings[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextDmSans(
                      "Note de ${dishRating.participant.name}",
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15,
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingButton(
                          //onPress: () => setRating("--", dishRating.participant),
                          onPress: () => {},
                          text: "--",
                          isActive: dishRating.rate == "--",
                        ),
                        RatingButton(
                          //onPress: () => setRating("-", dishRating.participant),
                          onPress: () => {},
                          text: "-",
                          isActive: dishRating.rate == "-",
                        ),
                        RatingButton(
                          //onPress: () => setRating("=", dishRating.participant),
                          onPress: () => {},
                          text: "=",
                          isActive: dishRating.rate == "=",
                        ),
                        RatingButton(
                          //onPress: () => setRating("+", dishRating.participant),
                          onPress: () => {},
                          text: "+",
                          isActive: dishRating.rate == "+",
                        ),
                        RatingButton(
                          //onPress: () => setRating("++", dishRating.participant),
                          onPress: () => {},
                          text: "++",
                          isActive: dishRating.rate == "++",
                        ),
                        RatingButton(
                          //onPress: () => setRating("xs", dishRating.participant),
                          onPress: () => {},
                          text: "XS",
                          isActive: dishRating.rate == "xs",
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                      )
                    ),
                    TextFieldCustom(
                      placeholder: "Commentaire (optionnel)",
                      icon: Icons.mode_comment_outlined,
                      iconColor: MyColors().primaryColor,
                      //onChanged: (value) => setComment(value, dishRating.participant),
                      onChanged: (value) => {},
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: index + 1 == dish.participants.length ? 0 : 20,
                      )
                    ),
                  ],
                );
              },
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButtonCustom(
                onPressed: () {},
                text: "Plat suivant",
                width: MediaQuery.of(context).size.width / 2.5,
                height: 55,
                margin: const EdgeInsets.all(0),
                backgroundColor: MyColors().lightPrimaryColor,
                textColor: MyColors().primaryColor,
                elevation: 0,
                fontWeight: FontWeight.w500,
              ),
              FloatingActionButtonCustom(
                onPressed: () => {},
                text: "Terminer",
                width: MediaQuery.of(context).size.width / 2.5,
                height: 55,
                margin: const EdgeInsets.all(0),
                elevation: 0,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> getParticipants() {
    List<Widget> participantsWidget = [];

    dish.participants.forEach((Participant participant) {
      SmallElevatedButton smallElevatedButtonParticipant = SmallElevatedButton(
        text: participant.name,
        backgroundColor: MyColors().primaryColor,
        color: MyColors().whiteColor,
        onPress: () {
          setState(() {
            if (!dish.participants.contains(participant)) {
              dish.participants.add(participant);
              /*dish.participants.putIfAbsent(
                participant, () => DishRating(participant: participant),
              );*/
            } else {
              /*dishParticipants.remove(participant);
              dishRatingParticipants.remove(participant);*/
            }
          });
        },
        size: const Size(100, 33),
      );

      participantsWidget.add(smallElevatedButtonParticipant);

      Padding padding = const Padding(
        padding: EdgeInsets.only(
          left: 5,
        ),
      );

      participantsWidget.add(padding);
    });

    return participantsWidget;
  }

  /*bool isAlreadySelectParticipant(Participant participant) {
    return dishParticipants.map((item) => item.id).contains(participant.id);
  }

  void setRating(String rating, Participant participant) {
    DishRating? dishRatingParticipant = dishRatingParticipants[participant];

    if (dishRatingParticipant == null) {
      return;
    }

    dishRatingParticipant.rate = rating;

    setState(() {
      dishRatingParticipants.update(participant, (rating) => dishRatingParticipant);
    });
  }

  void setComment(String value, Participant participant) {
    DishRating? dishRatingParticipant = dishRatingParticipants[participant];

    if (dishRatingParticipant == null) {
      return;
    }

    dishRatingParticipant.comment = value;

    setState(() {
      dishRatingParticipants.update(participant, (rating) => dishRatingParticipant);
    });
  }

  void createDish() async {
    await DishRepository().post(
      nameController.text,
      tasting,
      dishRatingParticipants,
    ).then((value) {
      Navigator.pop(context);
      setState(() {
        dishRatingParticipants = {};
        nameController.text = "";
      });
    });
  }*/
}