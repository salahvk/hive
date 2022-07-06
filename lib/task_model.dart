import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String task;

  // Just an example for next attribute
  // @HiveField(1)
  // bool checked;

  Task({required this.task});
}
