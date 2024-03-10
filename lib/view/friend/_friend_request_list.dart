import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
import 'package:degust_et_des_couleurs/model/friend_request.dart';
import 'package:degust_et_des_couleurs/repository/friend_request_repository.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/friend/_friend_request_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:async/async.dart';

class FriendRequestList extends StatefulWidget {
  const FriendRequestList({super.key});

  @override
  State<StatefulWidget> createState() {
    return FriendRequestListState();
  }
}

class FriendRequestListState extends State<FriendRequestList> {
  bool isLoadingAccept = false;
  bool isLoadingDecline = false;
  late AsyncMemoizer memoizer;

  @override
  void initState() {
    super.initState();

    memoizer = AsyncMemoizer();
  }

  Future<List<FriendRequest>> fetchData() {
    return FriendRequestRepository()
        .getAllForCurrentUser()
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
      List<FriendRequest>? friendRequests = [];

      if (snapshot.hasData) {
        friendRequests = snapshot.data;
      } else {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.13,
          child: const FriendRequestLoadingView(),
        );
      }

      friendRequests ??= [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextDmSans(
            'Demande en attente',
            fontSize: 18,
            align: TextAlign.start,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Container(
            child: friendRequests.isEmpty
                ? TextDmSans(
                    'Vous n\'avez pas de demande d\'ami en attente.',
                    fontSize: 14,
                    color: MyColors().greyColor,
                    letterSpacing: 0,
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.13,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: friendRequests.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextDmSans(
                                friendRequests?[index].source.firstName ?? "",
                                fontSize: 16,
                                letterSpacing: 0,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  if (friendRequests == null) {
                                    return;
                                  }

                                  setState(() {
                                    isLoadingAccept = true;
                                  });

                                  FriendRequestRepository()
                                      .accept(friendRequests[index])
                                      .then((value) {
                                    setState(() {
                                      friendRequests!
                                          .remove(friendRequests[index]);
                                      isLoadingAccept = false;
                                    });
                                  });
                                },
                                icon: Icon(
                                  Icons.done,
                                  size: 18,
                                  color: MyColors().primaryColor,
                                ),
                              ),
                              isLoadingDecline
                                  ? LoadingAnimationWidget.inkDrop(
                                      color: MyColors().primaryColor,
                                      size: 18,
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        if (friendRequests == null) {
                                          return;
                                        }

                                        setState(() {
                                          isLoadingDecline = true;
                                        });

                                        FriendRequestRepository()
                                            .decline(friendRequests[index])
                                            .then((value) {
                                          setState(() {
                                            friendRequests!
                                                .remove(friendRequests[index]);
                                            isLoadingDecline = false;
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        size: 18,
                                        color: MyColors().primaryColor,
                                      ),
                                    ),
                            ],
                          );
                        }),
                  ),
          ),
        ],
      );
    });
  }
}
