import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import '../../services/firebase_crud.dart';
import '../../views/home/home.dart';

// ignore: must_be_immutable
class FoodItemDeleteCheck extends StatefulWidget {
  late FoodItem foodItem;
  late String userID;
  FoodItemDeleteCheck({required this.foodItem, required this.userID, Key? key})
      : super(key: key);
  @override
  _FoodItemDeleteCheckState createState() => _FoodItemDeleteCheckState();
}

class _FoodItemDeleteCheckState extends State<FoodItemDeleteCheck> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber[300],
      title: Text(
        'Are you sure you want\nto remove ${widget.foodItem.name}',
        style: const TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            FirebaseCRUD.deleteFoodItem(widget.foodItem, widget.userID);
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
