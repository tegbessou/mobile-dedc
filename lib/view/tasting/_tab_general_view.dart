import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/model/general_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/general_rating_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_rating_button.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:flutter/material.dart';

class TabGeneralView extends StatefulWidget {
  final Tasting tasting;
  final List<Participant> participants;
  final Map<Participant, GeneralRating> generalRatings;

  const TabGeneralView({
    super.key,
    required this.tasting,
    required this.participants,
    required this.generalRatings,
  });

  @override
  State<StatefulWidget> createState() {
    return TabGeneralViewState();
  }
}

class TabGeneralViewState extends State<TabGeneralView> {
  late Tasting tasting;
  late List<Participant> participants;
  late Map<Participant, GeneralRating> generalRatings;
  late Map<Participant, TextEditingController> commentsByParticipants;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    tasting = widget.tasting;
    participants = widget.participants;
    Map<Participant, TextEditingController> commentsByParticipantsInitialize =
        {};

    if (widget.generalRatings.length != widget.participants.length) {
      generalRatings = widget.generalRatings;
      for (var element in widget.participants) {
        if (widget.generalRatings.containsKey(element)) {
          continue;
        }

        generalRatings[element] =
            GeneralRating(participant: element, rate: "=");
        commentsByParticipantsInitialize[element] = TextEditingController();
      }
      commentsByParticipants = commentsByParticipantsInitialize;

      return;
    }

    for (var element in widget.participants) {
      commentsByParticipantsInitialize[element] =
          TextEditingController(text: widget.generalRatings[element]?.comment);
    }

    generalRatings = widget.generalRatings;
    commentsByParticipants = commentsByParticipantsInitialize;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height > 680
              ? MediaQuery.of(context).size.height > 736
                  ? MediaQuery.of(context).size.height * 0.57
                  : MediaQuery.of(context).size.height * 0.55
              : MediaQuery.of(context).size.height * 0.51,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: generalRatings.length,
              itemBuilder: (context, index) {
                var participant = participants[index];
                final generalRating = generalRatings[participant];

                return InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                      left: 27,
                      right: 27,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextDmSans(
                          "Note de ${participant.name}",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(
                          top: 15,
                        )),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingButton(
                              onPress: () => setRating("--", participant),
                              text: "--",
                              isActive: generalRating?.rate == "--",
                            ),
                            RatingButton(
                              onPress: () => setRating("-", participant),
                              text: "-",
                              isActive: generalRating?.rate == "-",
                            ),
                            RatingButton(
                              onPress: () => setRating("=", participant),
                              text: "=",
                              isActive: generalRating?.rate == "=",
                            ),
                            RatingButton(
                              onPress: () => setRating("+", participant),
                              text: "+",
                              isActive: generalRating?.rate == "+",
                            ),
                            RatingButton(
                              onPress: () => setRating("++", participant),
                              text: "++",
                              isActive: generalRating?.rate == "++",
                            ),
                            RatingButton(
                              onPress: () => setRating("xs", participant),
                              text: "XS",
                              isActive: generalRating?.rate == "xs",
                            ),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.only(
                          bottom: 20,
                        )),
                        TextFieldCustom(
                          placeholder: "Commentaire (optionnel)",
                          controller: commentsByParticipants[participant],
                          icon: Icons.mode_comment_outlined,
                          iconColor: MyColors().primaryColor,
                          onChanged: (value) => setComment(value, participant),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          bottom: index + 1 == participants.length ? 0 : 20,
                        )),
                      ],
                    ),
                  ),
                );
              }),
        ),
        const Spacer(),
        FloatingActionButtonCustom(
          backgroundColor: !tasting.closed
              ? MyColors().primaryColor
              : MyColors().lightPrimaryColor,
          textColor:
              !tasting.closed ? MyColors().whiteColor : MyColors().primaryColor,
          elevation: 0,
          onPressed: !tasting.closed ? saveGeneralRating : goToHome,
          text: !tasting.closed ? "Enregistrer" : "Fermer",
          isLoading: isLoading,
        ),
      ],
    );
  }

  void saveGeneralRating() {
    //Handle update here
    int i = 0;
    setState(() {
      isLoading = true;
    });

    int numberGeneralRatingSubmitted = 0;

    generalRatings.forEach((participant, generalRating) {
      final String generalRatingIri = generalRating.iri ?? "";

      if (generalRating.rate == null) {
        return;
      }
      numberGeneralRatingSubmitted++;

      if (generalRatingIri.isNotEmpty) {
        GeneralRatingRepository()
            .put(generalRatingIri, generalRating.rate ?? 'xs',
                commentsByParticipants[participant]?.text ?? "")
            .then((value) {
          i = i + 1;

          if (numberGeneralRatingSubmitted == i) {
            setState(() {
              isLoading = false;
            });
          }
        });

        return;
      }

      GeneralRatingRepository()
          .post(tasting, participant, generalRating.rate ?? 'xs',
              commentsByParticipants[participant]?.text ?? "")
          .then((value) {
        i = i + 1;

        generalRating.iri = value.iri;

        if (numberGeneralRatingSubmitted == i) {
          setState(() {
            generalRatings.update(participant, (rating) => generalRating);
            isLoading = false;
          });
        }
      });
    });
  }

  void setRating(String rating, Participant participant) {
    GeneralRating? generalRatingParticipant = generalRatings[participant];

    if (generalRatingParticipant == null) {
      return;
    }

    generalRatingParticipant.rate = rating;

    setState(() {
      generalRatings.update(participant, (rating) => generalRatingParticipant);
    });
  }

  void setComment(String value, Participant participant) {
    GeneralRating? generalRatingParticipant = generalRatings[participant];

    if (generalRatingParticipant == null) {
      return;
    }

    generalRatingParticipant.comment = value;

    setState(() {
      generalRatings.update(participant, (rating) => generalRatingParticipant);
    });
  }

  void goToHome() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
      return const HomepageController();
    });

    Navigator.of(context).push(materialPageRoute);
  }
}
