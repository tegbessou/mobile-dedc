import 'package:firebase_auth/firebase_auth.dart';
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
    await firebaseAuth.signOut();
    await flutterSecureStorage.delete(key: 'user_id');
  }
}