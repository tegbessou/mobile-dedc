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
import 'package:degust_et_des_couleurs/view/_text_form_field_custom.dart';
import 'package:flutter/material.dart';

class UpdateDishView extends StatefulWidget {
  List<Participant> tastingParticipants;
  Dish dish;

  UpdateDishView({
    super.key,
    required this.tastingParticipants,
    required this.dish,
  });

  @override
  State<StatefulWidget> createState() {
    return UpdateDishViewState();
  }
}

class UpdateDishViewState extends State<UpdateDishView> {
  late List<Participant> tastingParticipants;
  late Dish dish;
  late TextEditingController nameController;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    dish = widget.dish;
    nameController = TextEditingController(text: dish.name);
    tastingParticipants = widget.tastingParticipants;
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(
              top: 40,
            )),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextDmSans(
                  "Modification",
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
            TextFormFieldCustom(
              placeholder: "Nom du plat",
              icon: Icons.room_service_outlined,
              iconColor: MyColors().primaryColor,
              controller: nameController,
              onValidate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le nom du plat est obligatoire';
                }

                return null;
              },
            ),
            const Padding(
                padding: EdgeInsets.only(
              top: 20,
            )),
            TextDmSans(
              "Goûté par",
              fontSize: 18,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
            const Padding(
                padding: EdgeInsets.only(
              top: 5,
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height / 23,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: getParticipants().length,
                  itemBuilder: (context, index) {
                    return getParticipants()[index];
                  }),
            ),
            const Padding(
                padding: EdgeInsets.only(
              top: 20,
            )),
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
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingButton(
                            onPress: () =>
                                setRating("--", dishRating.participant),
                            text: "--",
                            isActive: dishRating.rate == "--",
                          ),
                          RatingButton(
                            onPress: () =>
                                setRating("-", dishRating.participant),
                            text: "-",
                            isActive: dishRating.rate == "-",
                          ),
                          RatingButton(
                            onPress: () =>
                                setRating("=", dishRating.participant),
                            text: "=",
                            isActive: dishRating.rate == "=",
                          ),
                          RatingButton(
                            onPress: () =>
                                setRating("+", dishRating.participant),
                            text: "+",
                            isActive: dishRating.rate == "+",
                          ),
                          RatingButton(
                            onPress: () =>
                                setRating("++", dishRating.participant),
                            text: "++",
                            isActive: dishRating.rate == "++",
                          ),
                          RatingButton(
                            onPress: () =>
                                setRating("xs", dishRating.participant),
                            text: "XS",
                            isActive: dishRating.rate == "xs",
                          ),
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.only(
                        bottom: 20,
                      )),
                      TextFieldCustom(
                        placeholder: "Commentaire (optionnel)",
                        icon: Icons.mode_comment_outlined,
                        iconColor: MyColors().primaryColor,
                        onChanged: (value) =>
                            setComment(value, dishRating.participant),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        bottom: index == dish.participants.length ? 0 : 20,
                      )),
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
                    onPressed: updateDish,
                    text: "Terminer",
                    width: MediaQuery.of(context).size.width / 1.18,
                    height: 55,
                    margin: const EdgeInsets.all(0),
                    elevation: 0,
                    fontWeight: FontWeight.w500,
                    isLoading: isLoading),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getParticipants() {
    List<Widget> participantsWidget = [];

    tastingParticipants.forEach((Participant participant) {
      SmallElevatedButton smallElevatedButtonParticipant = SmallElevatedButton(
        text: participant.name,
        backgroundColor: isAlreadySelectParticipant(participant)
            ? MyColors().primaryColor
            : MyColors().lightPrimaryColor,
        color: isAlreadySelectParticipant(participant)
            ? MyColors().whiteColor
            : MyColors().primaryColor,
        onPress: () {
          setState(() {
            if (!isAlreadySelectParticipant(participant)) {
              dish.participants.add(participant);
              dish.dishRatings.add(
                DishRating(participant: participant),
              );
            } else {
              dish.participants
                  .removeWhere((Participant participantToBeRemove) {
                return participant.id == participantToBeRemove.id;
              });

              final int index =
                  dish.dishRatings.indexWhere((DishRating dishRating) {
                return dishRating.participant.id == participant.id;
              });

              if (index == -1) {
                return;
              }

              dish.dishRatings.remove(dish.dishRatings.elementAt(index));
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

  bool isAlreadySelectParticipant(Participant participant) {
    return dish.participants.map((item) => item.id).contains(participant.id);
  }

  void setRating(String rating, Participant participant) {
    final int index = dish.dishRatings.indexWhere((DishRating dishRating) {
      return dishRating.participant.id == participant.id;
    });

    if (index == -1) {
      return;
    }

    final DishRating dishRating = dish.dishRatings.elementAt(index);

    dishRating.rate = rating;

    setState(() {
      dish.dishRatings[index] = dishRating;
    });
  }

  void setComment(String value, Participant participant) {
    final int index = dish.dishRatings.indexWhere((DishRating dishRating) {
      return dishRating.participant.id == participant.id;
    });

    if (index == -1) {
      return;
    }

    final DishRating dishRating = dish.dishRatings.elementAt(index);

    setState(() {
      dish.dishRatings[index] = dishRating;
    });

    dishRating.comment = value;

    setState(() {
      dish.dishRatings[index] = dishRating;
    });
  }

  void updateDish() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
      dish.name = nameController.text;
    });

    await DishRepository()
        .put(
      dish.iri,
      dish,
    )
        .then((value) {
      Navigator.pop(context);
      setState(() {
        nameController.text = "";
        isLoading = false;
      });
    });
  }
}
