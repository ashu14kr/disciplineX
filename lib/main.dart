import 'package:anti_procastination/UiTesting/test_card.dart';
import 'package:anti_procastination/controllers/cubit/milestone_cubit.dart';
import 'package:anti_procastination/controllers/cubit/tasks_cubit.dart';
import 'package:anti_procastination/firebase_options.dart';
import 'package:anti_procastination/presentation/screens/onboarding/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TasksCubit()),
        BlocProvider(create: (_) => MilestoneCubit())
      ],
      child: MaterialApp(
        title: 'DiscplineX',
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: TestCards()
        home: const SplashScreen(),
      ),
    );
  }
}
