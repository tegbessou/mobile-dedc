import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationBarBottom extends StatefulWidget {
  const NavigationBarBottom({super.key});

  @override
  State<StatefulWidget> createState() {
    return NavigationBarBottomState();
  }
}

class NavigationBarBottomState extends State<NavigationBarBottom> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: MyColors().whiteColor,
      currentIndex: _calculateSelectedIndex(context),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColors().primaryColor,
      items: [
        BottomNavigationBarItem(
          icon: getIconContainer(Icons.home_filled),
          label: ""
          ),
        BottomNavigationBarItem(
          icon: getIconContainer(Icons.restaurant_outlined),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: getIconContainer(Icons.map_outlined),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: getIconContainer(Icons.person_outline),
          label: "",
        ),
      ],
      onTap: onTapBottomNavigationBar,
    );
  }

  onTapBottomNavigationBar(int index) {
    if (index == 3) {
      context.goNamed('profile');

      return;
    }

    context.goNamed('homepage');
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String? location = ModalRoute.of(context)?.settings.name;

    if (location == null) {
      return 0;
    }

    if (location.startsWith('homepage')) {
      return 0;
    }

    if (location.startsWith('profile')) {
      return 3;
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
