import 'dart:convert';

ModelMilestone modelMilestoneFromJson(String str) =>
    ModelMilestone.fromJson(json.decode(str));

String modelMilestoneToJson(ModelMilestone data) => json.encode(data.toJson());

class ModelMilestone {
  String id;
  int activities;
  List<dynamic> active;
  DateTime createdAt;
  DateTime expiryAt;
  String gradient;
  String icon;
  String name;
  dynamic stakes;
  String uid;
  String status;

  ModelMilestone(
      {required this.id,
      required this.activities,
      required this.active,
      required this.createdAt,
      required this.expiryAt,
      required this.gradient,
      required this.icon,
      required this.name,
      required this.stakes,
      required this.uid,
      required this.status});

  factory ModelMilestone.fromJson(Map<String, dynamic> json) => ModelMilestone(
        id: json["_id"],
        activities: json["activities"],
        active: List<dynamic>.from(json["active"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        expiryAt: DateTime.parse(json["expiryAt"]),
        gradient: json["gradient"],
        icon: json["icon"],
        name: json["name"],
        stakes: json["stakes"],
        uid: json["uid"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "activities": activities,
        "active": List<dynamic>.from(active.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "expiryAt": expiryAt.toIso8601String(),
        "gradient": gradient,
        "icon": icon,
        "name": name,
        "stakes": stakes,
        "uid": uid,
        "status": status
      };
}
