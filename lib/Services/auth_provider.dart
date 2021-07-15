import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  FirebaseAuth auth = FirebaseAuth.instance;

  //Create Account
  Future<String> createAccount(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      String userdoc = user!.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userdoc)
          .set({"email": email, "name": name});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      print("User id: $user");

      return "Account created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return "Error occurred";
    }
    return 'Account Created';
  }

  //Sign in user
  Future<String> signIN(
      {required String email, required String password}) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = credential.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      print("User:$user");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'Welcome';
  }

  //Reset Password
  Future<String> resetPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email,
      );
      return "Email sent";
    } catch (e) {
      return "Error occurred";
    }
  }

  //SignOut
  void signOut() {
    auth.signOut();
  }
}
