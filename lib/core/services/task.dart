import 'dart:async';

import 'package:anti_procastination/models/analytics_model.dart';
import 'package:anti_procastination/models/milestone_model.dart';
import 'package:anti_procastination/models/task_model.dart';
import 'package:anti_procastination/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Task {
  final db = FirebaseFirestore.instance;

  addUserInfo(String name, String uid, double balance) async {
    final user = {"name": name, "balance": balance};
    await db.collection("Users").doc(uid).set(user);
  }

  addTask(String name, String priority, int completionTime, String status,
      String mid, String uid) async {
    final docRef = db.collection("Tasks").doc();

    final task = {
      "_id": docRef.id,
      "name": name,
      "priority": priority,
      "createdAt": DateTime.now().toIso8601String(),
      "completionTime": completionTime,
      "status": status,
      "mid": mid,
      "uid": uid,
      "startedAt": null
    };

    await docRef.set(task);
  }

  addAnalytics(String uid) async {
    final docRef = db.collection("Analytics").doc();

    final analytics = {
      "uid": uid,
      "startDate": DateTime.now().toIso8601String(),
      "totalMinSpend": 0,
      "totalMinPlanned": 0,
      "weeks": {
        DateFormat("yyyy-MM-dd").format(DateTime.now()
            .subtract(Duration(days: DateTime.now().weekday - 1))): {
          "Mon": 0.0,
          "Tue": 0.0,
          "Wed": 0.0,
          "Thu": 0.0,
          "Fri": 0.0,
          "Sat": 0.0,
          "Sun": 0.0
        }
      },
      "activeDays": []
    };

    await docRef.set(analytics);
  }

  addMilestone(String name, int activities, dynamic stakes, String icon,
      String gradient, String uid) async {
    final docRef = db.collection("Milestones").doc();

    final milestone = {
      "_id": docRef.id,
      "active": [],
      "status": "NotCompleted",
      "name": name,
      "activities": activities,
      "createdAt": DateTime.now().toIso8601String(),
      "expiryAt": DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      "stakes": stakes,
      "uid": uid,
      "icon": icon,
      "gradient": gradient
    };

    await docRef.set(milestone);
  }

  updateMileStone(String docId, DateTime expireAt) async {
    final docRef =
        FirebaseFirestore.instance.collection('Milestones').doc(docId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.update({
        "active": FieldValue.arrayUnion(
            [7 - expireAt.difference(DateTime.now()).inDays])
      });
    } else {
      print("Document not found");
    }
  }

  updateMilestoneActivity(String docId, int activities) async {
    final docRef =
        FirebaseFirestore.instance.collection('Milestones').doc(docId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.update({"activities": activities});
    } else {
      print("Document not found");
    }
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

  Future<List<TaskModel>?> getTasks(String uid, String mid) async {
    try {
      final querySnapshot = await db
          .collection("Tasks")
          .where("uid", isEqualTo: uid)
          .where("status", isEqualTo: "NotCompleted")
          .where("mid", isEqualTo: mid)
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

  Future<List<TaskModel>?> getCompTasks(String uid, String mid) async {
    try {
      final querySnapshot = await db
          .collection("Tasks")
          .where("uid", isEqualTo: uid)
          .where("status", isEqualTo: "Successful")
          .where("mid", isEqualTo: mid)
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

  Future<List<ModelMilestone>?> getMilestones(String uid) async {
    try {
      final querySnapshot = await db
          .collection("Milestones")
          .where("uid", isEqualTo: uid)
          .where("status", isEqualTo: "NotCompleted")
          .get();

      final milestones = querySnapshot.docs.map((doc) {
        return ModelMilestone.fromJson(doc.data());
      }).toList();

      return milestones;
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

  Future<AnalyticsModel?> getAnalytics(String uid) async {
    // try {
    final doc = await db.collection("Analytics").doc(uid).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return AnalyticsModel.fromJson(data);
    } else {
      return null; // Document doesn't exist
    }
    // }
    // } catch (e) {
    //   print("Error fetching analytics: $e");
    //   return null;
    // }
  }

  Future<void> updateDayMinutes(String uid, double minutes) async {
    final docRef = db.collection("Analytics").doc(uid);

    // Get the start of the current week (Monday)
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    String weekKey = DateFormat("yyyy-MM-dd").format(startOfWeek);
    String today = DateFormat("EEE").format(now); // "Mon", "Tue", etc.

    await db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        // If the document doesn't exist, initialize it
        transaction.set(docRef, {
          "uid": uid,
          "startDate": DateFormat("yyyy-MM-dd").format(now),
          "totalMinSpend": minutes,
          "totalMinPlanned": 0,
          "weeks": {
            weekKey: {
              "Mon": 0.0, "Tue": 0.0, "Wed": 0.0, "Thu": 0.0,
              "Fri": 0.0, "Sat": 0.0, "Sun": 0.0,
              today: minutes // Set today's minutes
            }
          },
          "activeDays": [today]
        });
      } else {
        // Update existing document
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> weeks = data["weeks"] ?? {};

        // Ensure the current week exists
        if (!weeks.containsKey(weekKey)) {
          weeks[weekKey] = {
            "Mon": 0.0,
            "Tue": 0.0,
            "Wed": 0.0,
            "Thu": 0.0,
            "Fri": 0.0,
            "Sat": 0.0,
            "Sun": 0.0
          };
        }

        // Update minutes for today
        weeks[weekKey][today] = (weeks[weekKey][today] ?? 0.0) + minutes;

        // Update Firestore
        transaction.update(docRef, {
          "weeks": weeks,
          "totalMinSpend": (data["totalMinSpend"] ?? 0) + minutes,
          "activeDays": FieldValue.arrayUnion(
              [DateFormat("dd-MM-yyyy").format(DateTime.now())])
        });
      }
    });
  }
}
