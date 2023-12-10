import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
import 'package:degust_et_des_couleurs/model/general_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/service_rating.dart';
import 'package:degust_et_des_couleurs/model/sommelier_rating.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/tasting/_app_bar_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/tasting_loading_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/tasting_view.dart';
import 'package:flutter/material.dart';

class TastingController extends StatefulWidget {
  final int id;

  const TastingController({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return TastingControllerState();
  }
}

class TastingControllerState extends State<TastingController> {
  late int id;
  late Future<Tasting> tasting;

  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TastingRepository().find(id).onError((error, stackTrace) {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext context) {
            return const LoginController();
          });

          Navigator.of(context).push(materialPageRoute);

          throw BadCredentialException();
        }),
        builder: (BuildContext context, AsyncSnapshot<Tasting> snapshot) {
          Tasting? loadedTasting;

          if (snapshot.hasData) {
            loadedTasting = snapshot.data;
          } else {
            return const TastingLoadingView();
          }

          if (loadedTasting == null) {
            return Scaffold(
              appBar: AppBarView(
                tasting: loadedTasting,
              ),
            );
          }

          return TastingView(
              loadedTasting: loadedTasting,
              initializeServiceRatings: initializeServiceRatings,
              initializeSommelierRatings: initializeSommelierRatings,
              initializeGeneralRatings: initializeGeneralRatings);
        });
  }

  Map<Participant, ServiceRating> initializeServiceRatings(Tasting tasting) {
    if (tasting.serviceRatings.isEmpty) {
      return {};
    }

    Map<Participant, ServiceRating> serviceRatings = {};

    for (var element in tasting.serviceRatings) {
      Participant participant = tasting.participants.firstWhere(
          (participant) => participant.id == element.participant.id);

      serviceRatings[participant] = element;
    }

    return serviceRatings;
  }

  Map<Participant, SommelierRating> initializeSommelierRatings(
      Tasting tasting) {
    if (tasting.sommelierRatings.isEmpty) {
      return {};
    }

    Map<Participant, SommelierRating> sommelierRatings = {};

    for (var element in tasting.sommelierRatings) {
      Participant participant = tasting.participants.firstWhere(
          (participant) => participant.id == element.participant.id);

      sommelierRatings[participant] = element;
    }

    return sommelierRatings;
  }

  Map<Participant, GeneralRating> initializeGeneralRatings(Tasting tasting) {
    if (tasting.generalRatings.isEmpty) {
      return {};
    }

    Map<Participant, GeneralRating> generalRatings = {};

    for (var element in tasting.generalRatings) {
      Participant participant = tasting.participants.firstWhere(
          (participant) => participant.id == element.participant.id);

      generalRatings[participant] = element;
    }

    return generalRatings;
  }
}
