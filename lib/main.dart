import 'package:cubby/views/authenticate/sign_up.dart';
import 'package:cubby/views/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'views/authenticate/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Cubby());
}

// ignore: use_key_in_widget_constructors
class Cubby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(1),
      routes: <String, WidgetBuilder>{
        "/SignInPage": (BuildContext context) => SignInPage(),
        "/SignUpPage": (BuildContext context) => SignUpPage(),
        "/HomePage": (BuildContext context) => HomePage(1),
      },
    );
  }
}
