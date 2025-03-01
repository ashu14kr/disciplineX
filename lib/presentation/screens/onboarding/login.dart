import 'package:anti_procastination/auth_service.dart';
import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/core/services/task.dart';
import 'package:anti_procastination/presentation/screens/home/home.dart';
import 'package:anti_procastination/storage/storage.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();
  Storage storage = Storage();
  Task task = Task();

  void signInWithGoogle() async {
    try {
      final user = await auth.signInWithGoogle(); // Await sign-in
      if (user != null) {
        // Save sign-in information
        await storage.setSignInInfo(
            user.uid, user.displayName ?? "Unknown", user.email ?? "No email");

        // Check if user info exists and add if necessary
        final doc = await task.getUserInfo(user.uid);
        if (doc?.balance == 0.0) {
          await task.addUserInfo(user.displayName ?? "Unknown", user.uid, 0.0);
        }

        // Ensure the widget is still mounted before navigating
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        print("Sign-in failed!");
        // Optionally, show a message to the user
      }
    } catch (e) {
      print("Error during sign-in: $e");
      // Optionally, show error feedback to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/tropy.png",
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to ",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "DisciplineX",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Train Your Discipline, Win Your Time",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: const Color.fromARGB(255, 68, 68, 68),
                  ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                signInWithGoogle();
              },
              child: Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: mainColor,
                      blurRadius: 4,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.apple,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Continue with Google",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
