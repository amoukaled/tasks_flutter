// Flutter imports
import 'package:flutter/material.dart';

// Pub imports
import 'package:provider/provider.dart';

// App imports
import 'package:tasks_flutter/provider/task_state.dart';
import 'package:tasks_flutter/shared/percentage_indicator.dart';

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
                    flex: 1,
                    child: PercentageIndicator(
                      value: state.getDoneRatio,
                    ),
                  ),
                  Expanded(
                    flex: 1,
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
                    flex: 1,
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
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
