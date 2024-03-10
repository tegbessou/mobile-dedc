import 'package:degust_et_des_couleurs/controller/friend_controller.dart';
import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/controller/tasting_controller.dart';
import 'package:degust_et_des_couleurs/exception/bad_credential_exception.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:degust_et_des_couleurs/repository/tasting_repository.dart';
import 'package:degust_et_des_couleurs/view/homepage/homepage_loading_view.dart';
import 'package:degust_et_des_couleurs/view/homepage/homepage_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomepageController extends StatefulWidget {
  const HomepageController({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomepageState();
  }
}

class HomepageState extends State<HomepageController> {
  @override
  void initState() {
    super.initState();

    setupInteractedMessage();
  }

  Future<void> setupInteractedMessage() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    int userId = int.parse(await HttpRepository().getUserId());

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return initialMessage.data['type'] == 'shared_tasting'
            ? TastingController(
                id: int.parse(initialMessage.data['tasting_id']),
                userId: userId)
            : FriendController(userId: userId);
      });

      Navigator.of(context).push(materialPageRoute);
    }

    FirebaseMessaging.instance.subscribeToTopic("friend_request_$userId");
    FirebaseMessaging.instance.subscribeToTopic("shared_tasting_with_$userId");

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) {
        return message.data['type'] == 'shared_tasting'
            ? TastingController(
                id: int.parse(message.data['tasting_id']), userId: userId)
            : FriendController(userId: userId);
      });

      Navigator.of(context).push(materialPageRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tasting>>(
      future: TastingRepository()
          .findByName("", false)
          .onError((error, stackTrace) {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) {
          return const LoginController();
        });

        Navigator.of(context).push(materialPageRoute);

        throw BadCredentialException();
      }),
      builder: (context, snapshot) {
        List<Tasting>? tastings;

        if (snapshot.hasData) {
          tastings = snapshot.data;
        } else {
          //Put a loader here
          return const HomePageLoadingView();
        }

        return HomepageView(tastings: tastings);
      },
    );
  }
}
