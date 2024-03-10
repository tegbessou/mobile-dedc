import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FriendRequestLoadingView extends StatelessWidget {
  const FriendRequestLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    //Put a loader here
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextDmSans(
          'Demande en attente',
          fontSize: 18,
          align: TextAlign.start,
        ),
        const Spacer(),
        Center(
          child: LoadingAnimationWidget.inkDrop(
            color: MyColors().primaryColor,
            size: 50,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
