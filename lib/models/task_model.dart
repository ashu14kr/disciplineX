import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  String status;
  String uid;
  int bet;
  DateTime createdAt;
  String priority;
  String completionTime;
  String name;

  TaskModel({
    required this.status,
    required this.uid,
    required this.bet,
    required this.createdAt,
    required this.priority,
    required this.completionTime,
    required this.name,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        status: json["status"],
        uid: json["uid"],
        bet: json["bet"],
        createdAt: DateTime.parse(json["createdAt"]),
        priority: json["priority"],
        completionTime: json["completionTime"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "uid": uid,
        "bet": bet,
        "createdAt": createdAt.toIso8601String(),
        "priority": priority,
        "completionTime": completionTime,
        "name": name,
      };
}
