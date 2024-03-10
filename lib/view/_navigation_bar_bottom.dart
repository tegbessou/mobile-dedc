import 'package:degust_et_des_couleurs/controller/friend_controller.dart';
import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/controller/profile_controller.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
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
          icon: getIconContainer(Icons.group_outlined),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: getIconContainer(Icons.account_circle_outlined),
          label: "",
        ),
      ],
      onTap: onTapBottomNavigationBar,
    );
  }

  onTapBottomNavigationBar(int index) async {
    if (index == 2) {
      int id = int.parse(await HttpRepository().getUserId());

      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return ProfileController(id: id);
      });

      Navigator.of(context).push(materialPageRoute);

      return;
    }

    if (index == 1) {
      int userId = int.parse(await HttpRepository().getUserId());

      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return FriendController(userId: userId);
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

    if (origin == 'friend') {
      return 1;
    }

    if (origin == 'profile') {
      return 2;
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
