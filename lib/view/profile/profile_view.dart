import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/core/auth.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_navigation_bar_bottom.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProfileViewState();
  }
}

class ProfileViewState extends State<ProfileView> {
  String? email;

  @override
  Widget build(BuildContext context) {
    getUsername();

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextDmSans('Profil', fontSize: 20),
            const Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
            ),
            TextDmSans(
              email ?? "",
              fontSize: 16,
              color: MyColors().primaryColor,
            ),
            FloatingActionButtonCustom(
              text: "Se déconnecter",
              onPressed: () {
                Auth().signOut().then((value) {
                  MaterialPageRoute materialPageRoute =
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const LoginController();
                  });

                  Navigator.of(context).push(materialPageRoute);
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavigationBarBottom(
        origin: "profile",
      ),
    );
  }

  Future<void> getUsername() async {
    const storage = FlutterSecureStorage();

    await storage.read(key: "username").then((value) {
      setState(() {
        email = value;
      });
    });
  }
}
