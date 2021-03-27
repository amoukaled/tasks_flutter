import 'package:flutter/material.dart';

class Popup {
  static Future<void> wentWrongWidget({
    required BuildContext context,
    required String message,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8))),
                        ),
                        child: Text(
                          "Dismiss",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.blue[900],
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> loadingPopup({
    required BuildContext context,
    required Future<void> Function() callback,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 90),
                CircularProgressIndicator(),
                SizedBox(height: 90),
              ],
            ),
          ),
        );
      },
    );

    await callback();
    Navigator.pop(context);
  }
}
