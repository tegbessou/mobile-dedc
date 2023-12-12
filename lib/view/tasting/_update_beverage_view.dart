import 'dart:io';
import 'package:degust_et_des_couleurs/model/beverage.dart';
import 'package:degust_et_des_couleurs/model/beverage_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/repository/beverage_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_rating_button.dart';
import 'package:degust_et_des_couleurs/view/_small_elevated_button.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:degust_et_des_couleurs/view/_text_form_field_custom.dart';
import 'package:degust_et_des_couleurs/view/tasting/_image_picker_view.dart';
import 'package:flutter/material.dart';

class UpdateBeverageView extends StatefulWidget {
  final List<Participant> tastingParticipants;
  final Beverage beverage;

  const UpdateBeverageView({
    super.key,
    required this.tastingParticipants,
    required this.beverage,
  });

  @override
  State<StatefulWidget> createState() {
    return UpdateBeverageViewState();
  }
}

class UpdateBeverageViewState extends State<UpdateBeverageView> {
  late List<Participant> tastingParticipants;
  late Beverage beverage;
  late TextEditingController nameController;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool hasNoParticipantsError = false;
  File? beveragePicture;

  @override
  void initState() {
    super.initState();

    beverage = widget.beverage;
    nameController = TextEditingController(text: beverage.name);
    tastingParticipants = widget.tastingParticipants;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: MyColors().whiteColor,
      ),
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
                const TextDmSans(
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
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.73,
                  child: TextFormFieldCustom(
                    placeholder: "Nom de la boisson",
                    icon: Icons.local_bar_outlined,
                    iconColor: MyColors().primaryColor,
                    controller: nameController,
                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le nom de la boisson est obligatoire';
                      }

                      return null;
                    },
                  ),
                ),
                ImagePickerView(
                  file: beveragePicture,
                  setFile: setFile,
                ),
              ],
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
            Padding(
                padding: EdgeInsets.only(
              top: (hasNoParticipantsError) ? 10 : 0,
            )),
            (hasNoParticipantsError)
                ? TextDmSans(
                    "Vous devez sélectionner au moins un participant.",
                    fontSize: 14,
                    color: MyColors().primaryColor,
                    letterSpacing: 0,
                    align: TextAlign.start,
                  )
                : Container(),
            const Padding(
                padding: EdgeInsets.only(
              top: 5,
            )),
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
                itemCount: beverage.beverageRatings.length,
                itemBuilder: (context, index) {
                  final BeverageRating beverageRating =
                      beverage.beverageRatings[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextDmSans(
                        "Note de ${beverageRating.participant.name}",
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
                                setRating("--", beverageRating.participant),
                            text: "--",
                            isActive: beverageRating.rate == "--",
                          ),
                          RatingButton(
                            onPress: () =>
                                setRating("-", beverageRating.participant),
                            text: "-",
                            isActive: beverageRating.rate == "-",
                          ),
                          RatingButton(
                            onPress: () =>
                                setRating("=", beverageRating.participant),
                            text: "=",
                            isActive: beverageRating.rate == "=",
                          ),
                          RatingButton(
                            onPress: () =>
                                setRating("+", beverageRating.participant),
                            text: "+",
                            isActive: beverageRating.rate == "+",
                          ),
                          RatingButton(
                            onPress: () =>
                                setRating("++", beverageRating.participant),
                            text: "++",
                            isActive: beverageRating.rate == "++",
                          ),
                          RatingButton(
                            onPress: () =>
                                setRating("xs", beverageRating.participant),
                            text: "XS",
                            isActive: beverageRating.rate == "xs",
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
                            setComment(value, beverageRating.participant),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        bottom: index == beverage.participants.length ? 0 : 20,
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
                    onPressed: updateBeverage,
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

    for (var participant in tastingParticipants) {
      SmallElevatedButton smallElevatedButtonParticipant = SmallElevatedButton(
        text: participant.name ?? "",
        backgroundColor: isAlreadySelectParticipant(participant)
            ? MyColors().primaryColor
            : MyColors().lightPrimaryColor,
        color: isAlreadySelectParticipant(participant)
            ? MyColors().whiteColor
            : MyColors().primaryColor,
        onPress: () {
          setState(() {
            hasNoParticipantsError = false;
            if (!isAlreadySelectParticipant(participant)) {
              beverage.participants.add(participant);
              beverage.beverageRatings.add(
                BeverageRating(participant: participant, rate: "="),
              );
            } else {
              beverage.participants
                  .removeWhere((Participant participantToBeRemove) {
                return participant.id == participantToBeRemove.id;
              });

              final int index = beverage.beverageRatings
                  .indexWhere((BeverageRating beverageRating) {
                return beverageRating.participant.id == participant.id;
              });

              if (index == -1) {
                return;
              }

              beverage.beverageRatings
                  .remove(beverage.beverageRatings.elementAt(index));
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
    return beverage.participants
        .map((item) => item.id)
        .contains(participant.id);
  }

  void setRating(String rating, Participant participant) {
    final int index =
        beverage.beverageRatings.indexWhere((BeverageRating beverageRating) {
      return beverageRating.participant.id == participant.id;
    });

    if (index == -1) {
      return;
    }

    final BeverageRating beverageRating =
        beverage.beverageRatings.elementAt(index);

    beverageRating.rate = rating;

    setState(() {
      beverage.beverageRatings[index] = beverageRating;
    });
  }

  void setComment(String value, Participant participant) {
    final int index =
        beverage.beverageRatings.indexWhere((BeverageRating beverageRating) {
      return beverageRating.participant.id == participant.id;
    });

    if (index == -1) {
      return;
    }

    final BeverageRating beverageRating =
        beverage.beverageRatings.elementAt(index);

    setState(() {
      beverage.beverageRatings[index] = beverageRating;
    });

    beverageRating.comment = value;

    setState(() {
      beverage.beverageRatings[index] = beverageRating;
    });
  }

  void updateBeverage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (beverage.participants.isEmpty) {
      setState(() {
        hasNoParticipantsError = true;
      });

      return;
    }

    setState(() {
      isLoading = true;
      beverage.name = nameController.text;
    });

    await BeverageRepository()
        .put(
      beverage.iri,
      beverage,
    )
        .then((value) async {
      if (beveragePicture != null) {
        await BeverageRepository().postPicture(beverage.iri, beveragePicture!);
      }

      Navigator.pop(context);
      setState(() {
        nameController.text = "";
        isLoading = false;
      });
    });
  }

  void setFile(File file) {
    setState(() {
      beveragePicture = file;
    });
  }
}
