import 'package:degust_et_des_couleurs/controller/create_tasting_controller.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_navigation_bar_bottom.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/_text_field_custom.dart';
import 'package:degust_et_des_couleurs/view/homepage/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/homepage/_tasting_card_view.dart';
import 'package:flutter/material.dart';

class HomepageView extends StatelessWidget {
  HomepageView({
    super.key,
    required this.tastings,
  });

  List<Tasting> tastings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 15,
            left: 27,
            right: 27,
          ),
          child: Column(
            children: [
              TextFieldCustom(
                placeholder: "Rechercher une dégustation",
                icon: Icons.search,
              ),
              SizedBox(
                height: 600,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: tastings.length,
                  itemBuilder: (context, index) {
                    return TastingCardView(
                      tasting: tastings[index],
                    );
                  }
                ),
              ),
            ]),
        ),
      ),
      backgroundColor: MyColors().lightWhiteColor,
      bottomNavigationBar: const NavigationBarBottom(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context) {
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
          borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
      ),
    );
  }
}
