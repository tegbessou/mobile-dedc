import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
import 'package:degust_et_des_couleurs/model/user.dart';
import 'package:degust_et_des_couleurs/repository/user_repository.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/friend/_friend_list_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:async/async.dart';

class FriendList extends StatefulWidget {
  final int userId;

  const FriendList({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() {
    return FriendListState();
  }
}

class FriendListState extends State<FriendList> {
  late int userId;
  User? user;
  bool isLoadingRemoveFriend = false;
  late AsyncMemoizer memoizer;

  @override
  void initState() {
    super.initState();

    userId = widget.userId;
    memoizer = AsyncMemoizer();
  }

  Future<User> fetchData() {
    return UserRepository()
        .find(userId, noCache: true)
        .onError((error, stackTrace) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return const LoginController();
      });

      Navigator.of(context).push(materialPageRoute);

      throw BadCredentialException();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: memoizer.runOnce(() {
      return fetchData();
    }), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      User? loadedUser;

      if (snapshot.hasData) {
        loadedUser = snapshot.data;
      } else {
        return const FriendListLoading();
      }

      if (loadedUser == null) {
        return const Scaffold();
      }

      user = loadedUser;

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextDmSans('Mes amis', fontSize: 18),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.33,
            child: user!.friends.isEmpty
                ? TextDmSans(
                    'Vous n\'avez pas d\'ami, vous pouvez en ajouter en cherchant leur pseudo.',
                    fontSize: 14,
                    color: MyColors().greyColor,
                    letterSpacing: 0,
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: user!.friends.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextDmSans(
                            loadedUser!.friends[index].firstName,
                            fontSize: 16,
                            letterSpacing: 0,
                          ),
                          isLoadingRemoveFriend
                              ? LoadingAnimationWidget.inkDrop(
                                  color: MyColors().primaryColor,
                                  size: 18,
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoadingRemoveFriend = true;
                                    });

                                    UserRepository()
                                        .removeFriend(user!.friends[index])
                                        .then((value) {
                                      setState(() {
                                        user!.friends
                                            .remove(user!.friends[index]);
                                        isLoadingRemoveFriend = false;
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: MyColors().primaryColor,
                                  )),
                        ],
                      );
                    }),
          ),
        ],
      );
    });
  }
}
