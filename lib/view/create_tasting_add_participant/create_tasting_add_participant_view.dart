import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/repository/participant_repository.dart';
import 'package:degust_et_des_couleurs/view/_autocomplete_field_custom.dart';
import 'package:degust_et_des_couleurs/view/_floating_action_button_custom.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_small_elevated_button.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/create_tasting/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/create_tasting_add_participant/_add_participant_button.dart';
import 'package:flutter/material.dart';

class CreateTastingAddParticipantView extends StatefulWidget {
  final TextEditingController participantController;
  final List<Participant> participants;
  final void Function() displayAddParticipant;
  final void Function() addParticipants;
  final bool isLoading;

  const CreateTastingAddParticipantView(
      {super.key,
      required this.displayAddParticipant,
      required this.addParticipants,
      required this.participantController,
      required this.participants,
      required this.isLoading});

  @override
  State<StatefulWidget> createState() {
    return CreateTastingAddParticipantViewState();
  }
}

class CreateTastingAddParticipantViewState
    extends State<CreateTastingAddParticipantView> {
  late List<Participant> participants;
  late TextEditingController participantController;
  late void Function() displayAddParticipant;
  late void Function() addParticipants;
  late bool isLoading;

  @override
  void initState() {
    super.initState();

    participants = widget.participants;
    participantController = widget.participantController;
    displayAddParticipant = widget.displayAddParticipant;
    addParticipants = widget.addParticipants;
    isLoading = widget.isLoading;
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
                      if (pattern.length < 3) {
                        return [];
                      }

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
                        participant.name ?? "",
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
}
