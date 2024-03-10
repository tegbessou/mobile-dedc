import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/core/auth.dart';
import 'package:degust_et_des_couleurs/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initFirebaseMessaging();

  runApp(const MyApp());
}

void initFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      print('pedro');
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final int primaryColor = const Color.fromRGBO(180, 20, 20, 1).value;

  final _router = GoRouter(
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = Auth().currentUser != null;

      if (!isAuthenticated) {
        return '/login';
      } else {
        return null;
      }
    },
    routes: [
      GoRoute(
        name: 'homepage',
        path: '/',
        builder: (context, state) => const HomepageController(),
        pageBuilder: (context, state) => const MaterialPage<void>(
          child: HomepageController(),
          name: 'homepage',
        ),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginController(),
        pageBuilder: (context, state) => const MaterialPage<void>(
          child: LoginController(),
          name: 'login',
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
          );
        });
  }
}
