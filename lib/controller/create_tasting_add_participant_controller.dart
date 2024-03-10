import 'package:degust_et_des_couleurs/controller/tasting_controller.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:degust_et_des_couleurs/repository/participant_repository.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/create_tasting_add_participant/_create_participant_alert_dialog.dart';
import 'package:degust_et_des_couleurs/view/create_tasting_add_participant/create_tasting_add_participant_view.dart';
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
    return CreateTastingAddParticipantView(
      displayAddParticipant: displayAddParticipant,
      addParticipants: addParticipants,
      participants: participants,
      participantController: participantController,
      isLoading: isLoading,
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

    if (participants.isEmpty) {
      setState(() {
        isLoading = false;
      });
    }

    Tasting updatedTasting = await TastingRepository()
        .addParticipants(tasting!, participants)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    int userId = int.parse(await HttpRepository().getUserId());

    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
      return TastingController(id: updatedTasting.id, userId: userId);
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
