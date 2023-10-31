import 'package:firebase_auth/firebase_auth.dart';

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
    await firebaseAuth.signOut();
  }
}