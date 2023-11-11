import 'package:degust_et_des_couleurs/controller/tasting_controller.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/participant_repository.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/_autocomplete_field_custom.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_small_elevated_button.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/create_tasting_add_participant/_add_participant_button.dart';
import 'package:degust_et_des_couleurs/view/create_tasting_add_participant/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/create_tasting_add_participant/_create_participant_alert_dialog.dart';
import 'package:flutter/material.dart';

class CreateTastingAddParticipantController extends StatefulWidget {
  final Tasting? tasting;

  const CreateTastingAddParticipantController(
      {super.key, required this.tasting});

  @override
  State<StatefulWidget> createState() {
    return CreateTastingAddParticipantControllerState();
  }
}

class CreateTastingAddParticipantControllerState
    extends State<CreateTastingAddParticipantController> {
  late Tasting? tasting;
  List<Participant> participants = [];
  Restaurant? restaurantSelected;
  final TextEditingController participantController = TextEditingController();
  final TextEditingController createParticipantNameController =
      TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tasting = widget.tasting;
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
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: AutocompleteFieldCustom(
                    controller: participantController,
                    suggestionsCallback: (pattern) async {
                      return await ParticipantRepository().findByName(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion.name),
                        trailing: SmallElevatedButton(
                          text: "Ajouter",
                          onPress: null,
                          backgroundColor: MyColors().primaryColor,
                          color: MyColors().whiteColor,
                        ),
                      );
                    },
                    onSuggestionSelected: (selection) {
                      setState(() {
                        if (!participants
                            .map((item) => item.id)
                            .contains(selection.id)) {
                          participants.add(selection);
                        }
                      });
                      participantController.text = '';
                    },
                    placeholder: "Rechercher des participants",
                    prefixIcon: Icons.search,
                    prefixIconColor: MyColors().greyColor,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                AddParticipantButton(
                  displayAddParticipant: displayAddParticipant,
                ),
              ],
            ),
            const Padding(
                padding: EdgeInsets.only(
              top: 20,
            )),
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  final participant = participants[index];

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextDmSans(
                        participant.name,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                      SmallElevatedButton(
                          onPress: () {
                            setState(() {
                              participants.remove(participant);
                            });
                          },
                          text: "Retirer",
                          backgroundColor: MyColors().secondaryColor,
                          color: MyColors().blackColor),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: MyColors().whiteColor,
      floatingActionButton: FloatingActionButtonCustom(
        onPressed: addParticipants,
        text: "Ajouter ${participants.length} participants",
        isLoading: isLoading,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void displayAddParticipant() async {
    return showDialog(
        context: context,
        builder: (context) {
          return CreateParticipantAlertDialog(
            createParticipantNameController: createParticipantNameController,
            createParticipant: createParticipant,
          );
        });
  }

  void addParticipants() async {
    setState(() {
      isLoading = true;
    });

    Tasting updatedTasting = await TastingRepository()
        .addParticipants(tasting, participants)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
      return TastingController(id: updatedTasting.id);
    });

    Navigator.of(context).push(materialPageRoute);
  }

  Future<void> createParticipant() async {
    Participant participant = await ParticipantRepository().post(
      createParticipantNameController.text,
    );

    setState(() {
      participants.add(participant);
    });

    createParticipantNameController.text = '';

    Navigator.of(context).pop();
  }
}
