import 'package:degust_et_des_couleurs/model/general_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/model/service_rating.dart';
import 'package:degust_et_des_couleurs/model/sommelier_rating.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/tasting/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_beverages_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_dishes_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_general_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_service_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_sommelier_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tasting_header.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TastingController extends StatefulWidget {
  final int id;

  const TastingController({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return TastingControllerState();
  }
}

class TastingControllerState extends State<TastingController> {
  late int id;
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
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Container(
                  color: MyColors().lightGreyColor,
                  child: Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: MyColors().primaryColor,
                      size: 50,
                    ),
                  ),
                ),
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
              height: MediaQuery.of(context).size.height > 736
                  ? MediaQuery.of(context).size.height * 0.90
                  : MediaQuery.of(context).size.height,
              padding: !loadedTasting.closed
                  ? const EdgeInsets.only(
                      top: 15,
                    )
                  : const EdgeInsets.only(
                      top: 0,
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
                          Material(
                            color: !loadedTasting.closed
                                ? MyColors().whiteColor
                                : MyColors().lightGreyColor,
                            child: TabBar(
                              indicatorColor: MyColors().primaryColor,
                              unselectedLabelColor: MyColors().greyColor,
                              labelColor: MyColors().primaryColor,
                              overlayColor: MaterialStateColor.resolveWith((states) {
                                return MyColors().lightGreyColor;
                              }),
                              isScrollable: true,
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
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: !loadedTasting.closed
                                ? MediaQuery.of(context).size.height > 680
                                    ? MediaQuery.of(context).size.height * 0.70
                                    : MediaQuery.of(context).size.height * 0.67
                                : MediaQuery.of(context).size.height > 680
                                    ? MediaQuery.of(context).size.height * 0.67
                                    : MediaQuery.of(context).size.height * 0.63,
                            decoration: BoxDecoration(
                              color: !loadedTasting.closed
                                  ? MyColors().darkSecondaryColor
                                  : MyColors().lightGreyColor,
                            ),
                            child: SizedBox(
                              height: !loadedTasting.closed
                                  ? MediaQuery.of(context).size.height > 680
                                      ? MediaQuery.of(context).size.height *
                                          0.70
                                      : MediaQuery.of(context).size.height *
                                          0.67
                                  : MediaQuery.of(context).size.height > 680
                                      ? MediaQuery.of(context).size.height *
                                          0.67
                                      : MediaQuery.of(context).size.height *
                                          0.63,
                              child: TabBarView(
                                children: [
                                  TabDishesView(
                                    tasting: loadedTasting,
                                    participants: loadedTasting.participants,
                                    dishRatings: const {},
                                  ),
                                  TabBeveragesView(
                                      tasting: loadedTasting,
                                      participants: loadedTasting.participants,
                                      beverageRatings: const {}),
                                  TabServiceView(
                                      tasting: loadedTasting,
                                      participants: loadedTasting.participants,
                                      serviceRatings: initializeServiceRatings(
                                          loadedTasting)),
                                  TabSommelierView(
                                      tasting: loadedTasting,
                                      participants: loadedTasting.participants,
                                      sommelierRatings:
                                          initializeSommelierRatings(
                                              loadedTasting)),
                                  TabGeneralView(
                                      tasting: loadedTasting,
                                      participants: loadedTasting.participants,
                                      generalRatings: initializeGeneralRatings(
                                          loadedTasting)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: MyColors().whiteColor,
          );
        });
  }

  Map<Participant, ServiceRating> initializeServiceRatings(Tasting tasting) {
    if (tasting.serviceRatings.isEmpty) {
      return {};
    }

    Map<Participant, ServiceRating> serviceRatings = {};

    for (var element in tasting.serviceRatings) {
      Participant participant = tasting.participants.firstWhere(
          (participant) => participant.id == element.participant.id);

      serviceRatings[participant] = element;
    }

    return serviceRatings;
  }

  Map<Participant, SommelierRating> initializeSommelierRatings(
      Tasting tasting) {
    if (tasting.sommelierRatings.isEmpty) {
      return {};
    }

    Map<Participant, SommelierRating> sommelierRatings = {};

    for (var element in tasting.sommelierRatings) {
      Participant participant = tasting.participants.firstWhere(
          (participant) => participant.id == element.participant.id);

      sommelierRatings[participant] = element;
    }

    return sommelierRatings;
  }

  Map<Participant, GeneralRating> initializeGeneralRatings(Tasting tasting) {
    if (tasting.generalRatings.isEmpty) {
      return {};
    }

    Map<Participant, GeneralRating> generalRatings = {};

    for (var element in tasting.generalRatings) {
      Participant participant = tasting.participants.firstWhere(
          (participant) => participant.id == element.participant.id);

      generalRatings[participant] = element;
    }

    return generalRatings;
  }
}
