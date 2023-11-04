import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';

class PublicHeader extends StatefulWidget {
  final String pageName;

  const PublicHeader({super.key, required this.pageName});

  @override
  State<StatefulWidget> createState() {
    return PublicHeaderState();
  }
}

class PublicHeaderState extends State<PublicHeader> {
  late String pageName;

  @override
  void initState() {
    super.initState();
    pageName = widget.pageName;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.only(
              top: 70,
            )
        ),
        Image.asset(
          "assets/images/logo.png",
          height: 130,
          alignment: Alignment.centerLeft,
        ),
        Container(
          padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextDmSans(
                pageName,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 17,
                ),
              ),
              TextDmSans(
                "Bienvenue sur Dégust' et des couleurs !",
                fontSize: 16,
                letterSpacing: 0,
                fontWeight: FontWeight.w100,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
