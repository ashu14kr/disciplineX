import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  String id;
  String mid;
  int completionTime;
  DateTime createdAt;
  String name;
  String priority;
  dynamic startedAt;
  String status;
  String uid;

  TaskModel({
    required this.id,
    required this.mid,
    required this.completionTime,
    required this.createdAt,
    required this.name,
    required this.priority,
    required this.startedAt,
    required this.status,
    required this.uid,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["_id"],
        mid: json["mid"],
        completionTime: json["completionTime"],
        createdAt: DateTime.parse(json["createdAt"]),
        name: json["name"],
        priority: json["priority"],
        startedAt: json["startedAt"],
        status: json["status"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mid": mid,
        "completionTime": completionTime,
        "createdAt": createdAt.toIso8601String(),
        "name": name,
        "priority": priority,
        "startedAt": startedAt,
        "status": status,
        "uid": uid,
      };
}
