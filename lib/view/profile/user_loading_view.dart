import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserLoadingView extends StatelessWidget {
  const UserLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
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
}
