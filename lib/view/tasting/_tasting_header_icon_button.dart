import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TastingHeaderIconButton extends StatelessWidget {
  final void Function() onPress;
  final IconData icon;
  final bool isLoading;

  const TastingHeaderIconButton({
    super.key,
    required this.onPress,
    required this.icon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: MyColors().secondaryColor),
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: getButtonContent(),
    );
  }

  Widget getButtonContent() {
    if (isLoading) {
      return LoadingAnimationWidget.inkDrop(
        color: MyColors().whiteColor,
        size: 20,
      );
    }

    return IconButton(
      onPressed: onPress,
      icon: Icon(icon),
    );
  }
}