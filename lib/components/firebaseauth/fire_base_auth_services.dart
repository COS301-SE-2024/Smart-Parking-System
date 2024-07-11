
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthServices {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;

    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;

    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return null;
  }
  
}