import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ShareTastingLoading extends StatelessWidget {
  const ShareTastingLoading({super.key});

  @override
  Widget build(BuildContext context) {
    //Put a loader here
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: MyColors().whiteColor,
      ),
      height: MediaQuery.of(context).size.height > 736
          ? MediaQuery.of(context).size.height * 0.80
          : MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.only(
        left: 27,
        right: 27,
        bottom: 30,
      ),
      child: Column(
        children: [
          const Padding(
              padding: EdgeInsets.only(
            top: 40,
          )),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextDmSans(
                "Partager",
                fontSize: 28,
                letterSpacing: 0,
                fontWeight: FontWeight.w800,
              ),
              CircleAvatar(
                backgroundColor: MyColors().secondaryColor,
                radius: 16,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    size: 16,
                    color: MyColors().blackColor,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
          ),
          const Spacer(),
          LoadingAnimationWidget.inkDrop(
            color: MyColors().primaryColor,
            size: 50,
          ),
        ],
      ),
    );
  }
}
