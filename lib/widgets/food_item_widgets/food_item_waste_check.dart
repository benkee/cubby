import 'package:flutter/material.dart';

import '../../../models/food_item.dart';
import '../../../services/firebase_crud.dart';
import '../../views/home/home.dart';

// ignore: must_be_immutable
class FoodItemWasteCheck extends StatefulWidget {
  late FoodItem foodItem;
  late String userID;
  FoodItemWasteCheck({required this.foodItem, required this.userID, Key? key})
      : super(key: key);
  @override
  _FoodItemWasteCheckState createState() => _FoodItemWasteCheckState();
}

class _FoodItemWasteCheckState extends State<FoodItemWasteCheck> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber[300],
      title: Text(
        'Are you sure you want\n to waste ${widget.foodItem.name}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      content: const Text(
        'Note: When you waste the food item, your food waste % will increase.',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.justify,
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            FirebaseCRUD.updateUserFoodWasted(widget.userID);
            FirebaseCRUD.deleteFoodItem(widget.foodItem, widget.userID);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage(1)));
            setState(() {});
          },
          child:
              const Text('Waste Item', style: TextStyle(color: Colors.white)),
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
