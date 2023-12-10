import 'package:degust_et_des_couleurs/model/general_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/service_rating.dart';
import 'package:degust_et_des_couleurs/model/sommelier_rating.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/tasting/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_beverages_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_dishes_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_general_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_service_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tab_sommelier_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tasting_header.dart';
import 'package:flutter/material.dart';

class TastingView extends StatefulWidget {
  final Tasting loadedTasting;
  final Map<Participant, ServiceRating> Function(Tasting loadedTasting)
      initializeServiceRatings;
  final Map<Participant, SommelierRating> Function(Tasting loadedTasting)
      initializeSommelierRatings;
  final Map<Participant, GeneralRating> Function(Tasting loadedTasting)
      initializeGeneralRatings;

  const TastingView(
      {super.key,
      required this.loadedTasting,
      required this.initializeServiceRatings,
      required this.initializeSommelierRatings,
      required this.initializeGeneralRatings});

  @override
  State<StatefulWidget> createState() {
    return TastingViewState();
  }
}

class TastingViewState extends State<TastingView> {
  late Tasting loadedTasting;
  late Map<Participant, ServiceRating> Function(Tasting loadedTasting)
      initializeServiceRatings;
  late Map<Participant, SommelierRating> Function(Tasting loadedTasting)
      initializeSommelierRatings;
  late Map<Participant, GeneralRating> Function(Tasting loadedTasting)
      initializeGeneralRatings;

  @override
  void initState() {
    super.initState();

    loadedTasting = widget.loadedTasting;
    initializeServiceRatings = widget.initializeServiceRatings;
    initializeSommelierRatings = widget.initializeSommelierRatings;
    initializeGeneralRatings = widget.initializeGeneralRatings;
  }

  @override
  Widget build(BuildContext context) {
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
                                ? MediaQuery.of(context).size.height * 0.70
                                : MediaQuery.of(context).size.height * 0.67
                            : MediaQuery.of(context).size.height > 680
                                ? MediaQuery.of(context).size.height * 0.67
                                : MediaQuery.of(context).size.height * 0.63,
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
                                serviceRatings:
                                    initializeServiceRatings(loadedTasting)),
                            TabSommelierView(
                                tasting: loadedTasting,
                                participants: loadedTasting.participants,
                                sommelierRatings:
                                    initializeSommelierRatings(loadedTasting)),
                            TabGeneralView(
                                tasting: loadedTasting,
                                participants: loadedTasting.participants,
                                generalRatings:
                                    initializeGeneralRatings(loadedTasting)),
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
  }
}
