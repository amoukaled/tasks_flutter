import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks_flutter/models/task.dart';
import 'package:tasks_flutter/provider/task_state.dart';
import 'package:tasks_flutter/services/auth_error.dart';
import 'package:tasks_flutter/services/database_service.dart';

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
      return credential;
    } on FirebaseAuthException catch (e) {
      return AuthError.register(e);
    } catch (_) {
      return "Something went wrong";
    }
  }

  Future<dynamic> signIn(String email, String password, TaskState state) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        List<Task> tasks =
            await DatabaseService(credential.user!.uid).getUserData();

        await state.login(tasks);
      }

      return true;
    } on FirebaseAuthException catch (e) {
      return AuthError.login(e);
    } catch (_) {
      return "Something went wrong";
    }
  }

  Future<dynamic> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (_) {
      return "Something went wrong";
    }
  }

  Future<void> signOut(TaskState state) async {
    await _auth.signOut().then((value) async => await state.logout());
  }
}
