import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/core/auth.dart';
import 'package:degust_et_des_couleurs/model/user.dart';
import 'package:degust_et_des_couleurs/repository/user_repository.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_navigation_bar_bottom.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileView extends StatefulWidget {
  final User user;

  const ProfileView({super.key, required this.user});

  @override
  State<StatefulWidget> createState() {
    return ProfileViewState();
  }
}

class ProfileViewState extends State<ProfileView> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().whiteColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextDmSans('Bienvenue ${user.firstName},', fontSize: 20),
              const Padding(
                padding: EdgeInsets.only(
                  top: 10,
                ),
              ),
              const TextDmSans(
                'Voici les informations de ton profil.',
                fontSize: 14,
                letterSpacing: 0,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 20,
                ),
              ),
              TextDmSans(
                user.username,
                fontSize: 16,
                color: MyColors().primaryColor,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 10,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton.icon(
                    label: Icon(
                      Icons.copy,
                      size: 14,
                      color: MyColors().greyColor,
                    ),
                    icon: TextDmSans(
                      user.pseudo,
                      fontSize: 14,
                      color: MyColors().blackColor,
                    ),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: user.pseudo));
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => MyColors().lightGreyColor),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: delete,
                child: const TextDmSans(
                  "Supprimer mon compte (cette action est définitive)",
                  fontSize: 12,
                  letterSpacing: 0,
                  align: TextAlign.center,
                ),
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
      ),
      bottomNavigationBar: const NavigationBarBottom(
        origin: "profile",
      ),
    );
  }

  Future<void> delete() async {
    UserRepository().delete().then((value) {
      Auth().signOut();

      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return const LoginController();
      });

      Navigator.of(context).push(materialPageRoute);
    });
  }
}
