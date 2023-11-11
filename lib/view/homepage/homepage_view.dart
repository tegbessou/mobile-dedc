import 'package:degust_et_des_couleurs/controller/create_tasting_controller.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    tastings = widget.tastings ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarView(),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.80,
        padding: const EdgeInsets.only(
          top: 15,
          left: 27,
          right: 27,
        ),
        child: Column(children: [
          TextFieldCustom(
            placeholder: "Rechercher une dégustation",
            icon: Icons.search,
            onChanged: (value) => searchTastingByName(value),
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
      ),
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
        icon: const Icon(Icons.add),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
      ),
    );
  }

  Future<void> searchTastingByName(String value) async {
    setState(() {
      isLoading = true;
    });

    if (value.length <= 3) {
      value = "";
    }

    TastingRepository().findByName(value).then((value) {
      setState(() {
        tastings = value;
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }
}
