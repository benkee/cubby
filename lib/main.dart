import 'package:cubby/views/authenticate/sign_up.dart';
import 'package:cubby/views/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'views/authenticate/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Cubby());
}

class Cubby extends StatelessWidget {
  const Cubby({Key? key}) : super(key: key);

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
