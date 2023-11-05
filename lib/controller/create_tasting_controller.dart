import 'package:degust_et_des_couleurs/controller/create_tasting_add_participant_controller.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/restaurant_repository.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/_autocomplete_field_custom.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_form_field_custom.dart';
import 'package:degust_et_des_couleurs/view/create_tasting/_app_bar_view.dart';
import 'package:flutter/material.dart';

class CreateTastingController extends StatefulWidget {
  const CreateTastingController({super.key});

  @override
  State<StatefulWidget> createState() {
    return CreateTastingControllerState();
  }
}

class CreateTastingControllerState extends State<CreateTastingController> {
  Restaurant? restaurantSelected;
  Tasting? createdTasting;
  final TextEditingController restaurantController = TextEditingController();
  final TextEditingController tastingNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? errorMessageRestaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(),
      body: Container(
        padding: const EdgeInsets.only(
          top: 15,
          left: 27,
          right: 27,
        ),
        child: Form(
          key: _formKey,
          child: Column(children: [
            AutocompleteFieldCustom(
              controller: restaurantController,
              onValidate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le restaurant est obligatoire';
                }

                return null;
              },
              placeholder: "Restaurant",
              suggestionsCallback: (pattern) async {
                return await RestaurantRepository().findByName(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                );
              },
              onSuggestionSelected: (selection) {
                restaurantSelected = selection;
                restaurantController.text = selection.name;
              },
              prefixIcon: Icons.restaurant_outlined,
              prefixIconColor: MyColors().primaryColor,
            ),
            const Padding(
                padding: EdgeInsets.only(
              top: 20,
            )),
            TextFormFieldCustom(
                placeholder: "Nom de la degustation",
                icon: Icons.mode_comment_outlined,
                iconColor: MyColors().primaryColor,
                controller: tastingNameController,
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom de la dégustation est obligatoire';
                  }
                  return null;
                }),
          ]),
        ),
      ),
      backgroundColor: MyColors().whiteColor,
      floatingActionButton: FloatingActionButtonCustom(
        text: "Continuer",
        onPressed: createTasting,
        isLoading: isLoading,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void createTasting() async {
    if (createdTasting != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return CreateTastingAddParticipantController(tasting: createdTasting);
      });

      Navigator.of(context).push(materialPageRoute);

      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Tasting tasting = await TastingRepository()
          .post(tastingNameController.text, restaurantSelected);

      setState(() {
        createdTasting = tasting;
        isLoading = false;
      });

      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return CreateTastingAddParticipantController(tasting: createdTasting);
      });

      Navigator.of(context).push(materialPageRoute);
    }
  }
}
