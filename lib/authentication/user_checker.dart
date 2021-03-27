import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_flutter/authentication/authenticate.dart';
import 'package:tasks_flutter/home/home.dart';

class UserChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(
      builder: (context, User? user, _) {
        if (user != null) {
          return Home();
        }

        return Authenticate();
      },
    );
  }
}
