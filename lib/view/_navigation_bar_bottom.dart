import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/controller/profile_controller.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';

class NavigationBarBottom extends StatefulWidget {
  final String origin;

  const NavigationBarBottom({
    super.key,
    required this.origin,
  });

  @override
  State<StatefulWidget> createState() {
    return NavigationBarBottomState();
  }
}

class NavigationBarBottomState extends State<NavigationBarBottom> {
  late String origin;

  @override
  void initState() {
    super.initState();

    origin = widget.origin;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: MyColors().whiteColor,
      currentIndex: _calculateSelectedIndex(context),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColors().primaryColor,
      items: [
        BottomNavigationBarItem(
            icon: getIconContainer(Icons.home_filled), label: ""),
        BottomNavigationBarItem(
          icon: getIconContainer(Icons.person_outline),
          label: "",
        ),
      ],
      onTap: onTapBottomNavigationBar,
    );
  }

  onTapBottomNavigationBar(int index) {
    if (index == 1) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return const ProfileController();
      });

      Navigator.of(context).push(materialPageRoute);

      return;
    }

    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
      return const HomepageController();
    });

    Navigator.of(context).push(materialPageRoute);
  }

  int _calculateSelectedIndex(BuildContext context) {
    if (origin == 'homepage') {
      return 0;
    }

    if (origin == 'profile') {
      return 1;
    }

    return 0;
  }

  Container getIconContainer(IconData icon) {
    return Container(
      height: 10,
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Icon(icon),
    );
  }
}
