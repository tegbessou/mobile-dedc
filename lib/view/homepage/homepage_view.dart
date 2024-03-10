import 'package:degust_et_des_couleurs/controller/create_tasting_controller.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_navigation_bar_bottom.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:degust_et_des_couleurs/view/homepage/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/homepage/_tasting_card_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomepageView extends StatefulWidget {
  final List<Tasting>? tastings;

  const HomepageView({
    super.key,
    required this.tastings,
  });

  @override
  State<StatefulWidget> createState() {
    return HomepageViewState();
  }
}

class HomepageViewState extends State<HomepageView> {
  late List<Tasting> tastings;
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  bool seeOnlyShared = false;
  late int userId;

  @override
  void initState() {
    super.initState();

    tastings = widget.tastings ?? [];
    setUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarView(),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.only(
          top: 15,
          left: 27,
          right: 27,
        ),
        child: Column(children: [
          TextFieldCustom(
            placeholder: "Rechercher une dégustation",
            icon: Icons.search,
            onChanged: (value) => searchTastingByName(value, seeOnlyShared),
            controller: nameController,
          ),
          Row(
            children: [
              Switch(
                  value: seeOnlyShared,
                  activeColor: MyColors().primaryColor,
                  inactiveThumbColor: MyColors().greyColor,
                  inactiveTrackColor: MyColors().lightGreyColor,
                  onChanged: (value) {
                    setState(() {
                      seeOnlyShared = value;
                    });
                    searchTastingByName(nameController.text, seeOnlyShared);
                  }),
              TextDmSans(
                'Afficher les dégustations partagées',
                fontSize: 13,
                letterSpacing: 0,
                color: MyColors().blackColor,
              ),
            ],
          ),
          !isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: tastings.length,
                      itemBuilder: (context, index) {
                        return TastingCardView(
                          tasting: tastings[index],
                          userId: userId,
                          delete: delete,
                        );
                      }),
                )
              : Expanded(
                  child: LoadingAnimationWidget.inkDrop(
                    color: MyColors().primaryColor,
                    size: 50,
                  ),
                ),
        ]),
      )),
      backgroundColor: MyColors().lightWhiteColor,
      bottomNavigationBar: const NavigationBarBottom(
        origin: "homepage",
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext context) {
            return const CreateTastingController();
          });

          Navigator.of(context).push(materialPageRoute);
        },
        label: TextDmSans(
          "Ajouter",
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
          color: MyColors().whiteColor,
        ),
        backgroundColor: MyColors().primaryColor,
        icon: Icon(
          Icons.add,
          color: MyColors().whiteColor,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
      ),
    );
  }

  Future<void> searchTastingByName(String value, bool seeShared) async {
    setState(() {
      isLoading = true;
    });

    if (value.length <= 3) {
      value = "";
    }

    TastingRepository().findByName(value, seeShared).then((value) {
      setState(() {
        tastings = value;
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> delete(Tasting tasting) async {
    setState(() {
      isLoading = true;
    });

    TastingRepository().delete(tasting).then((value) {
      setState(() {
        tastings.remove(tasting);
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  void setUserId() async {
    int userIdLoaded = int.parse(await HttpRepository().getUserId());

    setState(() {
      userId = userIdLoaded;
    });
  }
}
