import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/core/auth.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WidgetTreeState();
  }

}

class WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomepageController();
        } else {
          return LoginController();
        }
      }
    );
  }

}