import 'package:firebase_auth/firebase_auth.dart';

/// Handles all [FirebaseAuthException]s
class AuthError {
  static String register(FirebaseAuthException e) {
    switch (e.code) {
      case "email-already-in-use":
        {
          return "Email already in use";
        }
      case "invalid-email":
        {
          return "Invalid email";
        }
      case "operation-not-allowed":
        {
          return "Something went wrong";
        }
      case "weak-password":
        {
          return "Weak password";
        }
      default:
        {
          return "Something went wrong";
        }
    }
  }
}
