// Flutter imports
import 'package:flutter/material.dart';

// Pub imports
import 'package:hive/hive.dart';

// App imports
import 'package:tasks_flutter/hive/tasksHiveBox.dart';
import 'package:tasks_flutter/models/task.dart';

class TaskState extends ChangeNotifier {
  List<Task> tasks;
  late LazyBox<Task> _box;

  TaskState({required this.tasks}) {
    this._box = TasksHiveBox.getBox();
  }

  int get getDoneTasks => tasks.where((element) => element.isChecked).length;

  int get getLeftTasks => tasks.length - getDoneTasks;

  double get getDoneRatio {
    if (tasks.length != 0) {
      return getDoneTasks / tasks.length;
    }
    return 0.0;
  }

  void reorderItems(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final Task task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);

    for (int x = 0; x < tasks.length; x++) {
      tasks[x].position = x;
      await tasks[x].save();
    }

    notifyListeners();
  }

  Future<void> toggleTask(int index, bool val) async {
    tasks[index].isChecked = val;
    await tasks[index].save();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    tasks.add(task);
    await _box.add(task);
    notifyListeners();
  }

  Future<void> removeTask(int index) async {
    await tasks[index].delete();
    tasks.removeAt(index);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await task.save();
    notifyListeners();
  }

  Future<void> login(List<Task> tasksList) async {
    // Clearing
    await _box.clear();
    tasks.clear();

    // Adding
    await _box.addAll(tasksList);
    tasks.addAll(tasksList);
    notifyListeners();
  }

  Future<void> logout() async {
    await _box.clear();
    tasks.clear();
    notifyListeners();
  }
}
