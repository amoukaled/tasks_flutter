import 'package:flutter/material.dart';
import 'package:tasks_flutter/services/auth_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const String _emailError = "Invalid email";
  String _error = " ";

  late TextEditingController _emailCont;
  late TextEditingController _passCont;
  late FocusNode _passFocus;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _emailCont = TextEditingController();
    _passCont = TextEditingController();
    _passFocus = FocusNode();
  }

  @override
  void dispose() {
    _emailCont.dispose();
    _passCont.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  /// Avoided using form and TextFormField due to the card design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Login",
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
                            bool isMatch = AuthService.emailRegEx.hasMatch(val);

                            if (isMatch) {
                              setState(() {
                                _error = " ";
                              });
                            } else {
                              setState(() {
                                _error = _emailError;
                                ;
                              });
                            }
                          }
                        },
                        onSubmitted: (_) {
                          if (!_passFocus.hasFocus) {
                            _passFocus.requestFocus();
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
                          setState(() {});
                        },
                        autofocus: false,
                        maxLines: 1,
                        obscureText: true,
                        controller: _passCont,
                        focusNode: _passFocus,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: 'password',
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
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: GestureDetector(
                        onTap: () {
                          print("tapped");
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
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
                          Icons.login,
                          color: IconTheme.of(context).color,
                        ),
                        style: ButtonStyle(
                            backgroundColor: TextButtonTheme.of(context)
                                .style!
                                .backgroundColor,
                            shape: TextButtonTheme.of(context).style!.shape),
                        label: Text(
                          "Login",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        onPressed: (_passCont.text.isNotEmpty)
                            ? () {
                                String email = _emailCont.text;
                                bool isMatch =
                                    AuthService.emailRegEx.hasMatch(email);

                                if (!isMatch) {
                                  setState(() {
                                    _autoValidate = true;
                                    _error = _emailError;
                                  });
                                } else {
                                  setState(() {
                                    _autoValidate = false;
                                  });
                                }
                              }
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
                        style: TextStyle(color: Colors.black, fontSize: 15),
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
                              "Don't have an account?",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextButton.icon(
                                icon: Icon(
                                  Icons.create_rounded,
                                  color: IconTheme.of(context).color,
                                ),
                                style: ButtonStyle(
                                    backgroundColor: TextButtonTheme.of(context)
                                        .style!
                                        .backgroundColor,
                                    shape: TextButtonTheme.of(context)
                                        .style!
                                        .shape),
                                label: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                onPressed: () {},
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