
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking_system/components/common/toast.dart';

class FireBaseAuthServices {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;

    } catch (e) {
      if (e is FirebaseAuthException) { // Check if the exception is a FirebaseAuthException
        if (e.code == 'email-already-in-use') {
          showToast(message: 'The email is already in use.');
        } else {
          showToast(message: 'An error occurred: ${e.code}');
        }
      }
    }

    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;

    } catch (e) {
      if (e is FirebaseAuthException) { // Check if the exception is a FirebaseAuthException
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          showToast(message: 'Invalid email or password.');
        } else {
          showToast(message: 'An error occurred: ${e.code}');
        }
      }
    }

    return null;
  }
  
}