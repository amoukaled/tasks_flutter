// Flutter imports
import 'package:flutter/material.dart';

// Pub imports
import 'package:provider/provider.dart';

// App imports
import 'package:tasks_flutter/hive/tasksHiveBox.dart';
import 'package:tasks_flutter/authentication/user_checker.dart';
import 'package:tasks_flutter/models/task.dart';
import 'package:tasks_flutter/provider/task_state.dart';
import 'package:tasks_flutter/services/auth_service.dart';

class MyApp extends StatefulWidget {
  final List<Task> tasks;

  MyApp({required this.tasks});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() async {
    await TasksHiveBox.closeBox();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskState>(
      create: (context) => TaskState(tasks: widget.tasks),
      child: StreamProvider.value(
        value: AuthService().userStream,
        initialData: null,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.disabled)
                      ? Colors.grey[300]!
                      : Colors.blueGrey;
                }),
                shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            dialogTheme: DialogTheme(
              elevation: 0,
              backgroundColor: Colors.blueGrey[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            cardTheme: CardTheme(
              color: Colors.blueGrey[300],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            textSelectionTheme:
                TextSelectionThemeData(cursorColor: Colors.cyan),
            iconTheme: IconThemeData(color: Colors.cyan),
            primarySwatch: Colors.amber,
            backgroundColor: Colors.grey[400],
            accentColor: Colors.blueGrey,
          ),
          home: UserChecker(),
        ),
      ),
    );
  }
}
