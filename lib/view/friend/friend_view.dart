import 'package:degust_et_des_couleurs/model/user.dart';
import 'package:degust_et_des_couleurs/repository/friend_request_repository.dart';
import 'package:degust_et_des_couleurs/repository/user_repository.dart';
import 'package:degust_et_des_couleurs/view/_autocomplete_field_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_navigation_bar_bottom.dart';
import 'package:degust_et_des_couleurs/view/_small_elevated_button.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/friend/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/friend/_friend_list.dart';
import 'package:degust_et_des_couleurs/view/friend/_friend_request_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FriendView extends StatefulWidget {
  final int userId;

  const FriendView({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() {
    return FriendViewState();
  }
}

class FriendViewState extends State<FriendView> {
  late int userId;
  final TextEditingController friendSearchController = TextEditingController();
  bool isLoading = false;
  late FToast fToast;

  final List<String> friends = [
    'Hugues',
    'Stéphanie',
    'Ronan',
    'Pedro',
    'Alex',
    'Cécile',
    'Lucas',
    'Céline',
  ];
  final List<String> friendRequests = [
    'Hugues',
    'Lucas',
    'Céline',
  ];

  @override
  void initState() {
    super.initState();

    userId = widget.userId;

    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarView(),
      backgroundColor: MyColors().lightWhiteColor,
      body: SingleChildScrollView(
          child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        child: Container(
          padding: const EdgeInsets.only(
            top: 15,
            left: 27,
            right: 27,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AutocompleteFieldCustom(
              controller: friendSearchController,
              autofocus: false,
              placeholder: "Rechercher des amis",
              suggestionsCallback: (pattern) async {
                if (pattern.length < 3) {
                  return [];
                }

                return await UserRepository()
                    .findByPseudo(pattern)
                    .then((value) {
                  List<User> filteredUsers = [];

                  for (var user in value) {
                    if (user.id == userId) {
                      continue;
                    }

                    filteredUsers.add(user);
                  }

                  return filteredUsers;
                });
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.pseudo),
                  trailing: isLoading
                      ? LoadingAnimationWidget.inkDrop(
                          color: MyColors().primaryColor, size: 18)
                      : SmallElevatedButton(
                          text: "Ajouter",
                          onPress: null,
                          backgroundColor: MyColors().primaryColor,
                          color: MyColors().whiteColor,
                        ),
                );
              },
              onSuggestionSelected: (selection) {
                setState(() {
                  isLoading = true;
                });

                FriendRequestRepository().post(selection).then((value) {
                  setState(() {
                    isLoading = false;
                  });

                  fToast.showToast(
                    child: createAddFriendToast('Demande d\'ami envoyée'),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: const Duration(seconds: 2),
                  );
                }).catchError((error) {
                  setState(() {
                    isLoading = false;
                  });

                  fToast.showToast(
                    child: createAddFriendToast(
                        'Vous êtes déjà amis avec cette personne'),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: const Duration(seconds: 2),
                  );
                });
              },
              prefixIcon: Icons.person_add_alt_1_outlined,
              prefixIconColor: MyColors().primaryColor,
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.38,
              child: FriendList(
                userId: userId,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
              child: const FriendRequestList(),
            ),
          ]),
        ),
      )),
      bottomNavigationBar: const NavigationBarBottom(
        origin: "friend",
      ),
    );
  }

  Widget createAddFriendToast(
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: MyColors().primaryColor,
      ),
      child: Center(
        child: TextDmSans(
          text,
          fontSize: 14,
          letterSpacing: 0,
          color: MyColors().whiteColor,
        ),
      ),
    );
  }
}
