import 'package:flutter/material.dart';
import 'package:tasks_flutter/services/auth_service.dart';
import 'package:tasks_flutter/shared/popup.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    ),
  );

  late TextEditingController _emailCont;

  @override
  void initState() {
    super.initState();
    _emailCont = TextEditingController();
  }

  @override
  void dispose() {
    _emailCont.dispose();
    super.dispose();
  }

  void _cancelSheet(BuildContext context) {
    _emailCont.clear();
    Navigator.pop(context);
  }

  bool get isInputValid => AuthService.emailRegEx.hasMatch(_emailCont.text);

  Future<void> _submitSheet(BuildContext context) async {
    String email = _emailCont.text;

    // Authentication
    dynamic result;

    await Popup.loadingPopup(
        context: context,
        callback: () async {
          result = await AuthService().forgotPassword(email);
        });
    if (result != null) {
      if (result is String) {
        await Popup.wentWrongWidget(context: context, message: result);
      }
    }
    _cancelSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  enableDrag: false,
                  shape: _shape,
                  backgroundColor: Colors.grey[400],
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setSheetState) {
                        return WillPopScope(
                          onWillPop: () async {
                            _cancelSheet(context);
                            return true;
                          },
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).accentColor,
                                              borderRadius:
                                                  _shape.borderRadius),
                                          child: Text(
                                            "Reset Password",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    shape: CardTheme.of(context).shape,
                                    color: CardTheme.of(context).color,
                                    elevation: CardTheme.of(context).elevation,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
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
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: TextField(
                                            autofocus: true,
                                            onChanged: (_) {
                                              setSheetState(() {});
                                            },
                                            controller: _emailCont,
                                            maxLines: 1,
                                            keyboardType: TextInputType.text,
                                            textCapitalization:
                                                TextCapitalization.sentences,
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: TextButton.icon(
                                              icon: Icon(
                                                Icons.send_rounded,
                                                color:
                                                    IconTheme.of(context).color,
                                              ),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      TextButtonTheme.of(
                                                              context)
                                                          .style!
                                                          .backgroundColor,
                                                  shape: TextButtonTheme.of(
                                                          context)
                                                      .style!
                                                      .shape),
                                              label: Text(
                                                "Send",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              onPressed: (isInputValid)
                                                  ? () async {
                                                      await _submitSheet(
                                                          context);
                                                    }
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Text(
                "Forgot password?",
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
