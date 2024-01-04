import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media/pages/details_screen.dart';
import 'package:social_media/pages/login_screen.dart';
import 'package:social_media/pages/registre_screen.dart';
import 'package:social_media/pages/splash_screen.dart';

import 'home.dart';
import 'pages/navbar_buttom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          FirebaseAuth.instance.currentUser == null ? SplashScreen() : NavBar(),
      routes: {
        "signup": (context) => RegistreScreen(),
        "login": (context) => LoginScreen(),
        "home": (context) => HomeScreen(),
        "splash": (context) => SplashScreen(),
        "mainScreen":(context) => NavBar(),
        "details":(context) => DetailsScreen(),
      },
    );
  }
}
