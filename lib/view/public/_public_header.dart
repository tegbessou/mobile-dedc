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
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height > 680 ? 70 : 0),
      height: MediaQuery.of(context).size.height > 680
          ? MediaQuery.of(context).size.height * 0.33
          : MediaQuery.of(context).size.height * 0.33,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MediaQuery.of(context).size.height > 680
              ? Container()
              : const Spacer(),
          Image.asset(
            "assets/images/logo.png",
            height: MediaQuery.of(context).size.height > 680
                ? MediaQuery.of(context).size.height * 0.16
                : MediaQuery.of(context).size.height * 0.16,
            alignment: Alignment.centerLeft,
          ),
          Container(
            height: MediaQuery.of(context).size.height > 680
                ? MediaQuery.of(context).size.height * 0.17
                : MediaQuery.of(context).size.height * 0.17,
            padding: const EdgeInsets.only(left: 25, right: 25),
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
                MediaQuery.of(context).size.height > 680
                    ? const Padding(
                        padding: EdgeInsets.only(
                          top: 17,
                        ),
                      )
                    : const Spacer(),
                const TextDmSans(
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
      ),
    );
  }
}
