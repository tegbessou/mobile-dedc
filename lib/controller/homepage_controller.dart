import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/homepage/homepage_loading_view.dart';
import 'package:degust_et_des_couleurs/view/homepage/homepage_view.dart';
import 'package:flutter/material.dart';

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
          return const HomePageLoadingView();
        }

        return HomepageView(tastings: tastings);
      },
    );
  }
}
