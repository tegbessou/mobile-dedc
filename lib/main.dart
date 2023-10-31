import 'package:degust_et_des_couleurs/controller/homepage_controller.dart';
import 'package:degust_et_des_couleurs/controller/login_controller.dart';
import 'package:degust_et_des_couleurs/controller/profile_controller.dart';
import 'package:degust_et_des_couleurs/core/auth.dart';
import 'package:degust_et_des_couleurs/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  int primaryColor = const Color.fromRGBO(180, 20, 20, 1).value;

  final _router = GoRouter(
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
        name: 'profile',
        path: '/profile',
        builder: (context, state) => const ProfileController(),
        pageBuilder: (context, state) => const MaterialPage<void>(
          child: ProfileController(),
          name: 'profile',
        ),
      ),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp.router(
            routerConfig: _router,
          );
        } else {
          return MaterialApp(
            home: LoginController(),
          );
        }
      }
    );
  }
}
