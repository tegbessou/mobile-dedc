import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/dish_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_rating_button.dart';
import 'package:degust_et_des_couleurs/view/_small_elevated_button.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:degust_et_des_couleurs/view/_text_form_field_custom.dart';
import 'package:flutter/material.dart';

class AddDishView extends StatefulWidget {
  final List<Participant> tastingParticipants;
  final Tasting tasting;
  final Map<Participant, DishRating> dishRatingParticipants;

  const AddDishView({
    super.key,
    required this.tastingParticipants,
    required this.tasting,
    required this.dishRatingParticipants,
  });

  @override
  State<StatefulWidget> createState() {
    return AddDishViewState();
  }
}

class AddDishViewState extends State<AddDishView> {
  late List<Participant> tastingParticipants;
  late Tasting tasting;
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Participant> dishParticipants = [];
  Map<Participant, DishRating> dishRatingParticipants = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    tastingParticipants = widget.tastingParticipants;
    tasting = widget.tasting;
    dishRatingParticipants = widget.dishRatingParticipants;
  }

  @override
  void dispose() {
    super.dispose();
    tastingParticipants = [];
    tasting = widget.tasting;
    dishRatingParticipants = {};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height > 736
          ? MediaQuery.of(context).size.height * 0.80
          : MediaQuery.of(context).size.height * 0.85,
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
                const TextDmSans(
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
            const TextDmSans(
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
                itemCount: dishParticipants.length,
                itemBuilder: (context, index) {
                  final participant = dishParticipants[index];
                  final dishRating = dishRatingParticipants[participant];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextDmSans(
                        "Note de ${participant.name}",
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
                            onPress: () => setRating("--", participant),
                            text: "--",
                            isActive: dishRating?.rate == "--",
                          ),
                          RatingButton(
                            onPress: () => setRating("-", participant),
                            text: "-",
                            isActive: dishRating?.rate == "-",
                          ),
                          RatingButton(
                            onPress: () => setRating("=", participant),
                            text: "=",
                            isActive: dishRating?.rate == "=",
                          ),
                          RatingButton(
                            onPress: () => setRating("+", participant),
                            text: "+",
                            isActive: dishRating?.rate == "+",
                          ),
                          RatingButton(
                            onPress: () => setRating("++", participant),
                            text: "++",
                            isActive: dishRating?.rate == "++",
                          ),
                          RatingButton(
                            onPress: () => setRating("xs", participant),
                            text: "XS",
                            isActive: dishRating?.rate == "xs",
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
                        onChanged: (value) => setComment(value, participant),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        bottom: index + 1 == dishParticipants.length ? 0 : 20,
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
                  onPressed: () => createDish(false),
                  text: "Plat suivant",
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 55,
                  margin: const EdgeInsets.all(0),
                  backgroundColor: MyColors().lightPrimaryColor,
                  textColor: MyColors().primaryColor,
                  elevation: 0,
                  fontWeight: FontWeight.w500,
                  isLoading: isLoading,
                ),
                FloatingActionButtonCustom(
                  onPressed: () => createDish(true),
                  text: "Terminer",
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 55,
                  margin: const EdgeInsets.all(0),
                  elevation: 0,
                  fontWeight: FontWeight.w500,
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getParticipants() {
    List<Widget> participantsWidget = [];

    for (var participant in tastingParticipants) {
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
            if (!dishRatingParticipants.containsKey(participant)) {
              dishParticipants.add(participant);
              dishRatingParticipants.putIfAbsent(
                participant,
                () => DishRating(participant: participant),
              );
            } else {
              dishParticipants.remove(participant);
              dishRatingParticipants.remove(participant);
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
    }

    return participantsWidget;
  }

  bool isAlreadySelectParticipant(Participant participant) {
    return dishParticipants.map((item) => item.id).contains(participant.id);
  }

  void setRating(String rating, Participant participant) {
    DishRating? dishRatingParticipant = dishRatingParticipants[participant];

    if (dishRatingParticipant == null) {
      return;
    }

    dishRatingParticipant.rate = rating;

    setState(() {
      dishRatingParticipants.update(
          participant, (rating) => dishRatingParticipant);
    });
  }

  void setComment(String value, Participant participant) {
    DishRating? dishRatingParticipant = dishRatingParticipants[participant];

    if (dishRatingParticipant == null) {
      return;
    }

    dishRatingParticipant.comment = value;

    setState(() {
      dishRatingParticipants.update(
          participant, (rating) => dishRatingParticipant);
    });
  }

  void createDish(
    bool withRedirection,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await DishRepository()
        .post(
      nameController.text,
      tasting,
      dishRatingParticipants,
    )
        .then((value) {
      if (withRedirection) {
        Navigator.pop(context);
      }

      setState(() {
        dishRatingParticipants = {};
        dishParticipants = [];
        nameController.text = "";
        isLoading = false;
      });
    });
  }
}
