// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Pub imports
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// App imports
import 'package:tasks_flutter/hive/tasksHiveBox.dart';
import 'package:tasks_flutter/models/task.dart';
import 'package:tasks_flutter/provider/task_state.dart';
import 'package:tasks_flutter/home/home.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.grey));

  WidgetsFlutterBinding.ensureInitialized();

  // Getting the app docs dir
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();

  // Initializing Hive
  Hive.init(appDocumentDirectory.path);

  // Registering the adapters
  Hive.registerAdapter(TaskAdapter());

  // Creating the storage to manage the hive encryption keys
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  // Opening the necessary boxes
  await TasksHiveBox.openBox(storage);

  // Getting Hive data to pass to the change notifier
  List<Task> tasks = await TasksHiveBox.getBoxData();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskState(tasks: tasks),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
        cardTheme: CardTheme(
          color: Colors.blueGrey[300],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.cyan),
        iconTheme: IconThemeData(color: Colors.cyan),
        primarySwatch: Colors.amber,
        backgroundColor: Colors.grey[400],
        accentColor: Colors.blueGrey,
      ),
      home: Home(),
    );
  }
}
