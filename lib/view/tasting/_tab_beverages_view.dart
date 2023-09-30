import 'dart:ffi';

import 'package:degust_et_des_couleurs/model/beverage.dart';
import 'package:degust_et_des_couleurs/model/beverage_rating.dart';
import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/beverage_repository.dart';
import 'package:degust_et_des_couleurs/repository/dish_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/create_tasting/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_add_beverage_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_add_dish_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_beverage_card_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_dish_card_view.dart';
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

           return Container(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: SizedBox(
                      height: 540,
                      child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: loadedBeverages.length,
                      itemBuilder: (context, index) {
                        return BeverageCardView(
                          beverage: loadedBeverages?.elementAt(index),
                        );
                      }
                  ),
                ),
              ),
              FloatingActionButtonCustom(
                onPressed: () {
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
                },
                text: "Nouvelle boisson"
              ),
            ],
          ),
        );
      }
    );
  }

  void loadBeverage() async {
    setState(() {
      beverages = BeverageRepository().findByTasting(tasting);
    });
  }
}