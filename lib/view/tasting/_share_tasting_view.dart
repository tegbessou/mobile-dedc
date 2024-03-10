import 'package:async/async.dart';
import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/model/user.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/repository/user_repository.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/tasting/_share_tasting_loading.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ShareTastingView extends StatefulWidget {
  final Tasting tasting;

  const ShareTastingView({
    super.key,
    required this.tasting,
  });

  @override
  State<StatefulWidget> createState() {
    return ShareTastingViewState();
  }
}

class ShareTastingViewState extends State<ShareTastingView> {
  TextEditingController friendController = TextEditingController();
  List<User> friendToShare = [];
  late Tasting tasting;
  late AsyncMemoizer memoizer;
  bool isLoadingShared = false;

  @override
  void initState() {
    super.initState();

    memoizer = AsyncMemoizer();
    tasting = widget.tasting;
  }

  Future<User> fetchData() async {
    return UserRepository()
        .find(int.parse(await HttpRepository().getUserId()))
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
        return const ShareTastingLoading();
      }

      if (loadedUser == null) {
        return const Scaffold();
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: MyColors().whiteColor,
        ),
        height: MediaQuery.of(context).size.height > 736
            ? MediaQuery.of(context).size.height * 0.80
            : MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.only(
          left: 27,
          right: 27,
          bottom: 30,
        ),
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.only(
              top: 40,
            )),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextDmSans(
                  "Partager",
                  fontSize: 28,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w800,
                ),
                CircleAvatar(
                  backgroundColor: MyColors().secondaryColor,
                  radius: 16,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: MyColors().blackColor,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
            ),
            TextDmSans(
              "Vous pouvez partager vos dégustations avec vos amis",
              fontSize: 15,
              letterSpacing: 0,
              color: MyColors().greyColor,
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: loadedUser.friends.length,
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
                        isLoadingShared
                            ? LoadingAnimationWidget.inkDrop(
                                color: MyColors().primaryColor,
                                size: 18,
                              )
                            : !tasting.sharedWithUsers
                                    .contains(loadedUser.friends[index].iri)
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isLoadingShared = true;
                                      });

                                      TastingRepository()
                                          .share(tasting,
                                              loadedUser!.friends[index])
                                          .then((value) {
                                        setState(() {
                                          tasting.sharedWithUsers
                                              .add(loadedUser!.iri);
                                          isLoadingShared = false;
                                        });
                                      });
                                    },
                                    icon: Icon(
                                      Icons.file_download_outlined,
                                      size: 18,
                                      color: MyColors().primaryColor,
                                    ))
                                : IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.check,
                                      size: 18,
                                      color: MyColors().primaryColor,
                                    )),
                      ],
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }
}
