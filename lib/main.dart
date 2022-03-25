import 'package:cubby/views/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      title: 'Cubby',
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        primarySwatch: Colors.lightGreen,
        canvasColor: Colors.amberAccent,
        textTheme: const TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
          )
        )
      ),
      home: Wrapper(),
    );
  }
}
