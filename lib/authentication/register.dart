import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasks_flutter/services/auth_service.dart';
import 'package:tasks_flutter/services/database_service.dart';
import 'package:tasks_flutter/shared/loading_screen.dart';
import 'package:tasks_flutter/shared/popup.dart';

class Register extends StatefulWidget {
  final void Function() toggleLogin;

  Register({required this.toggleLogin});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  static const String _emailError = "Invalid email";
  String _error = " ";
  bool _isLoading = false;

  late TextEditingController _emailCont;
  late TextEditingController _pass1Cont;
  late TextEditingController _pass2Cont;
  late FocusNode _pass1Focus;
  late FocusNode _pass2Focus;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _emailCont = TextEditingController();
    _pass1Cont = TextEditingController();
    _pass2Cont = TextEditingController();
    _pass1Focus = FocusNode();
    _pass2Focus = FocusNode();
  }

  @override
  void dispose() {
    _emailCont.dispose();
    _pass1Cont.dispose();
    _pass2Cont.dispose();
    _pass1Focus.dispose();
    _pass2Focus.dispose();
    super.dispose();
  }

  bool get _passwordValidation {
    if (_pass1Cont.text.isNotEmpty &&
        _pass2Cont.text.isNotEmpty &&
        _pass1Cont.text.length >= 6 &&
        _pass2Cont.text.length >= 6 &&
        _pass1Cont.text == _pass2Cont.text) {
      return true;
    }

    return false;
  }

  Future<void> _registerCallback() async {
    String email = _emailCont.text;
    bool isMatch = AuthService.emailRegEx.hasMatch(email);

    if (!isMatch) {
      if (this.mounted) {
        setState(() {
          _autoValidate = true;
          _error = _emailError;
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          _autoValidate = false;
        });
      }

      String password = _pass1Cont.text;

      // Authentication
      if (this.mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      dynamic result = await AuthService().registerUser(email, password);
      if (result is UserCredential) {
        if (result.user != null) {
          String id = result.user!.uid;
          await DatabaseService(id).initUser();
        }
      }

      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
        if (result != null) {
          if (result is String) {
            await Popup.wentWrongWidget(context: context, message: result);
          }
        }
      }
    }
  }

  /// Avoided using form and TextFormField due to the card design
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                "Register",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _error,
                            style: TextStyle(
                                fontSize: 22,
                                fontStyle: FontStyle.italic,
                                color: Colors.red[900]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: TextField(
                              onChanged: (val) {
                                if (_autoValidate) {
                                  bool isMatch =
                                      AuthService.emailRegEx.hasMatch(val);

                                  if (isMatch) {
                                    if (this.mounted) {
                                      setState(() {
                                        _error = " ";
                                      });
                                    }
                                  } else {
                                    if (this.mounted) {
                                      setState(() {
                                        _error = _emailError;
                                      });
                                    }
                                  }
                                }
                              },
                              onSubmitted: (_) {
                                if (!_pass1Focus.hasFocus) {
                                  _pass1Focus.requestFocus();
                                }
                              },
                              autofocus: false,
                              controller: _emailCont,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 'email address',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                ),
                                border: InputBorder.none,
                                fillColor: Colors.transparent,
                                filled: true,
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              onChanged: (_) {
                                if (this.mounted) {
                                  setState(() {});
                                }
                              },
                              onSubmitted: (_) {
                                if (!_pass2Focus.hasFocus) {
                                  _pass2Focus.requestFocus();
                                }
                              },
                              autofocus: false,
                              maxLines: 1,
                              obscureText: true,
                              controller: _pass1Cont,
                              focusNode: _pass1Focus,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 'minimum of 6 charachters',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                ),
                                border: InputBorder.none,
                                fillColor: Colors.transparent,
                                filled: true,
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Re-enter:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              onChanged: (_) {
                                if (this.mounted) {
                                  setState(() {});
                                }
                              },
                              autofocus: false,
                              maxLines: 1,
                              obscureText: true,
                              controller: _pass2Cont,
                              focusNode: _pass2Focus,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 're-enter password',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                ),
                                border: InputBorder.none,
                                fillColor: Colors.transparent,
                                filled: true,
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextButton.icon(
                              icon: Icon(
                                Icons.create_rounded,
                                color: IconTheme.of(context).color,
                              ),
                              label: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              onPressed: (_passwordValidation)
                                  ? _registerCallback
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Divider(
                          height: 3,
                          indent: 15,
                          endIndent: 15,
                          thickness: 5,
                          color: Colors.blueGrey[300],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FittedBox(
                            alignment: Alignment.center,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "OR",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )),
                      ),
                      Expanded(
                        flex: 5,
                        child: Divider(
                          height: 3,
                          indent: 15,
                          endIndent: 15,
                          thickness: 5,
                          color: Colors.blueGrey[300],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FittedBox(
                                  alignment: Alignment.center,
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Already registered?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: TextButton.icon(
                                      icon: Icon(
                                        Icons.login,
                                        color: IconTheme.of(context).color,
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              TextButtonTheme.of(context)
                                                  .style!
                                                  .backgroundColor,
                                          shape: TextButtonTheme.of(context)
                                              .style!
                                              .shape),
                                      label: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      onPressed: widget.toggleLogin,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
