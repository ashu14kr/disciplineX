// List of available tags
import 'package:flutter/material.dart';

final List<String> availableTags = [
  "Career Growth",
  "Fitness",
  "Coding",
  "Entrepreneurship",
  "Personal Development",
  "Academic",
  "Creative",
  "Financial Success",
];

// Set to store selected tags
String selectedTags = "";

final List<Map<String, dynamic>> groups = [
  {
    "name": "Fitness Warriors",
    "description": "Achieve your fitness goals with a supportive community.",
    "members": 12
  },
  {
    "name": "Healthy Living",
    "description": "Join others dedicated to building healthy habits.",
    "members": 8
  },
  {
    "name": "Mindful Achievers",
    "description": "Stay focused and reach your dreams together.",
    "members": 15
  },
];

Widget customTextEdit(
    {required String hint,
    required String label,
    required TextEditingController controller,
    required String error}) {
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: controller,
        maxLength: 80,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return error;
          }
          return null;
        },
      ),
    ),
  );
}

class QuestionModel {
  String question;
  Widget widget;

  QuestionModel({required this.question, required this.widget});
}
