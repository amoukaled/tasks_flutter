// Dart imports
import 'dart:convert';

// Pub imports
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// App imports
import 'package:tasks_flutter/models/task.dart';

class TasksHiveBox {
  static const String _boxName = 'SFD34e4fr3';
  static const String _boxKey = "DF435DFgfg";

  /// Opens the tasks box.
  static Future<void> openBox(FlutterSecureStorage storage) async {
    bool containsEncryptionKey = await storage.containsKey(key: _boxKey);

    // If key does not exist, create one and save
    if (!containsEncryptionKey) {
      List<int> key = Hive.generateSecureKey();
      await storage.write(key: _boxKey, value: base64UrlEncode(key));
    }

    // Reading the key from the encrypted storage
    String? readKey = await storage.read(key: _boxKey);

    if (readKey != null) {
      final List<int> encryptionKey = base64Url.decode(readKey);
      await Hive.openLazyBox<Task>(_boxName,
          compactionStrategy: (_, deletedEntries) {
        return deletedEntries > 30;
      }, encryptionCipher: HiveAesCipher(encryptionKey));
    }
  }

  /// Gets the lazy box.
  static LazyBox<Task> getBox() => Hive.lazyBox<Task>(_boxName);

  /// Returns a list of tasks from the hive box.
  static Future<List<Task>> getBoxData() async {
    LazyBox<Task> box = getBox();

    List<Task> tasks = <Task>[];

    for (var key in box.keys) {
      if (key != null) {
        Task? task = await box.get(key);

        if (task != null) {
          tasks.add(task);
        }
      }
    }

    tasks.sort((a, b) {
      if (a.position > b.position) {
        return 1;
      } else if (a.position < b.position) {
        return -1;
      }

      return 0;
    });

    return tasks;
  }

  /// Compacts the hive box and closes it.
  static Future<void> closeBox() async {
    await Hive.lazyBox<Task>(_boxName).compact();
    await Hive.lazyBox<Task>(_boxName).close();
  }
}
