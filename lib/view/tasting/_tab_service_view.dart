import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/service_rating.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/service_rating_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_rating_button.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:flutter/material.dart';

class TabServiceView extends StatefulWidget {
  final Tasting tasting;
  final List<Participant> participants;
  final Map<Participant, ServiceRating> serviceRatings;

  const TabServiceView({
    super.key,
    required this.tasting,
    required this.participants,
    required this.serviceRatings,
  });

  @override
  State<StatefulWidget> createState() {
    return TabServiceViewState();
  }
}

class TabServiceViewState extends State<TabServiceView> {
  late Tasting tasting;
  late List<Participant> participants;
  late Map<Participant, ServiceRating> serviceRatings;
  late Map<Participant, TextEditingController> commentsByParticipants;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    tasting = widget.tasting;
    participants = widget.participants;
    Map<Participant, TextEditingController> commentsByParticipantsInitialize =
        {};

    if (widget.serviceRatings.length != widget.participants.length) {
      serviceRatings = widget.serviceRatings;
      for (var element in widget.participants) {
        if (widget.serviceRatings.containsKey(element)) {
          continue;
        }

        serviceRatings[element] =
            ServiceRating(participant: element, rate: "=");
        commentsByParticipantsInitialize[element] = TextEditingController();
      }
      commentsByParticipants = commentsByParticipantsInitialize;

      return;
    }

    for (var element in widget.participants) {
      commentsByParticipantsInitialize[element] =
          TextEditingController(text: widget.serviceRatings[element]?.comment);
    }

    serviceRatings = widget.serviceRatings;
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
              itemCount: serviceRatings.length,
              itemBuilder: (context, index) {
                var participant = participants[index];
                final serviceRating = serviceRatings[participant];

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
                              isActive: serviceRating?.rate == "--",
                            ),
                            RatingButton(
                              onPress: () => setRating("-", participant),
                              text: "-",
                              isActive: serviceRating?.rate == "-",
                            ),
                            RatingButton(
                              onPress: () => setRating("=", participant),
                              text: "=",
                              isActive: serviceRating?.rate == "=",
                            ),
                            RatingButton(
                              onPress: () => setRating("+", participant),
                              text: "+",
                              isActive: serviceRating?.rate == "+",
                            ),
                            RatingButton(
                              onPress: () => setRating("++", participant),
                              text: "++",
                              isActive: serviceRating?.rate == "++",
                            ),
                            RatingButton(
                              onPress: () => setRating("xs", participant),
                              text: "XS",
                              isActive: serviceRating?.rate == "xs",
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
        !tasting.closed ? const Spacer() : Container(),
        FloatingActionButtonCustom(
          backgroundColor: !tasting.closed
              ? MyColors().primaryColor
              : MyColors().lightPrimaryColor,
          textColor:
              !tasting.closed ? MyColors().whiteColor : MyColors().primaryColor,
          elevation: 0,
          onPressed: !tasting.closed ? saveServiceRating : goToHome,
          text: !tasting.closed ? "Enregistrer" : "Fermer",
          isLoading: isLoading,
        ),
      ],
    );
  }

  void saveServiceRating() {
    //Handle update here
    int i = 0;
    setState(() {
      isLoading = true;
    });

    int numberServiceRatingSubmitted = 0;

    serviceRatings.forEach((participant, serviceRating) {
      final String serviceRatingIri = serviceRating.iri ?? "";

      if (serviceRating.rate == null) {
        return;
      }
      numberServiceRatingSubmitted++;

      if (serviceRatingIri.isNotEmpty) {
        ServiceRatingRepository()
            .put(serviceRatingIri, serviceRating.rate ?? 'xs',
                commentsByParticipants[participant]?.text ?? "")
            .then((value) {
          i = i + 1;

          if (numberServiceRatingSubmitted == i) {
            setState(() {
              isLoading = false;
            });
          }
        });

        return;
      }

      ServiceRatingRepository()
          .post(tasting, participant, serviceRating.rate ?? 'xs',
              commentsByParticipants[participant]?.text ?? "")
          .then((value) {
        i = i + 1;

        serviceRating.iri = value.iri;

        if (numberServiceRatingSubmitted == i) {
          setState(() {
            serviceRatings.update(participant, (rating) => serviceRating);
            isLoading = false;
          });
        }
      });
    });
  }

  void setRating(String rating, Participant participant) {
    ServiceRating? serviceRatingParticipant = serviceRatings[participant];

    if (serviceRatingParticipant == null) {
      return;
    }

    serviceRatingParticipant.rate = rating;

    setState(() {
      serviceRatings.update(participant, (rating) => serviceRatingParticipant);
    });
  }

  void setComment(String value, Participant participant) {
    ServiceRating? serviceRatingParticipant = serviceRatings[participant];

    if (serviceRatingParticipant == null) {
      return;
    }

    serviceRatingParticipant.comment = value;

    setState(() {
      serviceRatings.update(participant, (rating) => serviceRatingParticipant);
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
