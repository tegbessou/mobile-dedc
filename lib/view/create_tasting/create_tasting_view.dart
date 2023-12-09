import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/repository/restaurant_repository.dart';
import 'package:degust_et_des_couleurs/view/_autocomplete_field_custom.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_form_field_custom.dart';
import 'package:degust_et_des_couleurs/view/create_tasting/_app_bar_view.dart';
import 'package:flutter/material.dart';

class CreateTastingView extends StatefulWidget {
  final TextEditingController restaurantController;
  final TextEditingController tastingNameController;
  final Restaurant? restaurantSelected;
  final bool isLoading;
  final void Function(Restaurant restaurant) createTasting;
  final GlobalKey formKey;

  const CreateTastingView({
    super.key,
    required this.restaurantController,
    required this.tastingNameController,
    this.restaurantSelected,
    required this.isLoading,
    required this.createTasting, required this.formKey,
  });

  @override
  State<StatefulWidget> createState() {
    return CreateTastingViewState();
  }
}

class CreateTastingViewState extends State<CreateTastingView> {
  late TextEditingController restaurantController;
  late TextEditingController tastingNameController;
  late Restaurant? restaurantSelected;
  late bool isLoading;
  late void Function(Restaurant restaurant) createTasting;
  late GlobalKey formKey;

  @override
  void initState() {
    super.initState();

    restaurantController = widget.restaurantController;
    tastingNameController = widget.tastingNameController;
    restaurantSelected = widget.restaurantSelected;
    isLoading = widget.isLoading;
    createTasting = widget.createTasting;
    formKey = widget.formKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarView(),
      body: Container(
        padding: const EdgeInsets.only(
          top: 15,
          left: 27,
          right: 27,
        ),
        child: Form(
          key: formKey,
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
                if (pattern.length < 3) {
                  return [];
                }

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
        onPressed: () => createTasting(restaurantSelected!),
        isLoading: isLoading,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
