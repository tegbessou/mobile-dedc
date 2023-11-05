import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/model/beverage.dart';
import 'package:degust_et_des_couleurs/model/beverage_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/beverage_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/tasting/_add_beverage_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_beverage_card_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_update_beverage_view.dart';
import 'package:flutter/material.dart';

class TabBeveragesView extends StatefulWidget {
  Tasting tasting;
  List<Participant> participants;
  Map<Participant, BeverageRating> beverageRatings;

  TabBeveragesView({
    super.key,
    required this.tasting,
    required this.participants,
    required this.beverageRatings,
  });

  @override
  State<StatefulWidget> createState() {
    return TabBeveragesViewState();
  }
}

class TabBeveragesViewState extends State<TabBeveragesView> {
  late Tasting tasting;
  late Future<List<Beverage>> beverages;
  late List<Participant> participants;
  late Map<Participant, BeverageRating> beverageRatings;

  @override
  void initState() {
    super.initState();

    tasting = widget.tasting;
    participants = widget.participants;
    beverageRatings = widget.beverageRatings;
  }

  @override
  Widget build(BuildContext context) {
    beverages = BeverageRepository().findByTasting(tasting);

    return FutureBuilder(
        future: beverages,
        builder: (BuildContext context, AsyncSnapshot<List<Beverage>> snapshot) {
          List<Beverage>? loadedBeverages = [];

          if (snapshot.hasData) {
            loadedBeverages = snapshot.data;
          } else {
            //Put a loader here
            return Scaffold(
              body: Container(),
            );
          }

          if (loadedBeverages == null) {
            //Put a loader here
            return Scaffold(
              body: Container(),
            );
          }

           return Column(
             children: [
               SizedBox(
                 height: !tasting.closed ? MediaQuery.of(context).size.height - 350: MediaQuery.of(context).size.height - 400,
                 child: ListView.builder(
                 scrollDirection: Axis.vertical,
                 itemCount: loadedBeverages.length,
                 itemBuilder: (context, index) {
                   return BeverageCardView(
                     tasting: tasting,
                     beverage: loadedBeverages?.elementAt(index),
                     remove: removeBeverage,
                     update: updateBeverage,
                   );
                 }
             ),
           ),
           FloatingActionButtonCustom(
             backgroundColor: !tasting.closed ? MyColors().primaryColor : MyColors().lightPrimaryColor,
             textColor: !tasting.closed ? MyColors().whiteColor : MyColors().primaryColor,
             elevation: 0,
             onPressed: !tasting.closed ? newBeverage : goToHome,
             text: !tasting.closed ? "Nouvelle boisson" : "Fermer"
           ),
            ],
          );
      }
    );
  }

  void loadBeverage() async {
    setState(() {
      beverages = BeverageRepository().findByTasting(tasting);
    });
  }

  void removeBeverage(Beverage? beverage) {
    if (beverage == null) {
      return;
    }

    String iri = beverage.iri;

    BeverageRepository().delete(iri).then((value) => loadBeverage());
  }

  void updateBeverage(Tasting tasting, Beverage? beverage) {
    if (beverage == null) {
      return;
    }

    Future<
        void> futureShowModalBottomSheet = showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        builder: (context) {
          return UpdateBeverageView(
            beverage: beverage,
            tastingParticipants: tasting.participants,
          );
        }
    );

    futureShowModalBottomSheet.then((void value) => loadBeverage());
  }

  void newBeverage() {
    Future<
        void> futureShowModalBottomSheet = showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        builder: (context) {
          return AddBeverageView(
              tasting: tasting,
              tastingParticipants: participants,
              beverageRatingParticipants: {}
          );
        }
    );

    futureShowModalBottomSheet.then((void value) => loadBeverage());
  }

  void goToHome() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context) {
      return HomepageController();
    });

    Navigator.of(context).push(materialPageRoute);
  }
}