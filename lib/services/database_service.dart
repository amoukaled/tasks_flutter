import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks_flutter/models/task.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Singleton
  String? id;

  static final DatabaseService _databaseService = DatabaseService._internal();

  factory DatabaseService(String id) {
    _databaseService.id = id;
    return _databaseService;
  }

  DatabaseService._internal();

  CollectionReference get _usersColl => _firestore.collection('users');

  /// Init user with a collection is more reliable with firestore
  /// cloud functions
  Future<void> initUser() async {
    if (id != null) {
      try {
        Map<String, dynamic> data = {"tasks": []};
        await _usersColl.doc(id).set(data);
      } catch (_) {}
    }
  }

  Future<List<Task>> getUserData() async {
    List<Task> tasks = <Task>[];
    if (id != null) {
      try {
        DocumentReference userDoc = _usersColl.doc(id);
        DocumentSnapshot snapshot = await userDoc.get();
        Map<String, dynamic>? userData = snapshot.data();

        if (userData != null) {
          if (userData['tasks'] != null) {
            List<Map<String, dynamic>?> userTasks =
                List.from(userData['tasks']);

            for (Map<String, dynamic>? mappedTask in userTasks) {
              if (mappedTask != null) {
                try {
                  String? id = mappedTask["id"];
                  String? title = mappedTask["title"];
                  String? note = mappedTask["note"];
                  int? position = mappedTask["position"];
                  bool? isChecked = mappedTask["isChecked"];

                  if (id != null &&
                      title != null &&
                      note != null &&
                      position != null &&
                      isChecked != null) {
                    tasks.add(Task(
                        note: note,
                        isChecked: isChecked,
                        title: title,
                        position: position));
                  }
                } catch (_) {
                  continue;
                }
              }
            }
          }
        }
      } catch (_) {}
    }
    return tasks;
  }

  Future<void> setUserData(List<Task> tasks) async {
    DocumentReference userDoc = _usersColl.doc(id);

    List<Map<String, dynamic>> data = [];

    for (Task task in tasks) {
      data.add({
        "title": task.title,
        "id": task.id,
        "note": task.note,
        "isChecked": task.isChecked,
        "position": task.position,
      });
    }

    try {
      await userDoc.set({"tasks": data});
    } catch (_) {}
  }
}
