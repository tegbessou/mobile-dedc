import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/tasting/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_dish_card_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_beverages_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_dishes_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tasting_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TastingController extends StatefulWidget {
  final int? id;
  const TastingController({super.key, this.id});

  @override
  State<StatefulWidget> createState() {
    return TastingControllerState();
  }
}

class TastingControllerState extends State<TastingController> {
  late int? id;
  late Future<Tasting> tasting;
  Restaurant? restaurantSelected;

  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    tasting = TastingRepository().find(id);

    return FutureBuilder(
      future: tasting,
      builder: (BuildContext context, AsyncSnapshot<Tasting> snapshot) {
        Tasting? loadedTasting;

        if (snapshot.hasData) {
          loadedTasting = snapshot.data;
        } else {
          //Put a loader here
          return Scaffold(
              appBar: AppBarView(
                tasting: loadedTasting,
              ),
          );
        }

        if (loadedTasting == null) {
          //Put a loader here
          return Scaffold(
            appBar: AppBarView(
              tasting: loadedTasting,
            ),
          );
        }

        return Scaffold(
          appBar: AppBarView(
            tasting: loadedTasting,
          ),
          body: Container(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: Column(
              children: [
                TastingHeader(
                  tasting: loadedTasting,
                ),
                DefaultTabController(
                  initialIndex: 0,
                  length: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                      TabBar(
                        indicatorColor: MyColors().primaryColor,
                        unselectedLabelColor: MyColors().greyColor,
                        labelColor: MyColors().primaryColor,
                        isScrollable: true,
                        dividerColor: MyColors().blackColor,
                        padding: const EdgeInsets.only(
                          left: 27,
                          right: 27,
                        ),
                        tabs: const [
                          Tab(text: "Plats"),
                          Tab(text: "Boisson"),
                          Tab(text: "Service"),
                          Tab(text: "Sommelier"),
                          Tab(text: "Général"),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: MyColors().darkSecondaryColor,
                        ),
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: 620,
                            child: TabBarView(
                              children: [
                                TabDishesView(
                                  tasting: loadedTasting,
                                  participants: loadedTasting.participants,
                                  dishRatings: {},
                                ),
                                TabBeveragesView(
                                  tasting: loadedTasting,
                                  participants: loadedTasting.participants,
                                  beverageRatings: {}
                                ),
                                Icon(Icons.directions_car),
                                Icon(Icons.directions_car),
                                Icon(Icons.directions_car),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
        );
      }
    );
  }
}
