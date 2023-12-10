import 'package:degust_et_des_couleurs/controller/create_tasting_add_participant_controller.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/restaurant_repository.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/create_tasting/create_tasting_view.dart';
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
  final TextEditingController customRestaurantController =
      TextEditingController();
  final TextEditingController tastingNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isCustomRestaurant = false;
  String? errorMessageRestaurant;

  @override
  Widget build(BuildContext context) {
    return CreateTastingView(
      restaurantController: restaurantController,
      customRestaurantController: customRestaurantController,
      tastingNameController: tastingNameController,
      isLoading: isLoading,
      isCustomRestaurant: isCustomRestaurant,
      createTasting: createTasting,
      formKey: _formKey,
    );
  }

  void createTasting(Restaurant? restaurant, bool isCustomRestaurant) async {
    if (createdTasting != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return CreateTastingAddParticipantController(tasting: createdTasting);
      });

      Navigator.of(context).push(materialPageRoute);

      return;
    }

    print(isCustomRestaurant);
    print(customRestaurantController.value);

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      if (isCustomRestaurant) {
        await RestaurantRepository()
            .post(customRestaurantController.text)
            .then((value) async {
          await TastingRepository()
              .post(tastingNameController.text, value)
              .then((Tasting value) {
            setState(() {
              createdTasting = value;
              isLoading = false;
            });

            MaterialPageRoute materialPageRoute =
                MaterialPageRoute(builder: (BuildContext context) {
              return CreateTastingAddParticipantController(tasting: value);
            });

            Navigator.of(context).push(materialPageRoute);
          });
        });

        return;
      }

      await TastingRepository()
          .post(tastingNameController.text, restaurant!)
          .then((Tasting value) {
        setState(() {
          createdTasting = value;
          isLoading = false;
        });

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) {
          return CreateTastingAddParticipantController(tasting: value);
        });

        Navigator.of(context).push(materialPageRoute);
      });
    }
  }
}
