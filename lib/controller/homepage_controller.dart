import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_navigation_bar_bottom.dart';
import 'package:degust_et_des_couleurs/view/homepage/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/homepage/homepage_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomepageController extends StatefulWidget {
  const HomepageController({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomepageState();
  }
}

class HomepageState extends State<HomepageController> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tasting>>(
      future: TastingRepository().findByName(""),
      builder: (context, snapshot) {
        List<Tasting>? tastings;

        if (snapshot.hasData) {
          tastings = snapshot.data;
        } else {
          //Put a loader here
          return Scaffold(
            appBar: const AppBarView(),
            body: SizedBox(
              height: MediaQuery.of(context).size.height * 0.90,
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
            bottomNavigationBar: const NavigationBarBottom(
              origin: "homepage",
            ),
          );
        }

        return HomepageView(tastings: tastings);
      },
    );
  }
}
