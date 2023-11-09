import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/sommelier_rating.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/sommelier_rating_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_rating_button.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:flutter/material.dart';

class TabSommelierView extends StatefulWidget {
  Tasting tasting;
  List<Participant> participants;
  Map<Participant, SommelierRating> sommelierRatings;

  TabSommelierView({
    super.key,
    required this.tasting,
    required this.participants,
    required this.sommelierRatings,
  });

  @override
  State<StatefulWidget> createState() {
    return TabSommelierViewState();
  }
}

class TabSommelierViewState extends State<TabSommelierView> {
  late Tasting tasting;
  late List<Participant> participants;
  late Map<Participant, SommelierRating> sommelierRatings;
  late Map<Participant, TextEditingController> commentsByParticipants;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    tasting = widget.tasting;
    participants = widget.participants;
    Map<Participant, TextEditingController> commentsByParticipantsInitialize = {};

    if (widget.sommelierRatings.length != widget.participants.length) {
      sommelierRatings = widget.sommelierRatings;
      for (var element in widget.participants) {
        if (widget.sommelierRatings.containsKey(element)) {
          continue;
        }

        sommelierRatings[element] = SommelierRating(participant: element);
        commentsByParticipantsInitialize[element] = TextEditingController();
      }
      commentsByParticipants = commentsByParticipantsInitialize;

      return;
    }

    for (var element in widget.participants) {
      commentsByParticipantsInitialize[element] = TextEditingController(text: widget.sommelierRatings[element]?.comment);
    }

    sommelierRatings = widget.sommelierRatings;
    commentsByParticipants = commentsByParticipantsInitialize;
  }

  @override
  Widget build(BuildContext context) {
     return Column(
         children: [
           SizedBox(
             height: MediaQuery.of(context).size.height > 680
                 ? MediaQuery.of(context).size.height * 0.57
                 : MediaQuery.of(context).size.height * 0.51,
             child: ListView.builder(
             scrollDirection: Axis.vertical,
             itemCount: sommelierRatings.length,
             itemBuilder: (context, index) {
               var participant = participants[index];
               final sommelierRating = sommelierRatings[participant];

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
                           )
                       ),
                       Row(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           RatingButton(
                             onPress: () => setRating("--", participant),
                             text: "--",
                             isActive: sommelierRating?.rate == "--",
                           ),
                           RatingButton(
                             onPress: () => setRating("-", participant),
                             text: "-",
                             isActive: sommelierRating?.rate == "-",
                           ),
                           RatingButton(
                             onPress: () => setRating("=", participant),
                             text: "=",
                             isActive: sommelierRating?.rate == "=",
                           ),
                           RatingButton(
                             onPress: () => setRating("+", participant),
                             text: "+",
                             isActive: sommelierRating?.rate == "+",
                           ),
                           RatingButton(
                             onPress: () => setRating("++", participant),
                             text: "++",
                             isActive: sommelierRating?.rate == "++",
                           ),
                           RatingButton(
                             onPress: () => setRating("xs", participant),
                             text: "XS",
                             isActive: sommelierRating?.rate == "xs",
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
                         controller: commentsByParticipants[participant],
                         icon: Icons.mode_comment_outlined,
                         iconColor: MyColors().primaryColor,
                         onChanged: (value) => setComment(value, participant),
                       ),
                       Padding(
                           padding: EdgeInsets.only(
                             bottom: index + 1 == participants.length ? 0 : 20,
                           )
                       ),
                     ],
                   ),
               ),
             );
             }
         ),
       ),
       !tasting.closed ? const Spacer() : Container(),
       FloatingActionButtonCustom(
         backgroundColor: !tasting.closed ? MyColors().primaryColor : MyColors().lightPrimaryColor,
         textColor: !tasting.closed ? MyColors().whiteColor : MyColors().primaryColor,
         elevation: 0,
         onPressed: !tasting.closed ? saveSommelierRating : goToHome,
         text: !tasting.closed ? "Enregistrer" : "Fermer",
         isLoading: isLoading,
       ),
     ],
      );
  }

  void saveSommelierRating() {
    //Handle update here
    int i = 0;
    setState(() {
      isLoading = true;
    });

    int numberSommelierRatingSubmitted = 0;

    sommelierRatings.forEach((participant, sommelierRating) {
      final String sommelierRatingIri = sommelierRating.iri ?? "";

      if (sommelierRating.rate == null) {
        return;
      }
      numberSommelierRatingSubmitted++;

      if (sommelierRatingIri.isNotEmpty) {
        SommelierRatingRepository().put(sommelierRatingIri, sommelierRating.rate ?? 'xs', commentsByParticipants[participant]?.text ?? "").then((value) {
          i = i + 1;

          if (numberSommelierRatingSubmitted == i) {
            setState(() {
              isLoading = false;
            });
          }
        })
        ;

        return;
      }

      SommelierRatingRepository().post(tasting, participant, sommelierRating.rate ?? 'xs', commentsByParticipants[participant]?.text ?? "")
        .then((value) {
          i = i + 1;

          sommelierRating.iri = value.iri;

          if (numberSommelierRatingSubmitted == i) {
            setState(() {
              sommelierRatings.update(participant, (rating) => sommelierRating);
              isLoading = false;
            });
          }
        })
      ;
    });
  }

  void setRating(String rating, Participant participant) {
    SommelierRating? sommelierRatingParticipant = sommelierRatings[participant];

    if (sommelierRatingParticipant == null) {
      return;
    }

    sommelierRatingParticipant.rate = rating;

    setState(() {
      sommelierRatings.update(participant, (rating) => sommelierRatingParticipant);
    });
  }

  void setComment(String value, Participant participant) {
    SommelierRating? sommelierRatingParticipant = sommelierRatings[participant];

    if (sommelierRatingParticipant == null) {
      return;
    }

    sommelierRatingParticipant.comment = value;

    setState(() {
      sommelierRatings.update(participant, (rating) => sommelierRatingParticipant);
    });
  }

  void goToHome() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context) {
      return HomepageController();
    });

    Navigator.of(context).push(materialPageRoute);
  }
}