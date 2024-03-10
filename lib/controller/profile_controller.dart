import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
import 'package:degust_et_des_couleurs/model/user.dart';
import 'package:degust_et_des_couleurs/repository/user_repository.dart';
import 'package:degust_et_des_couleurs/view/profile/profile_view.dart';
import 'package:degust_et_des_couleurs/view/profile/user_loading_view.dart';
import 'package:flutter/material.dart';

class ProfileController extends StatefulWidget {
  final int id;

  const ProfileController({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return ProfilerControllerState();
  }
}

class ProfilerControllerState extends State<ProfileController> {
  late int id;

  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserRepository().find(id).onError((error, stackTrace) {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext context) {
            return const LoginController();
          });

          Navigator.of(context).push(materialPageRoute);

          throw BadCredentialException();
        }),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          User? user;

          if (snapshot.hasData) {
            user = snapshot.data;
          } else {
            return const UserLoadingView();
          }

          if (user == null) {
            return const Scaffold();
          }

          return ProfileView(
            user: user,
          );
        });
  }
}
