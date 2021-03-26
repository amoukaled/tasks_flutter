import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isChecked;

  @HiveField(3)
  String note;

  @HiveField(4)
  int position;

  Task({
    required this.note,
    this.isChecked = false,
    required this.title,
    required this.position,
  }) {
    this.id = Uuid().v4();
  }
}
