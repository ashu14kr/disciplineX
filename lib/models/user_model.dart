import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int balance;
  String name;

  UserModel({
    required this.balance,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        balance: json["balance"],
        name: json["name"] ?? "null",
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "name": name,
      };
}
