// Flutter imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Pub imports
import 'package:provider/provider.dart';

// App imports
import 'package:tasks_flutter/provider/task_state.dart';
import 'package:tasks_flutter/services/auth_service.dart';
import 'package:tasks_flutter/services/database_service.dart';
import 'package:tasks_flutter/shared/percentage_indicator.dart';
import 'package:tasks_flutter/shared/popup.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskState>(
        builder: (BuildContext context, TaskState state, _) {
      return Card(
        color: Theme.of(context).accentColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(15),
        )),
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: PercentageIndicator(
                      value: state.getDoneRatio,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          "Done",
                          style: TextStyle(
                            fontSize: 23,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            state.getDoneTasks.toString(),
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[300]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(
                          "Left",
                          style: TextStyle(
                            fontSize: 23,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            state.getLeftTasks.toString(),
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[300]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(Icons.backup_rounded),
                            onPressed: () async {
                              User? user =
                                  Provider.of<User?>(context, listen: false);
                              if (user != null) {
                                await Popup.loadingPopup(
                                    context: context,
                                    callback: () async {
                                      await DatabaseService(user.uid)
                                          .setUserData(state.tasks);
                                    });
                              }
                            }),
                        IconButton(
                            icon: Icon(Icons.logout),
                            onPressed: () async {
                              await AuthService().signOut(state);
                            }),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
