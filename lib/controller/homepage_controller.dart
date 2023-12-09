import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
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
      future: TastingRepository().findByName("").onError((error, stackTrace) {
        MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
          return const LoginController();
        });

        Navigator.of(context).push(materialPageRoute);

        throw BadCredentialException();
      }),
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
