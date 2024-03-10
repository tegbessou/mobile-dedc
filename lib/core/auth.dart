import 'package:degust_et_des_couleurs/repository/http_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<void> signInWitCustomToken({
    required String token,
  }) async {
    await firebaseAuth.signInWithCustomToken(token);
  }

  Future<void> signOut() async {
    FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
    FirebaseMessaging.instance.subscribeToTopic(
        "friend_request_${await HttpRepository().getUserId()}");
    await firebaseAuth.signOut();
    await flutterSecureStorage.delete(key: 'user_id');
    await flutterSecureStorage.delete(key: 'username');
    await flutterSecureStorage.delete(key: 'password');
  }
}
