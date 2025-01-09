import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> signup({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else {
        throw 'An error occurred while signing up: ${e.message}';
      }
    } catch (e) {
      throw 'An error occurred while signing up.';
    }
  }
}
