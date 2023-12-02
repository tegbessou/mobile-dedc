import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_navigation_bar_bottom.dart';
import 'package:degust_et_des_couleurs/view/homepage/_app_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePageLoadingView extends StatelessWidget {
  const HomePageLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
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
}
