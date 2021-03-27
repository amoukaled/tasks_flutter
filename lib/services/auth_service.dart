import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks_flutter/services/auth_error.dart';

class AuthService {
  static final AuthService _authService = AuthService._internal();

  factory AuthService() {
    return _authService;
  }

  AuthService._internal();

  static RegExp emailRegEx = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  FirebaseAuth _auth = FirebaseAuth.instance;

  /// The user stream to subscribe to
  Stream<User?> get userStream {
    return _auth.authStateChanges();
  }

  /// Registers a new user with email and password
  Future<dynamic> registerUser(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      print(credential);
    } on FirebaseAuthException catch (e) {
      return AuthError.register(e);
    } catch (e) {
      return "Something went wrong";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
