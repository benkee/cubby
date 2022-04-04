import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../../services/firebase_crud.dart';
import '../home/home.dart';

// ignore: must_be_immutable
class FoodItemDeleteCheck extends StatefulWidget {
  late FoodItem foodItem;
  FoodItemDeleteCheck({required this.foodItem, Key? key}) : super(key: key);
  @override
  _FoodItemInputState createState() => _FoodItemInputState();
}

class _FoodItemInputState extends State<FoodItemDeleteCheck> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber[300],
      title: const Text(
        'Delete .....',
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[]),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            FirebaseCRUD.deleteFoodItem(widget.foodItem);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage(0)));
          },
          child:
              const Text('Delete Item', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
