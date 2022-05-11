import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import '../../services/firebase_crud.dart';
import '../../views/home/home.dart';

// ignore: must_be_immutable
class FoodItemFreezeCheck extends StatefulWidget {
  late FoodItem foodItem;
  late String userID;
  FoodItemFreezeCheck({required this.foodItem, required this.userID, Key? key})
      : super(key: key);
  @override
  _FoodItemFreezeCheckState createState() => _FoodItemFreezeCheckState();
}

class _FoodItemFreezeCheckState extends State<FoodItemFreezeCheck> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber[300],
      title: Text(
        'Are you sure you want\n to freeze ${widget.foodItem.name}',
        textAlign: TextAlign.center,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
      content: const Text(
        'Note: When you freeze the food item, it will move to the frozen section on your inventory and the expiry date will increase by 3 months.',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.justify,
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            widget.foodItem.setType(5);
            widget.foodItem.setExpires(
                widget.foodItem.expires.add(const Duration(days: 90)));
            FirebaseCRUD.updateFoodItem(
                widget.foodItem, 'type', widget.foodItem.type, widget.userID);
            FirebaseCRUD.updateFoodItem(widget.foodItem, 'expires',
                widget.foodItem.expires, widget.userID);
            FirebaseCRUD.updateUserFoodWasted(widget.userID);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage(1)));
            setState(() {});
          },
          child:
              const Text('Freeze Item', style: TextStyle(color: Colors.white)),
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
