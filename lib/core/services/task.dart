import 'dart:async';

import 'package:anti_procastination/models/task_model.dart';
import 'package:anti_procastination/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final db = FirebaseFirestore.instance;

  addUserInfo(String name, String uid, double balance) async {
    final user = {"name": name, "balance": balance};
    await db.collection("Users").doc(uid).set(user);
  }

  addTask(String name, String priority, int completionTime, String status,
      int bet, String uid) async {
    final docRef = db.collection("Tasks").doc();

    final task = {
      "_id": docRef.id,
      "name": name,
      "priority": priority,
      "createdAt": DateTime.now().toIso8601String(),
      "completionTime": completionTime,
      "status": status,
      "bet": bet,
      "uid": uid,
      "startedAt": null
    };

    await docRef.set(task);
  }

  updateTask(String docId) async {
    final docRef = FirebaseFirestore.instance.collection('Tasks').doc(docId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.update({"startedAt": DateTime.now().toString()});
    } else {
      print("Document not found");
    }
  }

  updateTaskStatus(String docId) async {
    final docRef = FirebaseFirestore.instance.collection('Tasks').doc(docId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.update({"status": "Successful"});
    } else {
      print("Document not found");
    }
  }

  Future<List<TaskModel>?> getTasks(String uid) async {
    try {
      final querySnapshot = await db
          .collection("Tasks")
          .where("uid", isEqualTo: uid)
          .where("status", isEqualTo: "NotCompleted")
          .get();

      final tasks = querySnapshot.docs.map((doc) {
        return TaskModel.fromJson(doc.data());
      }).toList();

      return tasks;
    } catch (e) {
      print("Error fetching tasks: $e");
      return null;
    }
  }

  Future<UserModel?> getUserInfo(String uid) async {
    final doc = db.collection("Users").doc(uid);
    doc.get().then((DocumentSnapshot docu) {
      final data = docu.data() as Map<String, dynamic>;
      final user = UserModel.fromJson(data);
      return user;
    });
    return null;
  }
}
