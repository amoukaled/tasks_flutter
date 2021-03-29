// Flutter imports
import 'package:flutter/material.dart';

// App imports
import 'package:tasks_flutter/authentication/login.dart';
import 'package:tasks_flutter/authentication/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return (isLogin)
        ? Login(
            toggleLogin: () {
              if (this.mounted) {
                setState(() {
                  isLogin = false;
                });
              }
            },
          )
        : Register(
            toggleLogin: () {
              if (this.mounted) {
                setState(() {
                  isLogin = true;
                });
              }
            },
          );
  }
}
