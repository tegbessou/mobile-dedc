import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/dish_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/tasting/_add_dish_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_dish_card_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_update_dish_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TabDishesView extends StatefulWidget {
  final Tasting tasting;
  final List<Participant> participants;
  final Map<Participant, DishRating> dishRatings;

  const TabDishesView({
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
              body: SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
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

          if (loadedDishes == null) {
            //Put a loader here
            return Scaffold(
              body: Container(),
            );
          }

          return Column(
            children: [
              SizedBox(
                height: !tasting.closed
                    ? MediaQuery.of(context).size.height > 680
                        ? MediaQuery.of(context).size.height > 736
                            ? MediaQuery.of(context).size.height * 0.58
                            : MediaQuery.of(context).size.height * 0.56
                        : MediaQuery.of(context).size.height * 0.55
                    : MediaQuery.of(context).size.height > 680
                        ? MediaQuery.of(context).size.height > 736
                            ? MediaQuery.of(context).size.height * 0.57
                            : MediaQuery.of(context).size.height * 0.52
                        : MediaQuery.of(context).size.height * 0.49,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: loadedDishes.length,
                    itemBuilder: (context, index) {
                      return DishCardView(
                        tasting: tasting,
                        dish: loadedDishes?.elementAt(index),
                        remove: removeDish,
                        update: updateDish,
                      );
                    }),
              ),
              FloatingActionButtonCustom(
                  backgroundColor: !tasting.closed
                      ? MyColors().primaryColor
                      : MyColors().lightPrimaryColor,
                  textColor: !tasting.closed
                      ? MyColors().whiteColor
                      : MyColors().primaryColor,
                  elevation: 0,
                  onPressed: !tasting.closed ? newDish : goToHome,
                  text: !tasting.closed ? "Nouveau plat" : "Fermer"),
            ],
          );
        });
  }

  void loadDishes() async {
    setState(() {
      dishes = DishRepository().findByTasting(tasting);
    });
  }

  void removeDish(Dish? dish) {
    if (dish == null) {
      return;
    }

    String iri = dish.iri;

    DishRepository().delete(iri).then((value) => loadDishes());
  }

  void updateDish(Tasting tasting, Dish? dish) {
    if (dish == null) {
      return;
    }

    Future<void> futureShowModalBottomSheet = showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        builder: (context) {
          return UpdateDishView(
            dish: dish,
            tastingParticipants: tasting.participants,
          );
        });

    futureShowModalBottomSheet.then((void value) => loadDishes());
  }

  void newDish() {
    Future<void> futureShowModalBottomSheet = showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        builder: (context) {
          return AddDishView(
            tasting: tasting,
            tastingParticipants: participants,
          );
        });

    futureShowModalBottomSheet.then((void value) => loadDishes());
  }

  void goToHome() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
      return const HomepageController();
    });

    Navigator.of(context).push(materialPageRoute);
  }
}
