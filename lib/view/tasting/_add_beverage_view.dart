import 'package:degust_et_des_couleurs/model/beverage_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/beverage_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_rating_button.dart';
import 'package:degust_et_des_couleurs/view/_small_elevated_button.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:degust_et_des_couleurs/view/_text_form_field_custom.dart';
import 'package:flutter/material.dart';

class AddBeverageView extends StatefulWidget {
  final List<Participant> tastingParticipants;
  final Tasting tasting;

  const AddBeverageView({
    super.key,
    required this.tastingParticipants,
    required this.tasting,
  });

  @override
  State<StatefulWidget> createState() {
    return AddDishViewState();
  }
}

class AddDishViewState extends State<AddBeverageView> {
  late List<Participant> tastingParticipants;
  late Tasting tasting;
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Participant> beverageParticipants = [];
  Map<Participant, BeverageRating> beverageRatingParticipants = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    tastingParticipants = widget.tastingParticipants;
    tasting = widget.tasting;
  }

  @override
  void dispose() {
    super.dispose();
    tastingParticipants = [];
    tasting = widget.tasting;
    beverageRatingParticipants = {};
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
                  "Nouvelle boisson",
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
              placeholder: "Nom de la boisson",
              icon: Icons.room_service_outlined,
              iconColor: MyColors().primaryColor,
              controller: nameController,
              onValidate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le nom de la boisson est obligatoire';
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
                itemCount: beverageParticipants.length,
                itemBuilder: (context, index) {
                  final participant = beverageParticipants[index];
                  final beverageRating =
                      beverageRatingParticipants[participant];

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
                            isActive: beverageRating?.rate == "--",
                          ),
                          RatingButton(
                            onPress: () => setRating("-", participant),
                            text: "-",
                            isActive: beverageRating?.rate == "-",
                          ),
                          RatingButton(
                            onPress: () => setRating("=", participant),
                            text: "=",
                            isActive: beverageRating?.rate == "=",
                          ),
                          RatingButton(
                            onPress: () => setRating("+", participant),
                            text: "+",
                            isActive: beverageRating?.rate == "+",
                          ),
                          RatingButton(
                            onPress: () => setRating("++", participant),
                            text: "++",
                            isActive: beverageRating?.rate == "++",
                          ),
                          RatingButton(
                            onPress: () => setRating("xs", participant),
                            text: "XS",
                            isActive: beverageRating?.rate == "xs",
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
                        bottom:
                            index + 1 == beverageParticipants.length ? 0 : 20,
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
            if (!beverageRatingParticipants.containsKey(participant)) {
              beverageParticipants.add(participant);
              beverageRatingParticipants.putIfAbsent(
                participant,
                () => BeverageRating(participant: participant),
              );
            } else {
              beverageParticipants.remove(participant);
              beverageRatingParticipants.remove(participant);
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
    return beverageParticipants.map((item) => item.id).contains(participant.id);
  }

  void setRating(String rating, Participant participant) {
    BeverageRating? beverageRatingParticipant =
        beverageRatingParticipants[participant];

    if (beverageRatingParticipant == null) {
      return;
    }

    beverageRatingParticipant.rate = rating;

    setState(() {
      beverageRatingParticipants.update(
          participant, (rating) => beverageRatingParticipant);
    });
  }

  void setComment(String value, Participant participant) {
    BeverageRating? beverageRatingParticipant =
        beverageRatingParticipants[participant];

    if (beverageRatingParticipant == null) {
      return;
    }

    beverageRatingParticipant.comment = value;

    setState(() {
      beverageRatingParticipants.update(
          participant, (rating) => beverageRatingParticipant);
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

    await BeverageRepository()
        .post(
      nameController.text,
      tasting,
      beverageRatingParticipants,
    )
        .then((value) {
      if (withRedirection) {
        Navigator.pop(context);
      }

      setState(() {
        beverageRatingParticipants = {};
        beverageParticipants = [];
        nameController.text = "";
        isLoading = false;
      });
    });
  }
}
