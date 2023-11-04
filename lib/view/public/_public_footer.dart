import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class PublicFooter extends StatefulWidget {
  final String firstSentence;
  final String secondSentence;
  final void Function() redirectTo;

  const PublicFooter({super.key, required this.firstSentence, required this.secondSentence, required this.redirectTo });

  @override
  State<StatefulWidget> createState() {
    return PublicFooterState();
  }
}

class PublicFooterState extends State<PublicFooter> {
  late String firstSentence;
  late String secondSentence;
  late Function() redirectTo;

  @override
  void initState() {
    super.initState();
    firstSentence = widget.firstSentence;
    secondSentence = widget.secondSentence;
    redirectTo = widget.redirectTo;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
          onPressed: redirectTo,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextDmSans(
                firstSentence,
                fontSize: 16,
                letterSpacing: 0,
              ),
              TextDmSans(
                secondSentence,
                fontSize: 16,
                letterSpacing: 0,
                color: MyColors().primaryColor,
              ),
            ],
          )
        )
      ],
    );
  }
}