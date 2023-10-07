import 'dart:ffi';

import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/dish_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/tasting/_add_dish_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_dish_card_view.dart';
import 'package:flutter/material.dart';

class TabDishesView extends StatefulWidget {
  Tasting tasting;
  List<Participant> participants;
  Map<Participant, DishRating> dishRatings;

  TabDishesView({
    super.key,
    required this.tasting,
    required this.participants,
    required this.dishRatings,
  });

  @override
  State<StatefulWidget> createState() {
    return TabDishesViewState();
  }
}

class TabDishesViewState extends State<TabDishesView> {
  late Tasting tasting;
  late Future<List<Dish>> dishes;
  late List<Participant> participants;
  late Map<Participant, DishRating> dishRatings;

  @override
  void initState() {
    super.initState();

    tasting = widget.tasting;
    participants = widget.participants;
    dishRatings = widget.dishRatings;
  }

  @override
  Widget build(BuildContext context) {
    dishes = DishRepository().findByTasting(tasting);

    return FutureBuilder(
        future: dishes,
        builder: (BuildContext context, AsyncSnapshot<List<Dish>> snapshot) {
          List<Dish>? loadedDishes = [];

          if (snapshot.hasData) {
            loadedDishes = snapshot.data;
          } else {
            //Put a loader here
            return Scaffold(
              body: Container(),
            );
          }

          if (loadedDishes == null) {
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
                      itemCount: loadedDishes.length,
                      itemBuilder: (context, index) {
                        return DishCardView(
                          dish: loadedDishes?.elementAt(index),
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
                          return AddDishView(tasting: tasting,
                              tastingParticipants: participants,
                              dishRatingParticipants: {});
                        }
                    );

                    futureShowModalBottomSheet.then((void value) => loadDishes());
                  },
                  text: "Nouveau plat"
              ),
            ],
          ),
        );
      }
    );
  }

  void loadDishes() async {
    setState(() {
      dishes = DishRepository().findByTasting(tasting);
    });
  }
}