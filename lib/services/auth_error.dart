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

  static String login(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        {
          return "Invalid email";
        }
      case "user-disabled":
        {
          return "Something went wrong";
        }
      case "user-not-found":
        {
          return "Incorrect email/password";
        }
      case "wrong-password":
        {
          return "Incorrect email/password";
        }
      default:
        {
          return "Something went wrong";
        }
    }
  }
}
