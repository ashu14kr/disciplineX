import 'package:anti_procastination/firebase_options.dart';
import 'package:anti_procastination/screens/home.dart';
import 'package:anti_procastination/screens/login.dart';
import 'package:anti_procastination/storage/model/local_user_model.dart';
import 'package:anti_procastination/storage/storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Storage storage = Storage();
  bool validUser = false;

  @override
  void didChangeDependencies() async {
    LocalUserModel? response = await storage.getSignInInfo();
    if (response?.uuid != null) {
      setState(() {
        validUser = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiscplineX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: validUser ? const Home() : const LoginScreen(),
    );
  }
}
