import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealapp/firebase_options.dart';
import 'package:mealapp/screens/homescreen.dart';
import 'package:mealapp/screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(MediaQuery.of(context).size.height);
          print(MediaQuery.of(context).size.width);
          User? user = snapshot.data;
          return ScreenUtilInit(
            designSize:  const Size(411.42857142857144,890.2857142857143),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              home: user != null ? const
              Homepage() : const Loginscreen(),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
