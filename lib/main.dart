// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Pub imports
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// App imports
import 'package:tasks_flutter/hive/tasksHiveBox.dart';
import 'package:tasks_flutter/models/task.dart';
import 'package:tasks_flutter/MyApp.dart';

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

  runApp(MyApp(tasks: tasks));
}
