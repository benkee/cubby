import 'package:flutter/material.dart';

void main(){
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
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: const [
              Icon(Icons.restaurant_menu),
              SizedBox(width: 10),
              Text('Cubby Test'),
            ],
          ),
        ),
      ),
    );
  }
}
