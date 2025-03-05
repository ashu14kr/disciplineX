import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color mainColor = Color.fromARGB(255, 165, 129, 255);
const Color bgColor = Color.fromARGB(255, 22, 22, 22);
const Color boxbgColor = Color.fromARGB(255, 2, 2, 2);

final Map<String, IconData> icons = {
  'code': CupertinoIcons.chevron_left_slash_chevron_right,
  'sports': CupertinoIcons.sportscourt,
  'person': CupertinoIcons.person,
  'nature': CupertinoIcons.tree,
  'education': CupertinoIcons.book,
  'text': CupertinoIcons.textformat,
  'writing': CupertinoIcons.pencil,
  'user': CupertinoIcons.person_solid,
  'night': CupertinoIcons.moon_stars,
  'water': CupertinoIcons.drop,
  'shopping': CupertinoIcons.bag,
  'analytics': CupertinoIcons.chart_bar_alt_fill,
  'travel': CupertinoIcons.airplane,
  'finance': CupertinoIcons.money_dollar,
  'stats': CupertinoIcons.chart_bar,
  'music': CupertinoIcons.music_mic,
  'photography': CupertinoIcons.photo_camera,
  'community': CupertinoIcons.person_2,
  'health': CupertinoIcons.heart,
  'business': CupertinoIcons.briefcase,
  'art': CupertinoIcons.paintbrush
};

final Map<String, LinearGradient> gradients = {
  "Blue-Purple": const LinearGradient(colors: [Colors.blue, Colors.purple]),
  "Red-Orange": const LinearGradient(colors: [Colors.red, Colors.orange]),
  "Green-Teal": const LinearGradient(colors: [Colors.green, Colors.teal]),
  "Indigo-Blue":
      const LinearGradient(colors: [Colors.indigo, Colors.blueAccent]),
  "Pink-Purple": const LinearGradient(colors: [Colors.pink, Colors.deepPurple])
};
